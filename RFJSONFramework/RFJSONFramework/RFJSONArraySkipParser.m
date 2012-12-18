//
//  RFJSONArraySkipParser.m
//  RFJSONFramework
//  https://github.com/oliromole/RFJSONFramework.git
//
//  Created by Roman Oliichuk on 2012.02.17.
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

#import "RFJSONArraySkipParser.h"

#import "REExtendedFoundation.h"

#import "RFJSONNodeParserType.h"

static NSSet * volatile RFJSONArraySkipParser_JSONNodeParserTypes = nil;

@implementation RFJSONArraySkipParser

#pragma mark - Initializing a RFJSONArraySkip Class

- (id)init
{
    if ((self = [super init]))
    {
    }
    
    return self;
}

#pragma mark - Deallocaating a RFJSONArraySkip Class

- (void)dealloc
{
    RENSObjectSuperDealloc();
}

#pragma mark - Conforming the NSObjectRFJSONArrayParser Protocol

#pragma mark Getting JSONNodeParserTypes

+ (NSSet *)jsonNodeParserTypes
{
    if (!RFJSONArraySkipParser_JSONNodeParserTypes)
    {
        NSObject *singletonSynchronizer = [NSObject singletonSynchronizer];
        
        @synchronized(singletonSynchronizer)
        {
            if (!RFJSONArraySkipParser_JSONNodeParserTypes)
            {
                NSMutableSet *jsonNodeParserTypes = [[RFJSONArrayParser jsonNodeParserTypes] mutableCopy];
                NSAssert(jsonNodeParserTypes, @"The method has a logical error.");
                
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeArray];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeBool];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeNull];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeNumber];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeObject];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeString];
                
                RFJSONArraySkipParser_JSONNodeParserTypes = [jsonNodeParserTypes copy];
                
                RENSObjectRelease(jsonNodeParserTypes);
                jsonNodeParserTypes = nil;
            }
        }
    }
    
    return RFJSONArraySkipParser_JSONNodeParserTypes;
}

@end
