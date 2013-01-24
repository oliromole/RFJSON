//
//  RENSObject.m
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2012.07.23.
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

#import <pthread.h>

#import "REExtendedFoundation.h"

static NSObject * volatile NSObject_SingletonSynchronizer = nil;

typedef struct RENSObjectDictionaryHashTableLevel1
{
    CFTypeRef              objectRef;
    CFMutableDictionaryRef objectDictionaryRef;
} RENSObjectDictionaryHashTableLevel1;

typedef struct RENSObjectDictionaryHashTableLevel0
{
    RENSObjectDictionaryHashTableLevel1 *level1s;
    unsigned int                         level1sCount;
    unsigned int                         level1sLength;
} RENSObjectDictionaryHashTableLevel0;

static RENSObjectDictionaryHashTableLevel0 *NSObject_ObjectDictionary_HashTableLevel0s = NULL;
static BOOL                                 NSObject_ObjectDictionary_Initialized = NO;
static pthread_mutex_t                      NSObject_ObjectDictionary_Mutext;
static CFTypeID                             NSObject_ObjectDictionary_ObjectTypeID = 0;

static void (* NSObject_ObjectDictionary_PreviousDealloc)(id, SEL) = NULL;

#define NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LEVEL0S_LENGTH (1 << 14)

#define NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LEVEL0S_INDEX_OF_OBJECT(object) ( \
((((unsigned int)object) >> 0) & 0x00003FFF) ^ \
((((unsigned int)object) >> 14) & 0x00003FFF) ^ \
((((unsigned int)object) >> 28) & 0x00003FFF))

static void NSObject_ObjectDictionary_Dealloc(id self, SEL _cmd);

