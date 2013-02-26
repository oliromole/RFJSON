//
//  RENSDictionary.m
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2012.06.26.
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

#import "RENSDictionary.h"

#import <objc/runtime.h>

@implementation NSDictionary (NSDictionaryRENSDictionary)

#pragma mark - Accessing Keys and Values

- (NSDictionary *)dictionaryWithKeys:(NSArray *)keys
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:(keys ? keys.count : 0)];
    
    for (id key in keys)
    {
        id object = [self objectForKey:key];
        
        if (object)
        {
            [dictionary setObject:object forKey:key];
        }
    }
    
    return dictionary;
}

- (NSDictionary *)dictionaryWithKeys:(NSArray *)keys notFoundMarker:(id)marker
{
    if (!marker)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"*** -[NSDictionary dictionaryForKeys:notFoundMarker:]: marker cannot be nil" userInfo:nil];
    }
    
    NSMutableDictionary *dictionary = [self mutableCopy];
    
    for (id key in keys)
    {
        id object = [self objectForKey:key];
        
        if (object)
        {
            [dictionary setObject:object forKey:key];
        }
        
        else
        {
            [dictionary setObject:marker forKey:key];
        }
    }
    
    return dictionary;
}

@end

static id NSDictionary_ObjectForKeyedSubscript(NSDictionary *self, SEL _cmd, id key)
{
    printf("a");
    id object = [self objectForKey:key];
    return object;
}

@implementation NSDictionary (NSDictionaryRENSDictionary_6_0)

+ (void)load
{
    class_addMethod([NSDictionary class], @selector(objectForKeyedSubscript:), (IMP)NSDictionary_ObjectForKeyedSubscript, "@12@0:4@8");
}

@end

@implementation NSMutableDictionary (NSMutableDictionaryRENSMutableDictionary)

#pragma mark - Removing Entries From a Mutable Dictionary

- (void)removeAllObjectsExceptObjectsForKeys:(NSArray *)keys
{
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] initWithCapacity:(keys ? keys.count : 0)];
    
    for (id key in keys)
    {
        id object = [self objectForKey:key];
        
        if (object)
        {
            [mutableDictionary setObject:object forKey:key];
        }
    }
    
    [self removeAllObjects];
    [self setDictionary:mutableDictionary];
}

@end

static void NSMutableDictionary_setObject_ForKeyedSubscript(NSMutableDictionary *self, SEL _cmd, id object, id<NSCopying> key)
{
    [self setObject:object forKey:key];
}

@implementation NSMutableDictionary (NSMutableDictionaryRENSMutableDictionary_6_0_Dynamic)

+ (void)load
{
    class_addMethod([NSDictionary class], @selector(setObject:forKeyedSubscript:), (IMP)NSMutableDictionary_setObject_ForKeyedSubscript, "v16@0:4@8@12");
}

@end
