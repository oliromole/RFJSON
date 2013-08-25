//
//  RENSRange.h
//  REFoundation
//  https://github.com/oliromole/REFoundation.git
//
//  Created by Roman Oliichuk on 2012.06.27.
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

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN const NSRange NSRangeNotFound;
FOUNDATION_EXTERN const NSRange NSRangeZero;

NS_INLINE BOOL NSRangeIsNotFound(NSRange range)
{
    BOOL result = ((range.location == NSNotFound) && (range.length == 0));
    return result;
}

NS_INLINE BOOL NSRangeIsZero(NSRange range)
{
    BOOL result = ((range.location == 0) && (range.length == 0));
    return result;
}

NS_INLINE BOOL NSRangeEqualToRange(NSRange range1, NSRange range2)
{
    BOOL result = ((range1.location == range2.location) && (range1.length == range2.length));
    return result;
}

NS_INLINE NSRange RENSIntersectionRange(NSRange range1, NSRange range2)
{
    long long llLocation31 = ((range1.location > range2.location) ? range1.location : range2.location);
    
    long long llLocation12 = (long long)range1.location + (long long)range1.length;
    long long llLocation22 = (long long)range2.location + (long long)range2.length;
    long long llLocation32 = ((llLocation12 < llLocation22) ? llLocation12 : llLocation22);
    
    NSRange intersectedRange;
    
    if (llLocation31 <= llLocation32)
    {
        intersectedRange.location = (NSUInteger)llLocation31;
        intersectedRange.length = (NSUInteger)(llLocation32 - llLocation31);
    }
    
    else
    {
        intersectedRange = NSRangeNotFound;
    }
    
    return intersectedRange;
}