static void NSObject_ObjectDictionary_Dealloc(id self, SEL _cmd)
{
    unsigned int hashTableLevel0sIndex = NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LEVEL0S_INDEX_OF_OBJECT(self);
    RENSObjectDictionaryHashTableLevel0 *hashTableLevel0 = NSObject_ObjectDictionary_HashTableLevel0s + hashTableLevel0sIndex;
    
    if (hashTableLevel0->level1sCount > 0)
    {
        NSMutableDictionary *objectDictionary = nil;
        int                  result = 0;
        
        result = pthread_mutex_lock(&NSObject_ObjectDictionary_Mutext);
        NSCAssert((result == 0), @"The NSObject_ObjectDictionary_Dealloc funcation can not lock the mutex.");
        
        RENSObjectDictionaryHashTableLevel1 *hashTableLevel1Start = hashTableLevel0->level1s;
        RENSObjectDictionaryHashTableLevel1 *hashTableLevel1End = hashTableLevel1Start + hashTableLevel0->level1sLength;
        
        RENSObjectDictionaryHashTableLevel1 *hashTableLevel1 = hashTableLevel1Start;
        
        while (hashTableLevel1 < hashTableLevel1End)
        {
            if (hashTableLevel1->objectRef == RECMBridge(CFTypeRef, self))
            {
                objectDictionary = RECMBridgeTransfer(NSMutableDictionary *, hashTableLevel1->objectDictionaryRef);
                
                hashTableLevel1->objectRef = NULL;
                hashTableLevel1->objectDictionaryRef = NULL;
                
                hashTableLevel0->level1sCount--;
                
                if (hashTableLevel0->level1sCount == 0)
                {
                    free(hashTableLevel0->level1s);
                    hashTableLevel0->level1s = NULL;
                    hashTableLevel0->level1sLength = 0;
                }
                
                break;
            }
            
            hashTableLevel1++;
        }
        
        result = pthread_mutex_unlock(&NSObject_ObjectDictionary_Mutext);
        NSCAssert((result == 0), @"The NSObject_ObjectDictionary_Dealloc funcation can not unlock the mutex.");
        
        if (objectDictionary)
        {
            RENSObjectRelease(objectDictionary);
            objectDictionary = nil;
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
    NSObject_SingletonSynchronizer = [[NSObject alloc] init];
    
    pthread_mutexattr_t mutextAttr;
    int                 result = 0;
    
    result = pthread_mutexattr_init(&mutextAttr);
    RENSAssert((result == 0), @"The NSObject (NSObjectRENSObject) category can not initialize a mutex attribute.");
    
    result = pthread_mutexattr_setpshared(&mutextAttr, PTHREAD_PROCESS_PRIVATE );
    RENSAssert((result == 0), @"The NSObject (NSObjectRENSObject) category can not set a process-shared of the mutex attribute.");
    
    result = pthread_mutexattr_settype(&mutextAttr, PTHREAD_MUTEX_NORMAL);
    RENSAssert((result == 0), @"The NSObject (NSObjectRENSObject) category can not set a type of the mutex attribute.");
    
    result = pthread_mutex_init(&NSObject_ObjectDictionary_Mutext, &mutextAttr);
    RENSAssert((result == 0), @"The NSObject (NSObjectRENSObject) category can not initialize a mutex.");
    
    result = pthread_mutexattr_destroy(&mutextAttr);
    RENSAssert((result == 0), @"The NSObject (NSObjectRENSObject) category can not destroy the mutex attribute.");
}

#pragma mark - Synchronizing the Singleton

+ (NSObject *)singletonSynchronizer
{
    RENSAssert(NSObject_SingletonSynchronizer, @"The %@ class is incorrectly used.", NSStringFromClass([self class]));
    
    return NSObject_SingletonSynchronizer;
}

#pragma mark - Managing the NSObject Information

- (NSMutableDictionary *)objectDictionary
{
    NSMutableDictionary *objectDictionary = nil;
    int                  result = 0;
    
    result = pthread_mutex_lock(&NSObject_ObjectDictionary_Mutext);
    RENSAssert((result == 0), @"The %@ method can not lock the mutex.", NSStringFromSelector(_cmd));
    
    if (!NSObject_ObjectDictionary_Initialized)
    {
        NSObject *object = [[NSObject alloc] init];
        RENSAssert(object, @"The %@ method can not create a object.", NSStringFromSelector(_cmd));
        
        NSObject_ObjectDictionary_ObjectTypeID = CFGetTypeID(RECMBridge(CFTypeRef, object));
        
        RENSObjectRelease(object);
        object = nil;
        
        NSObject_ObjectDictionary_HashTableLevel0s = (RENSObjectDictionaryHashTableLevel0 *)malloc(sizeof(RENSObjectDictionaryHashTableLevel0) * NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LEVEL0S_LENGTH);
        RENSAssert(NSObject_ObjectDictionary_HashTableLevel0s, @"The %@ method can not alloc memory.", NSStringFromSelector(_cmd));
        
        memset(NSObject_ObjectDictionary_HashTableLevel0s, 0, (sizeof(RENSObjectDictionaryHashTableLevel0) * NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LEVEL0S_LENGTH));
        
        BOOL success = class_addMethod([NSObject class], NSSelectorFromString(@"dealloc"), (IMP)NSObject_ObjectDictionary_Dealloc, "v8@0:4");
        
        if (!success)
        {
            NSObject_ObjectDictionary_PreviousDealloc = (void (*)(id, SEL))class_replaceMethod([NSObject class], NSSelectorFromString(@"dealloc"), (IMP)NSObject_ObjectDictionary_Dealloc, "v8@0:4");
        }
        
        NSObject_ObjectDictionary_Initialized = YES;
    }
    
    CFTypeID objectType = CFGetTypeID(RECMBridge(CFTypeRef, self));
    
    if (objectType != NSObject_ObjectDictionary_ObjectTypeID)
    {
        NSLog(@"WARNING: The %@ class is Core Foundation class. The %@ method returns nil for Core Foundation classes.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    
    else
    {
        unsigned int hashTableLevel0sIndex = NS_OBJECT_OBJECT_DICTIONARY_HASH_TABLE_LEVEL0S_INDEX_OF_OBJECT(self);
        RENSObjectDictionaryHashTableLevel0 *hashTableLevel0 = NSObject_ObjectDictionary_HashTableLevel0s + hashTableLevel0sIndex;
        
        RENSObjectDictionaryHashTableLevel1 *hashTableLevel1Start = hashTableLevel0->level1s;
        RENSObjectDictionaryHashTableLevel1 *hashTableLevel1End = hashTableLevel1Start + hashTableLevel0->level1sLength;
        
        RENSObjectDictionaryHashTableLevel1 *hashTableLevel1 = hashTableLevel1Start;
        
        while (hashTableLevel1 < hashTableLevel1End)
        {
            if (hashTableLevel1->objectRef == RECMBridge(CFTypeRef, self))
            {
                objectDictionary = RECMBridge(NSMutableDictionary *, hashTableLevel1->objectDictionaryRef);
                
                break;
            }
            
            hashTableLevel1++;
        }
        
        if (!objectDictionary)
        {
            RENSObjectDictionaryHashTableLevel1 *hashTableLevel1 = hashTableLevel1Start;
            
            while (hashTableLevel1 < hashTableLevel1End)
            {
                if (hashTableLevel1->objectRef == NULL)
                {
                    hashTableLevel1->objectRef = RECMBridge(CFTypeRef, self);
                    hashTableLevel1->objectDictionaryRef = RECMBridgeRetained(CFMutableDictionaryRef, [[NSMutableDictionary alloc] init]);
                    
                    objectDictionary = RECMBridge(NSMutableDictionary *, hashTableLevel1->objectDictionaryRef);
                    
                    hashTableLevel0->level1sCount++;
                    
                    RENSAssert((hashTableLevel0->level1sCount <= hashTableLevel0->level1sLength), @"The %@ method has a logical error.", NSStringFromSelector(_cmd));
                    
                    break;
                }
                
                hashTableLevel1++;
            }
        }
        
        if (!objectDictionary)
        {
            RENSAssert((hashTableLevel0->level1sCount == hashTableLevel0->level1sLength), @"The %@ method has a logical error.", NSStringFromSelector(_cmd));
            
            RENSObjectDictionaryHashTableLevel1 *hashTableLevel1s = (RENSObjectDictionaryHashTableLevel1 *)malloc(sizeof(RENSObjectDictionaryHashTableLevel1) * (hashTableLevel0->level1sLength + 1));
            RENSAssert(hashTableLevel1s, @"The %@ method can not alloc memory.", NSStringFromSelector(_cmd));
            
            memcpy(hashTableLevel1s, hashTableLevel0->level1s, (sizeof(RENSObjectDictionaryHashTableLevel1) * hashTableLevel0->level1sLength));
            
            hashTableLevel1 = hashTableLevel1s + hashTableLevel0->level1sLength;
            hashTableLevel1->objectRef = RECMBridge(CFTypeRef, self);
            hashTableLevel1->objectDictionaryRef = RECMBridgeRetained(CFMutableDictionaryRef, [[NSMutableDictionary alloc] init]);
            
            objectDictionary = RECMBridge(NSMutableDictionary *, hashTableLevel1->objectDictionaryRef);
            
            free(hashTableLevel0->level1s);
            hashTableLevel0->level1s = hashTableLevel1s;
            
            hashTableLevel0->level1sCount++;
            hashTableLevel0->level1sLength++;
        }
    }
    
    result = pthread_mutex_unlock(&NSObject_ObjectDictionary_Mutext);
    RENSAssert((result == 0), @"The %@ method can not unlock the mutex.", NSStringFromSelector(_cmd));
    
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

+ (NSComparisonResult)compareLeftObjectReference:(id)leftObject rightObjectReference:(id)rightObject
{
    NSComparisonResult comparisonResult;
    
    if (leftObject < rightObject)
    {
        comparisonResult = NSOrderedAscending;
    }
    
    else if (leftObject > rightObject)
    {
        comparisonResult = NSOrderedDescending;
    }
    
    else
    {
        comparisonResult = NSOrderedSame;
    }
    
    return comparisonResult;
}

+ (BOOL)isEqualLeftObject:(id)leftObject rightObject:(id)rightObject
{
    BOOL isEqual = (leftObject == rightObject);
    
    if (isEqual && leftObject && rightObject)
    {
        isEqual = [leftObject isEqual:rightObject];
    }
    
    return isEqual;
}

+ (BOOL)isEqualLeftObjectReference:(id)leftObject rightObjectReference:(id)rightObject
{
    BOOL isEqual = (leftObject == rightObject);
    return isEqual;
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
