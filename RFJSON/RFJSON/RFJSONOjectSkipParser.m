//
//  RFJSONOjectSkipParser.m
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
#import "RFJSONOjectSkipParser.h"

// Importing the external headers.
#import <REFoundation/REFoundation.h>

// Importing the system headers.
#import <Foundation/Foundation.h>

static NSDictionary * volatile RFJSONOjectSkipParser_JSONObjectKeyJSONNodeParserTypes = nil;

@implementation RFJSONOjectSkipParser

#pragma mark - Initializing a RFJSONOjectSkipParser Class

- (id)init
{
    if ((self = [super init]))
    {
    }
    
    return self;
}

#pragma mark - Deallocating a RFJSONOjectSkipParser Class

- (void)dealloc
{
}

#pragma mark - Conforming the NSObjectRFJSONOjectParser Protocol

#pragma mark Getting JSONNodeParserTypes for JSONObjectKeys

+ (NSDictionary *)jsonObjectKeyJSONNodeParserTypes
{
    if (!RFJSONOjectSkipParser_JSONObjectKeyJSONNodeParserTypes)
    {
        NSObject *singletonSynchronizer = [NSObject singletonSynchronizer];
        
        @synchronized(singletonSynchronizer)
        {
            if (!RFJSONOjectSkipParser_JSONObjectKeyJSONNodeParserTypes)
            {
                NSMutableDictionary *jsonObjectKeyJSONNodeParserTypes = [[RFJSONOjectParser jsonObjectKeyJSONNodeParserTypes] mutableCopy];
                RENSAssert(jsonObjectKeyJSONNodeParserTypes, @"The method has a logical error.");
                
                RFJSONOjectSkipParser_JSONObjectKeyJSONNodeParserTypes = [jsonObjectKeyJSONNodeParserTypes copy];
            }
        }
    }
    
    return RFJSONOjectSkipParser_JSONObjectKeyJSONNodeParserTypes;
}

@end
