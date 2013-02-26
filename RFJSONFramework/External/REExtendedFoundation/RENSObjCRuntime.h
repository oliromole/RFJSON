//
//  RENSObjCRuntime.h
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
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

#import "RWObjCWrapper.h"

NS_INLINE NSComparisonResult NSInvertComparisonResult(NSComparisonResult comparisonResult)
{
    NSComparisonResult invertedComparisonResult;
    
    if (comparisonResult < NSOrderedSame)
    {
        invertedComparisonResult = NSOrderedDescending;
    }
    
    else if (comparisonResult > NSOrderedSame)
    {
        invertedComparisonResult = NSOrderedAscending;
    }
    
    else
    {
        invertedComparisonResult = NSOrderedSame;
    }
    
    return invertedComparisonResult;
}

NS_INLINE NSComparisonResult NSComparisonResultFromCComparisonResult(int cComparisonResult)
{
    NSComparisonResult nsComparisonResult;
    
    if (cComparisonResult < 0)
    {
        nsComparisonResult = NSOrderedAscending;
    }
    
    else if (cComparisonResult > 0)
    {
        nsComparisonResult = NSOrderedDescending;
    }
    
    else
    {
        nsComparisonResult = NSOrderedSame;
    }
    
    return nsComparisonResult;
}

NS_INLINE int CComparisonResultFromNSComparisonResult(NSComparisonResult nsComparisonResult)
{
    int cComparisonResult;
    
    if (nsComparisonResult < NSOrderedSame)
    {
        cComparisonResult = -1;
    }
    
    else if (nsComparisonResult > NSOrderedSame)
    {
        cComparisonResult = 1;
    }
    
    else
    {
        cComparisonResult = 0;
    }
    
    return cComparisonResult;
}

NS_INLINE int vmax(int count, int value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    int maxValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        int value = va_arg(valist, int);
        
        if (maxValue < value)
        {
            maxValue = value;
        }
    }
    
    va_end(valist);
    
    return maxValue;
}

NS_INLINE unsigned int uvmax(int count, unsigned int value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    unsigned int maxValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        unsigned int value = va_arg(valist, unsigned int);
        
        if (maxValue < value)
        {
            maxValue = value;
        }
    }
    
    va_end(valist);
    
    return maxValue;
}

NS_INLINE long lvmax(int count, long value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    long maxValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        long value = va_arg(valist, long);
        
        if (maxValue < value)
        {
            maxValue = value;
        }
    }
    
    va_end(valist);
    
    return maxValue;
}

NS_INLINE unsigned long ulvmax(int count, long value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    unsigned long maxValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        unsigned long value = va_arg(valist, unsigned long);
        
        if (maxValue < value)
        {
            maxValue = value;
        }
    }
    
    va_end(valist);
    
    return maxValue;
}

NS_INLINE long long llvmax(int count, long long value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    long long maxValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        long long value = va_arg(valist, long long);
        
        if (maxValue < value)
        {
            maxValue = value;
        }
    }
    
    va_end(valist);
    
    return maxValue;
}

NS_INLINE unsigned long long ullvmax(int count, long long value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    unsigned long long maxValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        unsigned long long value = va_arg(valist, unsigned long long);
        
        if (maxValue < value)
        {
            maxValue = value;
        }
    }
    
    va_end(valist);
    
    return maxValue;
}

NS_INLINE float fvmaxf(int count, double value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    float maxValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        float value = (float)va_arg(valist, double);
        
        if (maxValue < value)
        {
            maxValue = value;
        }
    }
    
    va_end(valist);
    
    return maxValue;
}

NS_INLINE double fvmax(int count, double value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    double maxValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        double value = va_arg(valist, double);
        
        if (maxValue < value)
        {
            maxValue = value;
        }
    }
    
    va_end(valist);
    
    return maxValue;
}

NS_INLINE int vmin(int count, int value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    int minValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        int value = va_arg(valist, int);
        
        if (minValue > value)
        {
            minValue = value;
        }
    }
    
    va_end(valist);
    
    return minValue;
}

NS_INLINE unsigned int uvmin(int count, unsigned int value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    unsigned int minValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        unsigned int value = va_arg(valist, unsigned int);
        
        if (minValue > value)
        {
            minValue = value;
        }
    }
    
    va_end(valist);
    
    return minValue;
}

NS_INLINE long lvmin(int count, long value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    long minValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        long value = va_arg(valist, long);
        
        if (minValue > value)
        {
            minValue = value;
        }
    }
    
    va_end(valist);
    
    return minValue;
}

NS_INLINE unsigned long ulvmin(int count, long value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    unsigned long minValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        unsigned long value = va_arg(valist, unsigned long);
        
        if (minValue > value)
        {
            minValue = value;
        }
    }
    
    va_end(valist);
    
    return minValue;
}

NS_INLINE long long llvmin(int count, long long value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    long long minValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        long long value = va_arg(valist, long long);
        
        if (minValue > value)
        {
            minValue = value;
        }
    }
    
    va_end(valist);
    
    return minValue;
}

NS_INLINE unsigned long long ullvmin(int count, long long value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    unsigned long long minValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        unsigned long long value = va_arg(valist, unsigned long long);
        
        if (minValue > value)
        {
            minValue = value;
        }
    }
    
    va_end(valist);
    
    return minValue;
}

NS_INLINE float fvminf(int count, double value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    float minValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        float value = (float)va_arg(valist, double);
        
        if (minValue > value)
        {
            minValue = value;
        }
    }
    
    va_end(valist);
    
    return minValue;
}

NS_INLINE double fvmin(int count, double value0, ...)
{
    va_list valist;
    va_start(valist, value0);
    
    double minValue = value0;
    
    for (int index = 1; index < count; index++)
    {
        double value = va_arg(valist, double);
        
        if (minValue > value)
        {
            minValue = value;
        }
    }
    
    va_end(valist);
    
    return minValue;
}
