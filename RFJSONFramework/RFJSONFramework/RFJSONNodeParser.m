//
//  RFJSONNodeParser.m
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

#import "RFJSONNodeParser.h"

#import "REExtendedFoundation.h"

#import "RFJSONNodeParserPrivate.h"
#import "RFJSONNodeParserType.h"

@implementation RFJSONNodeParser

#pragma mark - Initializing a RFJSONNodeParser Class

- (id)init
{
    if ((self = [super init]))
    {
        mIsError = NO;
        mIsParserFinished = NO;
        mIsParserStarted = NO;
        mSubJSONNodeParser = nil;
        mSubJSONNodeParserDepth = 0;
    }
    
    return self;
}

#pragma mark - Dallocating a RFJSONNodeParser Class

- (void)dealloc
{
    mSubJSONNodeParser = nil;
}

#pragma mark - Managing the RFJSONNodeParser Object

- (BOOL)isError
{
    return mIsError;
}

- (void)setIsError:(BOOL)isError
{
    if (mIsError != isError)
    {
        mIsError = isError;
    }
}

@synthesize isParserFinished = mIsParserFinished;
@synthesize isParserStarted = mIsParserStarted;

#pragma mark - Handling JSON

- (void)parserStated
{
    // This stub
}

- (void)parserFinished
{
    // This stub
}

- (void)parserFoundObjectKey:(NSString*)key
{
#pragma unused(key)
    
    // This stub
}

- (void)parserFoundObjectStart
{
    // This stub
}

- (void)parserFoundObjectEnd
{
    // This stub
}

- (void)parserFoundArrayStart
{
    // This stub
}

- (void)parserFoundArrayEnd
{
    // This stub
}

- (void)parserFoundNull
{
    // This stub
}

- (void)parserFoundBoolean:(BOOL)boolean
{
#pragma unused(boolean)
    
    // This stub
}

- (void)parserFoundNumber:(NSNumber*)number
{
#pragma unused(number)
    
    // This stub
}

- (void)parserFoundString:(NSString*)string
{
#pragma unused(string)
    
    // This stub
}

#pragma mark - Private Handling JSON

- (void)_parserStated
{
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFinished
{
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundObjectKey:(NSString*)key
{
#pragma unused(key)
    
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundObjectStart
{
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundObjectEnd
{
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundArrayStart
{
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundArrayEnd
{
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundNull
{
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundBoolean:(BOOL)boolean
{
#pragma unused(boolean)
    
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundNumber:(NSNumber*)number
{
#pragma unused(number)
    
    // This stub.
    RENSAssert(NO, @"Override me!");
}

- (void)_parserFoundString:(NSString*)string
{
#pragma unused(string)
    
    // This stub.
    RENSAssert(NO, @"Override me!");
}

@end
