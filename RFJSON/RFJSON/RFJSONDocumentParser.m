//
//  RFJSONDocument.m
//  RFJSON
//  https://github.com/oliromole/RFJSON.git
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

// Importing the header.
#import "RFJSONDocumentParser.h"

// Importing the project headers.
#import "RFJSONNodeParserPrivate.h"
#import "RFJSONOjectParser.h"

// Importing the external headers.
#import <SBJson/SBJson.h>

// Importing the system headers.
#import <Foundation/Foundation.h>

@implementation RFJSONDocument

#pragma mark - Initializing the RFJSONDocument Class

- (id)init
{
    if ((self = [super init]))
    {
        mIsError = NO;
        mIsParserFinished = NO;
        mIsParserStarted = NO;
        
        mRootJSONOjectParser = nil;
        mJSONStreamParser = nil;
    }
    
    return self;
}

#pragma mark - Deallocating the RFJSONDocument Class

- (void)dealloc
{
    mRootJSONOjectParser = nil;
    
    mJSONStreamParser.delegate = self;
    mJSONStreamParser = nil;
}

#pragma mark - Managing the RFJSONDocument Object

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

@synthesize isParserStarted = mIsParserStarted;
@synthesize isParserFinished = mIsParserFinished;

@synthesize rootJSONOjectParser = mRootJSONOjectParser;

- (SBJsonStreamParser *)jsonStreamParser
{
    return mJSONStreamParser;
}

- (void)setJsonStreamParser:(SBJsonStreamParser *)jsonStreamParser
{
    if (mJSONStreamParser != jsonStreamParser)
    {
        mJSONStreamParser.delegate = nil;
        mJSONStreamParser = jsonStreamParser;
        mJSONStreamParser.delegate = self;
    }
}

#pragma mark - Conforming the SBJsonStreamParserDelegate Protocol

- (void)parser:(SBJsonStreamParser*)parser foundObjectKey:(NSString*)key
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            if (mRootJSONOjectParser.isParserStarted)
            {
                [mRootJSONOjectParser _parserFoundObjectKey:key];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
        }
    }
}

- (void)parserFoundObjectStart:(SBJsonStreamParser*)parser
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            mSubJSONNodeDepth++;
            
            if (mSubJSONNodeDepth == 1)
            {
                [mRootJSONOjectParser _parserStated];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                [mRootJSONOjectParser _parserFoundObjectStart];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
        }
    }
}

- (void)parserFoundObjectEnd:(SBJsonStreamParser*)parser
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            mSubJSONNodeDepth--;
            
            if (mSubJSONNodeDepth == 0)
            {
                [mRootJSONOjectParser _parserFinished];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                [mRootJSONOjectParser _parserFoundObjectEnd];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
        }
    }
}

- (void)parserFoundArrayStart:(SBJsonStreamParser*)parser
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            mSubJSONNodeDepth++;
            
            if (mRootJSONOjectParser.isParserStarted)
            {
                [mRootJSONOjectParser _parserFoundArrayStart];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
        }
    }
}

- (void)parserFoundArrayEnd:(SBJsonStreamParser*)parser
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            mSubJSONNodeDepth--;
            
            if (mRootJSONOjectParser.isParserStarted)
            {
                [mRootJSONOjectParser _parserFoundArrayEnd];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
        }
    }
}

- (void)parserFoundNull:(SBJsonStreamParser*)parser
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            if (mRootJSONOjectParser.isParserStarted)
            {
                [mRootJSONOjectParser _parserFoundNull];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
        }
    }
}

- (void)parser:(SBJsonStreamParser*)parser foundBoolean:(BOOL)boolean
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            if (mRootJSONOjectParser.isParserStarted)
            {
                [mRootJSONOjectParser _parserFoundBoolean:boolean];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
        }
    }
}

- (void)parser:(SBJsonStreamParser*)parser foundNumber:(NSNumber*)number
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            if (mRootJSONOjectParser.isParserStarted)
            {
                [mRootJSONOjectParser _parserFoundNumber:number];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
        }
    }
}

- (void)parser:(SBJsonStreamParser*)parser foundString:(NSString*)string
{
    if (parser && (parser == mJSONStreamParser))
    {
        if (!mIsError)
        {
            if (mRootJSONOjectParser.isParserStarted)
            {
                [mRootJSONOjectParser _parserFoundString:string];
                
                if (mRootJSONOjectParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
        }
    }
}

@end
