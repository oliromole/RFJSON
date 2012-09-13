//
//  RENSObject.m
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2012.07.237.
//  Copyright (c) 2012 Roman Oliichuk. All rights reserved.
//

/*
 Copyright (C) 2012 Roman Oliichuk. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors
 may be used to endorse or promote products derived from this
 software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
 */

#import "RENSObject.h"

#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>

static NSMutableDictionary * * NSObject_ObjectDictionary_HashTable = NULL;
static int                     NSObject_ObjectDictionary_HashTable_Length = 0;
static id                    * NSObject_ObjectDictionary_IgnoredObjects = nil;
static int                     NSObject_ObjectDictionary_IgnoredObjects_Length = 0;
static int                     NSObject_ObjectDictionary_IgnoredObjects_Capacity = 0;
static int                     NSObject_ObjectDictionary_IgnoredObjects_Cranularity = 16;
static CFTypeID                NSObject_ObjectDictionary_ObjectTypeID = 0;
static NSObject              * NSObject_ObjectDictionary_Synchronizer = nil;

static void (* NSObject_ObjectDictionary_PreviousDealloc)(id, SEL) = NULL;

#define NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LENGTH (1 << 14)
#define NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_INDEX_OF_OBJECT(object) (((((int)object) >> 0) & 0x00003FFF) ^ ((((int)object) >> 14) & 0x00003FFF) ^ ((((int)object) >> 28) & 0x00003FFF))

static void NSObject_ObjectDictionary_Dealloc(id self, SEL _cmd);

void NSObject_ObjectDictionary_IgnoredObjects_AddObject(id object)
{
    if (object)
    {
        if (NSObject_ObjectDictionary_IgnoredObjects_Length == NSObject_ObjectDictionary_IgnoredObjects_Capacity)
        {
            NSObject_ObjectDictionary_IgnoredObjects_Capacity += NSObject_ObjectDictionary_IgnoredObjects_Cranularity;
            
            id *newIgnoredObjects = malloc(sizeof(id) * NSObject_ObjectDictionary_IgnoredObjects_Capacity);
            
            if (!newIgnoredObjects)
            {
                @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
            }
            
            if (newIgnoredObjects)
            {
                memset(newIgnoredObjects, 0, (sizeof(id) * NSObject_ObjectDictionary_IgnoredObjects_Capacity));
                memcpy(newIgnoredObjects, NSObject_ObjectDictionary_IgnoredObjects, (sizeof(id) * NSObject_ObjectDictionary_IgnoredObjects_Length));
                
                free(NSObject_ObjectDictionary_IgnoredObjects);
                NSObject_ObjectDictionary_IgnoredObjects = newIgnoredObjects;
            }            
        }
        
        if (NSObject_ObjectDictionary_IgnoredObjects_Length < NSObject_ObjectDictionary_IgnoredObjects_Capacity)
        {
            NSObject_ObjectDictionary_IgnoredObjects[NSObject_ObjectDictionary_IgnoredObjects_Length] = object;
            NSObject_ObjectDictionary_IgnoredObjects_Length++;
        }
    }
}

bool NSObject_ObjectDictionary_IgnoredObjects_ContainsObject(id object)
{
    bool containsObject = false;
    
    if (object)
    {
        for (int indexOfIgnoredObject = NSObject_ObjectDictionary_IgnoredObjects_Length - 1; indexOfIgnoredObject > -1; indexOfIgnoredObject--)
        {
            id ignoredObject = NSObject_ObjectDictionary_IgnoredObjects[indexOfIgnoredObject];
            
            if (ignoredObject == object)
            {
                containsObject = true;
                break;
            }
        }
    }
    
    return containsObject;
}

void NSObject_ObjectDictionary_IgnoredObjects_RemoveObject(id object)
{
    if (object)
    {
        for (int indexOfIgnoredObject = NSObject_ObjectDictionary_IgnoredObjects_Length - 1; indexOfIgnoredObject > -1; indexOfIgnoredObject--)
        {
            id ignoredObject = NSObject_ObjectDictionary_IgnoredObjects[indexOfIgnoredObject];
            
            if (ignoredObject == object)
            {
                int indexOfIgnoredObject2 = indexOfIgnoredObject;
                
                for (; (indexOfIgnoredObject2 + 1) < NSObject_ObjectDictionary_IgnoredObjects_Length; indexOfIgnoredObject2++)
                {
                    NSObject_ObjectDictionary_IgnoredObjects[indexOfIgnoredObject2] =  NSObject_ObjectDictionary_IgnoredObjects[indexOfIgnoredObject2 + 1];
                }

                NSObject_ObjectDictionary_IgnoredObjects[indexOfIgnoredObject2] =  nil;

                NSObject_ObjectDictionary_IgnoredObjects_Length--;
                
                break;
            }
        }
    }
}

