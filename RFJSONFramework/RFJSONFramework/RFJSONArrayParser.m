//
//  RFJSONArrayParser.m
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

#import "RFJSONArrayParser.h"

#import "RFJSONArraySkipParser.h"
#import "RFJSONNodeParserPrivate.h"
#import "RFJSONNodeParserType.h"
#import "RFJSONOjectSkipParser.h"

@implementation RFJSONArrayParser

#pragma mark - Initializing a RFJSONArrayParser Class

- (id)init
{
    if ((self = [super init]))
    {
        mJSONNodeParserTypes = [[NSMutableSet alloc] init];
    }
    
    return self;
}

#pragma mark - Deallocating a RFJSONArrayParser Class

- (void)dealloc
{
    RENSObjectRelease(mJSONNodeParserTypes);
    mJSONNodeParserTypes = nil;
    
    RENSObjectSuperDealloc();
}

#pragma mark - Private Handling JSON

- (void)_parserStated
{
    mIsParserStarted = YES;
    
    [self parserStated];
}

- (void)_parserFinished
{
    mIsParserFinished = YES;
    
    [self parserFinished];
}

- (void)_parserFoundObjectKey:(NSString*)key
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            [mSubJSONNodeParser _parserFoundObjectKey:key];
            
            if (mSubJSONNodeParser.isError)
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

- (void)_parserFoundObjectStart
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            mSubJSONNodeParserDepth++;
            
            [mSubJSONNodeParser _parserFoundObjectStart];
            
            if (mSubJSONNodeParser.isError)
            {
                self.isError = YES;
            }
        }
        
        else
        {
            mSubJSONNodeParserDepth = 1;
            
            if (mJSONNodeParserTypes && ([mJSONNodeParserTypes count] > 0))
            {
                if ([mJSONNodeParserTypes containsObject:RFJSONNodeParserTypeObject])
                {
                    [self parserFoundObjectStart];
                }
                
                else
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
            
            if (!mIsError && !mSubJSONNodeParser)
            {
                RENSObjectRelease(mSubJSONNodeParser);
                mSubJSONNodeParser = [[RFJSONOjectSkipParser alloc] init];
            }
            
            if (!mIsError && mSubJSONNodeParser)
            {
                [mSubJSONNodeParser _parserStated];
                
                if (mSubJSONNodeParser.isError)
                {
                    self.isError = YES;
                }
            }
        }
    }
}

- (void)_parserFoundObjectEnd
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            mSubJSONNodeParserDepth--;
            
            if (mSubJSONNodeParserDepth == 0)
            {
                [mSubJSONNodeParser _parserFinished];
                
                if (mSubJSONNodeParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                [mSubJSONNodeParser _parserFoundObjectEnd];
                
                if (mSubJSONNodeParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            if (!mIsError && mSubJSONNodeParser.isParserFinished)
            {
                if (mJSONNodeParserTypes && ([mJSONNodeParserTypes count] > 0))
                {
                    if ([mJSONNodeParserTypes containsObject:RFJSONNodeParserTypeObject])
                    {
                        [self parserFoundObjectEnd];
                    }
                    
                    else
                    {
                        self.isError = YES;
                    }
                }
                
                else
                {
                    self.isError = YES;
                }
                
                RENSObjectRelease(mSubJSONNodeParser);
                mSubJSONNodeParser = nil;
            }
        }
        
        else
        {
            self.isError = YES;
        }
    }
}

- (void)_parserFoundArrayStart
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            mSubJSONNodeParserDepth++;
            
            [mSubJSONNodeParser _parserFoundArrayStart];
            
            if (mSubJSONNodeParser.isError)
            {
                self.isError = YES;
            }
        }
        
        else
        {
            mSubJSONNodeParserDepth = 1;
            
            if (mJSONNodeParserTypes && ([mJSONNodeParserTypes count] > 0))
            {
                if ([mJSONNodeParserTypes containsObject:RFJSONNodeParserTypeArray])
                {
                    [self parserFoundArrayStart];
                }
                
                else
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                self.isError = YES;
            }
            
            if (!mIsError && !mSubJSONNodeParser)
            {
                RENSObjectRelease(mSubJSONNodeParser);
                mSubJSONNodeParser = [[RFJSONArraySkipParser alloc] init];
            }
            
            if (!mIsError && mSubJSONNodeParser)
            {
                [mSubJSONNodeParser _parserStated];
                
                if (mSubJSONNodeParser.isError)
                {
                    self.isError = YES;
                }
            }
        }
    }
}

- (void)_parserFoundArrayEnd
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            mSubJSONNodeParserDepth--;
            
            if (mSubJSONNodeParserDepth == 0)
            {
                [mSubJSONNodeParser _parserFinished];
                
                if (mSubJSONNodeParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            else
            {
                [mSubJSONNodeParser _parserFoundArrayEnd];
                
                if (mSubJSONNodeParser.isError)
                {
                    self.isError = YES;
                }
            }
            
            if (!mIsError && mSubJSONNodeParser.isParserFinished)
            {
                if (mJSONNodeParserTypes && ([mJSONNodeParserTypes count] > 0))
                {
                    if ([mJSONNodeParserTypes containsObject:RFJSONNodeParserTypeArray])
                    {
                        [self parserFoundArrayEnd];
                    }
                    
                    else
                    {
                        self.isError = YES;
                    }
                }
                
                else
                {
                    self.isError = YES;
                }
                
                RENSObjectRelease(mSubJSONNodeParser);
                mSubJSONNodeParser = nil;
            }
        }
        
        else
        {
            self.isError = YES;
        }
    }
}

- (void)_parserFoundNull
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            [mSubJSONNodeParser _parserFoundNull];
            
            if (mSubJSONNodeParser.isError)
            {
                self.isError = YES;
            }
        }
        
        else
        {
            if (mJSONNodeParserTypes && ([mJSONNodeParserTypes count] > 0))
            {
                if ([mJSONNodeParserTypes containsObject:RFJSONNodeParserTypeNull])
                {
                    [self parserFoundNull];
                }
                
                else
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

- (void)_parserFoundBoolean:(BOOL)boolean
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            [mSubJSONNodeParser _parserFoundBoolean:boolean];
            
            if (mSubJSONNodeParser.isError)
            {
                self.isError = YES;
            }
        }
        
        else
        {
            if (mJSONNodeParserTypes && ([mJSONNodeParserTypes count] > 0))
            {
                if ([mJSONNodeParserTypes containsObject:RFJSONNodeParserTypeBool])
                {
                    [self parserFoundBoolean:boolean];
                }
                
                else
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

- (void)_parserFoundNumber:(NSNumber*)number
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            [mSubJSONNodeParser _parserFoundNumber:number];
            
            if (mSubJSONNodeParser.isError)
            {
                self.isError = YES;
            }
        }
        
        else
        {
            if (mJSONNodeParserTypes && ([mJSONNodeParserTypes count] > 0))
            {
                if ([mJSONNodeParserTypes containsObject:RFJSONNodeParserTypeNumber])
                {
                    [self parserFoundNumber:number];
                }
                
                else
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

- (void)_parserFoundString:(NSString*)string
{
    if (!mIsError)
    {
        if (mSubJSONNodeParser)
        {
            [mSubJSONNodeParser _parserFoundString:string];
            
            if (mSubJSONNodeParser.isError)
            {
                self.isError = YES;
            }
        }
        
        else
        {
            if (mJSONNodeParserTypes && ([mJSONNodeParserTypes count] > 0))
            {
                if ([mJSONNodeParserTypes containsObject:RFJSONNodeParserTypeString])
                {
                    [self parserFoundString:string];
                }
                
                else
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
