//
//  RENSData.m
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2012.12.06.
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

#import "RENSData.h"

#import "RENSException.h"

void *RECDataCreateWithNSData(NSData *nsData, void *(*mallocFuntion)(size_t))
{
    RENSCAssert(mallocFuntion, @"The mallocFuntion argument is NULL.");
    
    void *cData = NULL;
    
    if (nsData)
    {
        NSUInteger nsDataLength = nsData.length;
        
        cData = mallocFuntion(nsDataLength);
        
        if (cData)
        {
            NSRange nsRange;
            nsRange.location = 0;
            nsRange.length = nsDataLength;
            
            [nsData getBytes:cData range:nsRange];
        }
    }
    
    return cData;
    
}

NSData *RENSDataCreateWithCData(const void *cData, int numberOfBytes)
{
    NSData *nsData = NULL;
    
    if (cData)
    {
        if (numberOfBytes >= 0)
        {
            nsData = [[NSData alloc] initWithBytes:cData length:(NSUInteger)numberOfBytes];
        }
    }
    
    return nsData;
}

NSMutableData *RENSMutableDataCreateWithCData(const void *cData, int numberOfBytes)
{
    NSMutableData *nsData = NULL;
    
    if (cData)
    {
        if (numberOfBytes >= 0)
        {
            nsData = [[NSMutableData alloc] initWithBytes:cData length:(NSUInteger)numberOfBytes];
        }
    }
    
    return nsData;
}