static void NSObject_ObjectDictionary_Dealloc(id self, SEL _cmd)
{
    if (NSObject_ObjectDictionary_HashTable_Length > 0)
    {
        int index = NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_INDEX_OF_OBJECT(self);
        
        NSMutableDictionary *objectDictionaries = NSObject_ObjectDictionary_HashTable[index];
        
        if (objectDictionaries)
        {
            @synchronized(NSObject_ObjectDictionary_Synchronizer)
            {
                if (!NSObject_ObjectDictionary_IgnoredObjects_ContainsObject(self))
                {
                    NSValue *key = [[NSValue alloc] initWithBytes:&self objCType:@encode(void *)];
                    
                    if (!key)
                    {
                        @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
                    }
                    
                    else
                    {
                        NSMutableDictionary *objectDictionary = [objectDictionaries objectForKey:key];
                        
                        if (objectDictionary)
                        {
                            [objectDictionaries removeObjectForKey:key];
                            
                            if (objectDictionaries.count == 0)
                            {
                                NSObject_ObjectDictionary_HashTable[index] = NULL;

                                NSObject_ObjectDictionary_IgnoredObjects_AddObject(objectDictionaries);
                                [objectDictionaries release];
                                NSObject_ObjectDictionary_IgnoredObjects_RemoveObject(objectDictionary);
                                objectDictionaries = nil;
                            }
                        }
                    }
                
                    NSObject_ObjectDictionary_IgnoredObjects_AddObject(key);
                    [key release];
                    NSObject_ObjectDictionary_IgnoredObjects_RemoveObject(key);
                    key = nil;
                }
            }
        }
    }
    
    if (NSObject_ObjectDictionary_PreviousDealloc)
    {
        NSObject_ObjectDictionary_PreviousDealloc(self, _cmd);
    }
}

@implementation NSObject (NSObjectRENSObject)

#pragma mark - Initializing a Class

+ (void)load
{
    NSObject_ObjectDictionary_Synchronizer = [[NSObject alloc] init];
}

#pragma mark - Managing the NSObject Information

