//
//  RENSStream.m
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2012.07.22.
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

#import "RENSStream.h"

@implementation NSInputStream (NSInputStreamRENSInputStream)

#pragma mark - Using Streams

- (NSInteger)readAllBuffer:(uint8_t *)buffer maxLength:(NSUInteger)bufferLength
{
    NSInteger bytesRead = 0;
    
    do
    {
        NSInteger result = [self read:(buffer + bytesRead) maxLength:(bufferLength - (NSUInteger)bytesRead)];
        
        if (result < 0)
        {
            if (bytesRead == 0)
            {
                bytesRead = result;
            }
            
            break;
        }
        
        bytesRead += result;
    } while (bytesRead < (NSInteger)bufferLength);
    
    return bytesRead;
}

@end

@implementation NSOutputStream (NSOutputStreamRWNSOutputStream)

#pragma mark - Using Streams

- (NSInteger)writeAllBuffer:(const uint8_t *)buffer maxLength:(NSUInteger)bufferLength
{
    NSInteger bytesWritten = 0;
    
    do
    {
        NSInteger result = [self write:(buffer + bytesWritten) maxLength:(bufferLength - (NSUInteger)bytesWritten)];
        
        if (result < 0)
        {
            if (bytesWritten == 0)
            {
                bytesWritten = result;
            }
            
            break;
        }
        
        bytesWritten += result;
    } while (bytesWritten < (NSInteger)bufferLength);
    
    return bytesWritten;
}

- (NSInteger)writeData:(NSData *)data
{
    if (!data)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"The data argument is nil." userInfo:nil];
    }
    
    NSInteger result = [self writeAllBuffer:(const uint8_t *)data.bytes maxLength:data.length];
    
    return result;
}

@end
