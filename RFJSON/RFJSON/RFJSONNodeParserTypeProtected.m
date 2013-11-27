//
//  RFJSONNodeParserTypeProtected.m
//  RFJSON
//  https://github.com/oliromole/RFJSON.git
//
//  Created by Roman Oliichuk on 2013.04.23.
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
#import "RFJSONNodeParserTypeProtected.h"

// Importing the project headers.
#import "RFJSONNodeParserType.h"

// Importing the system headers.
#import <Foundation/Foundation.h>

@implementation NSNumber (NSNumberRFJSONNodeParserTypeProtected)

#pragma mark - Initializing and Creating a NSNumber

+ (id)RFJSONNodeParserTypeArray
{
    if (!RFJSONNodeParserTypeArray)
    {
        RFJSONNodeParserTypeArray = [[NSNumber alloc] initWithInt:1];
    }
    
    return RFJSONNodeParserTypeArray;
}

+ (id)RFJSONNodeParserTypeBool
{
    if (!RFJSONNodeParserTypeBool)
    {
        RFJSONNodeParserTypeBool = [[NSNumber alloc] initWithInt:2];
    }
    
    return RFJSONNodeParserTypeBool;
}

+ (id)RFJSONNodeParserTypeNull
{
    if (!RFJSONNodeParserTypeNull)
    {
        RFJSONNodeParserTypeNull = [[NSNumber alloc] initWithInt:3];
    }
    
    return RFJSONNodeParserTypeNull;
}

+ (id)RFJSONNodeParserTypeNumber
{
    if (!RFJSONNodeParserTypeNumber)
    {
        RFJSONNodeParserTypeNumber = [[NSNumber alloc] initWithInt:4];
    }
    
    return RFJSONNodeParserTypeNumber;
}

+ (id)RFJSONNodeParserTypeObject
{
    if (!RFJSONNodeParserTypeObject)
    {
        RFJSONNodeParserTypeObject = [[NSNumber alloc] initWithInt:5];
    }
    
    return RFJSONNodeParserTypeObject;
}

+ (id)RFJSONNodeParserTypeString
{
    if (!RFJSONNodeParserTypeString)
    {
        RFJSONNodeParserTypeString = [[NSNumber alloc] initWithInt:6];
    }
    
    return RFJSONNodeParserTypeString;
}

@end
