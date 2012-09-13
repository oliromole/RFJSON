//
//  REBase256.m
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2010.10.09.
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

#import "REBase256.h"

@implementation NSString (NSStringREBase256)

#pragma mark - Methods of Base256

- (NSData *)copyDecodeBase256
{
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    
    NSUInteger length = self.length;

    BOOL hasError = NO;
    
    if ((length % 2) != 0)
    {
        hasError = YES;
    }
    
    else
    {
        for (NSInteger index = 0; index < length; index += 2)
        {
            unichar character0 = [self characterAtIndex:index];
            unichar character1 = [self characterAtIndex:index + 1];
            
            unsigned int value0 = 0;
            unsigned int value1 = 0;
            
            if ((character0 >= L'0') && (character0 <= L'9'))
            {
                value0 = character0 - L'0';
            }

            else if ((character0 >= L'A') && (character0 <= L'F'))
            {
                value0 = 10 + (character0 - L'A');
            }

            else if ((character0 >= L'a') && (character0 <= L'f'))
            {
                value0 = 10 + (character0 - L'a');
            }
            
            else
            {
                hasError = YES;
                break;
            }
            
            if ((character1 >= L'0') && (character1 <= L'9'))
            {
                value1 = character1 - L'0';
            }
            
            else if ((character1 >= L'A') && (character1 <= L'F'))
            {
                value1 = 10 + (character1 - L'A');
            }
            
            else if ((character1 >= L'a') && (character1 <= L'f'))
            {
                value1 = 10 + (character1 - L'a');
            }
            
            else
            {
                hasError = YES;
                break;
            }
            
            unsigned int value = (((value0 & 0xF) << 4) | (value1 & 0xF));
            
            [mutableData appendBytes:&value length:1];
        }
    }
    
    NSData *data = nil;
    
    if (!hasError)
    {
        data = [mutableData copy];
    }
    
    [mutableData release];
    mutableData = nil;
    
    return data;
}

- (NSData *)decodeBase256
{
    NSData *data = [[self copyDecodeBase256] autorelease];
    return data;
}

@end

@implementation NSData (NSDateREBase256)

#pragma mark - Methods of Base256

- (NSString *)copyEncodeBase256
{
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    const unsigned char *bytes = (const unsigned char *)self.bytes;
    NSUInteger length = self.length;
    
    for (NSUInteger index = 0; index < length; index++)
    {
        [mutableString appendFormat:@"%02x", (unsigned int)bytes[index]];
    }
    
    NSString *string = [mutableString copy];
    
    [mutableString release];
    mutableString = nil;
    
    return string;
}

- (NSString *)encodeBase256
{
    NSString *string = [[self copyEncodeBase256] autorelease];
    return string;
}

@end
