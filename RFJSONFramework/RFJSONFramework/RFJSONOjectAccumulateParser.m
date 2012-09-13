//
//  RFJSONOjectAccumulateParser.m
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

#import "RFJSONOjectAccumulateParser.h"

#import "REExtendedFoundation.h"

#import "RFJSONArrayAccumulateParser.h"
#import "RFJSONNodeParserType.h"
#import "RFJSONNodeParserTypeProtected.h"

NSMutableDictionary *RFJSONOjectAccumulateParser_JSONObjectKeyJSONNodeParserTypes = nil;

@implementation RFJSONOjectAccumulateParser

#pragma mark - Initializing a Class

+ (void)load
{
    @autoreleasepool
    {
        RFJSONOjectAccumulateParser_JSONObjectKeyJSONNodeParserTypes = [[NSMutableDictionary alloc] init];
        [RFJSONOjectAccumulateParser_JSONObjectKeyJSONNodeParserTypes setObject:[NSMutableSet setWithObjects:
                                                                                 [NSNumber RFJSONNodeParserTypeArray],
                                                                                 [NSNumber RFJSONNodeParserTypeBool],
                                                                                 [NSNumber RFJSONNodeParserTypeNull],
                                                                                 [NSNumber RFJSONNodeParserTypeNumber],
                                                                                 [NSNumber RFJSONNodeParserTypeObject],
                                                                                 [NSNumber RFJSONNodeParserTypeString],
                                                                                 nil]
                                                                         forKey:RFJSONOjectParserAllOtherObjectKeys];
    }
}

#pragma mark - Initializing a RFJSONOjectAccumulateParser Class

- (id)init
{
    if ((self = [super init]))
    {
        [mJSONObjectKeyJSONNodeParserTypes addEntriesFromDictionary:RFJSONOjectAccumulateParser_JSONObjectKeyJSONNodeParserTypes];
        
        mJSONObject = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

#pragma mark - Dallocating a RFJSONOjectAccumulateParser Class

- (void)dealloc
{
    [mJSONObject release];
    mJSONObject = nil;
    
    [super dealloc];
}

#pragma mark - Managing the RFJSONOjectAccumulateParser Object

@synthesize jsonObject = mJSONObject;

#pragma mark - Handling JSON

- (void)parserFoundObjectStart
{
    [mSubJSONNodeParser release];
    mSubJSONNodeParser = [[RFJSONOjectAccumulateParser alloc] init];
}

- (void)parserFoundObjectEnd
{
    RFJSONOjectAccumulateParser *jsonOjectAccumulateParser = (RFJSONOjectAccumulateParser *)mSubJSONNodeParser;
    NSMutableDictionary *jsonObject = jsonOjectAccumulateParser.jsonObject;
    
    [mJSONObject setObject:jsonObject forKey:mJSONObjectKey];
}

- (void)parserFoundArrayStart
{
    [mSubJSONNodeParser release];
    mSubJSONNodeParser = [[RFJSONArrayAccumulateParser alloc] init];
}

- (void)parserFoundArrayEnd
{
    RFJSONArrayAccumulateParser *jsonArrayAccumulateParser = (RFJSONArrayAccumulateParser *)mSubJSONNodeParser;
    NSMutableArray *jsonArray = jsonArrayAccumulateParser.jsonArray;
    
    [mJSONObject setObject:jsonArray forKey:mJSONObjectKey];
}

- (void)parserFoundNull
{
    [mJSONObject setObject:[NSNull null] forKey:mJSONObjectKey];
}

- (void)parserFoundBoolean:(BOOL)boolean
{
    [mJSONObject setObject:NSNumberBoolFromBool(boolean) forKey:mJSONObjectKey];
}

- (void)parserFoundNumber:(NSNumber*)number
{
    [mJSONObject setObject:number forKey:mJSONObjectKey];
}

- (void)parserFoundString:(NSString*)string
{
    [mJSONObject setObject:string forKey:mJSONObjectKey];
}

@end
