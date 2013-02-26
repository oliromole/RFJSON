//
//  RFJSONArrayAccumulateParser.m
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

#import "RFJSONArrayAccumulateParser.h"

#import "REExtendedFoundation.h"

#import "RFJSONNodeParserType.h"
#import "RFJSONOjectAccumulateParser.h"

static NSSet * volatile RFJSONArrayAccumulateParser_JSONNodeParserTypes = nil;

@implementation RFJSONArrayAccumulateParser

#pragma mark - Initializing and Creating a RFJSONArrayAccumulateParser

- (id)init
{
    if ((self = [super init]))
    {
        mJSONArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Deallocating a RFJSONArrayAccumulateParser

- (void)dealloc
{
    mJSONArray = nil;
}

#pragma mark - Managing the RFJSONArrayAccumulateParser Object

@synthesize jsonArray = mJSONArray;

#pragma mark - Handling JSON

- (void)parserFoundObjectStart
{
    mSubJSONNodeParser = [[RFJSONOjectAccumulateParser alloc] init];
}

- (void)parserFoundObjectEnd
{
    RFJSONOjectAccumulateParser *jsonOjectAccumulateParser = (RFJSONOjectAccumulateParser *)mSubJSONNodeParser;
    NSMutableDictionary *jsonObject = jsonOjectAccumulateParser.jsonObject;
    
    [mJSONArray addObject:jsonObject];
}

- (void)parserFoundArrayStart
{
    mSubJSONNodeParser = [[RFJSONArrayAccumulateParser alloc] init];
}

- (void)parserFoundArrayEnd
{
    RFJSONArrayAccumulateParser *jsonArrayAccumulateParser = (RFJSONArrayAccumulateParser *)mSubJSONNodeParser;
    NSMutableArray *jsonArray = jsonArrayAccumulateParser.jsonArray;
    
    [mJSONArray addObject:jsonArray];
}

- (void)parserFoundNull
{
    [mJSONArray addObject:[NSNull null]];
}

- (void)parserFoundBoolean:(BOOL)boolean
{
    [mJSONArray addObject:NSNumberBoolFromBool(boolean)];
}

- (void)parserFoundNumber:(NSNumber*)number
{
    [mJSONArray addObject:number];
}

- (void)parserFoundString:(NSString*)string
{
    [mJSONArray addObject:string];
}

#pragma mark - Conforming the NSObjectRFJSONArrayParser Protocol

#pragma mark Getting JSONNodeParserTypes

+ (NSSet *)jsonNodeParserTypes
{
    if (!RFJSONArrayAccumulateParser_JSONNodeParserTypes)
    {
        NSObject *singletonSynchronizer = [NSObject singletonSynchronizer];
        
        @synchronized(singletonSynchronizer)
        {
            if (!RFJSONArrayAccumulateParser_JSONNodeParserTypes)
            {
                NSMutableSet *jsonNodeParserTypes = [[RFJSONArrayParser jsonNodeParserTypes] mutableCopy];
                RENSAssert(jsonNodeParserTypes, @"The method has a logical error.");
                
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeArray];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeBool];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeNull];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeNumber];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeObject];
                [jsonNodeParserTypes addObject:RFJSONNodeParserTypeString];
                
                RFJSONArrayAccumulateParser_JSONNodeParserTypes = [jsonNodeParserTypes copy];
            }
        }
    }
    
    return RFJSONArrayAccumulateParser_JSONNodeParserTypes;
}

@end