- (NSMutableDictionary *)objectDictionary;
{
    NSMutableDictionary *objectDictionary = nil;
    
    @synchronized(NSObject_ObjectDictionary_Synchronizer)
    {
        if (NSObject_ObjectDictionary_HashTable_Length == 0)
        {
            NSObject *object = [[NSObject alloc] init];

            if (object)
            {
                NSObject_ObjectDictionary_ObjectTypeID = CFGetTypeID((CFTypeRef)object);
            }

            else
            {
                @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
            }

            [object release];
            object = nil;
            
            NSObject_ObjectDictionary_HashTable = malloc(sizeof(NSMutableDictionary *) * NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LENGTH);
            
            if (!NSObject_ObjectDictionary_HashTable)
            {
                @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
            }

            if (NSObject_ObjectDictionary_HashTable)
            {
                memset(NSObject_ObjectDictionary_HashTable, 0, (sizeof(NSMutableArray *) * NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LENGTH));
                NSObject_ObjectDictionary_HashTable_Length = NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LENGTH;
            }
            
            BOOL result = class_addMethod([NSObject class], @selector(dealloc), (IMP)NSObject_ObjectDictionary_Dealloc, "v8@0:4");
            
            if (!result)
            {
                NSObject_ObjectDictionary_PreviousDealloc = (void (*)(id, SEL))class_replaceMethod([NSObject class], @selector(dealloc), (IMP)NSObject_ObjectDictionary_Dealloc, "v8@0:4");
            }
        }
        
        if (NSObject_ObjectDictionary_HashTable_Length != 0)
        {
            CFTypeID objectType = CFGetTypeID((CFTypeRef)self);
            
            if (objectType != NSObject_ObjectDictionary_ObjectTypeID)
            {
                NSMutableString *classString = [[NSMutableString alloc] init];
                
                if (!classString)
                {
                    @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
                }

                else
                {
                    Class objectClass = [self class];
                    
                    while (objectClass)
                    {
                        const char *cObjectClassName = class_getName(objectClass);
                        
                        if (cObjectClassName)
                        {
                            NSString *nsObjectClassName = [[NSString alloc] initWithUTF8String:cObjectClassName];
                            
                            if (!nsObjectClassName)
                            {
                                [classString release];
                                classString = nil;
                                
                                @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
                            }

                            else
                            {
                                if (classString.length == 0)
                                {
                                    [classString appendString:nsObjectClassName];
                                }
                                
                                else
                                {
                                    [classString appendString:@" : "];
                                    [classString appendString:nsObjectClassName];
                                }
                            }
                            
                            [nsObjectClassName release];
                            nsObjectClassName = nil;
                        }
                        
                        objectClass = class_getSuperclass(objectClass);
                    }
                }
                
                [classString release];
                classString = nil;
                
                NSLog(@"WARNING: %@ is Core Foundation class. The %@ method returns nil for Core Foundation classes.", classString, NSStringFromSelector(_cmd));
            }
            
            else
            {
                int index = NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_INDEX_OF_OBJECT(self);
                
                NSMutableDictionary *objectDictionaries = NSObject_ObjectDictionary_HashTable[index];
                
                if (!objectDictionaries)
                {
                    objectDictionaries = [[NSMutableDictionary alloc] init];
                    
                    if (!objectDictionaries)
                    {
                        @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
                    }
                    
                    NSObject_ObjectDictionary_HashTable[index] = objectDictionaries;
                }
                
                if (objectDictionaries)
                {
                    NSValue *key = [[NSValue alloc] initWithBytes:&self objCType:@encode(void *)];
                    
                    if (!key)
                    {
                        @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
                    }

                    else
                    {
                        objectDictionary = [objectDictionaries objectForKey:key];
                        
                        if (!objectDictionary)
                        {
                            objectDictionary = [[NSMutableDictionary alloc] init];
                            
                            [objectDictionaries setObject:objectDictionary forKey:key];
                            
                            [objectDictionary release];
                        }
                    }
                
                    [key release];
                    key = nil;
                }
            }
        }
    }

    return objectDictionary;
}

#pragma mark - Identifying and Comparing the Reference of Objects

- (NSComparisonResult)compareReference:(id)object
{
    NSComparisonResult comparisonResult;
    
    if (self < object)
    {
        comparisonResult = NSOrderedAscending;
    }
    
    else if (self > object)
    {
        comparisonResult = NSOrderedDescending;
    }
    
    else
    {
        comparisonResult = NSOrderedSame;
    }
    
    return comparisonResult;
}

- (BOOL)isReferenceEqual:(id)object
{
    BOOL isReferenceEqual  = (self == object);
    return isReferenceEqual;
}

- (NSUInteger)referenceHash
{
    NSUInteger referenceHash = (NSUInteger)self;
    return referenceHash;
}

#pragma mark - Sending Messages

- (id)performSelector:(SEL)selector withObject:(id)object0 withObject:(id)object1 withObject:(id)object2
{
    IMP implementation = [self methodForSelector:selector];
    
    if (!implementation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: unrecognized selector sent to instance %p", NSStringFromClass(self.class), NSStringFromSelector(selector), self] userInfo:nil];
    }
    
    id returnValue = implementation(self, selector, object0, object1, object2);
    return returnValue;
}

- (id)performSelector:(SEL)selector withObject:(id)object0 withObject:(id)object1 withObject:(id)object2 withObject:(id)object3
{
    IMP implementation = [self methodForSelector:selector];
    
    if (!implementation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: unrecognized selector sent to instance %p", NSStringFromClass(self.class), NSStringFromSelector(selector), self] userInfo:nil];
    }
    
    id returnValue = implementation(self, selector, object0, object1, object2, object3);
    return returnValue;
}

- (id)performSelector:(SEL)selector withObject:(id)object0 withObject:(id)object1 withObject:(id)object2 withObject:(id)object3 withObject:(id)object4
{
    IMP implementation = [self methodForSelector:selector];
    
    if (!implementation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: unrecognized selector sent to instance %p", NSStringFromClass(self.class), NSStringFromSelector(selector), self] userInfo:nil];
    }
    
    id returnValue = implementation(self, selector, object0, object1, object2, object3, object4);
    return returnValue;
}

@end
