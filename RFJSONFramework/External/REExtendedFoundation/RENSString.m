//
//  RENSString.m
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

#import "RENSString.h"

@implementation NSString (NSStringRENSString)

#pragma mark - Getting a String’s Range

- (NSRange)range
{
    NSRange range;
    range.location = 0;
    range.length = self.length;
    
    return range;
}

#pragma mar - Getting a Substring

- (NSString *)copySubstringFromIndex:(NSUInteger)from
{
    NSUInteger length = self.length;
    
    if (from > length)
    {
        @throw [NSException exceptionWithName:NSRangeException reason:@"The from argument is invalid." userInfo:nil];
    }
    
    NSRange range;
    range.location = from;
    range.length = length - from;
    
    NSString *string = [self copySubstringWithRange:range];
    
    return string;
}

- (NSString *)copySubstringToIndex:(NSUInteger)to
{
    NSUInteger length = self.length;
    
    if (to > length)
    {
        @throw [NSException exceptionWithName:NSRangeException reason:@"The to argument is invalid." userInfo:nil];
    }
    
    NSRange range;
    range.location = 0;
    range.length = to;
    
    NSString *string = [self copySubstringWithRange:range];
    
    return string;
}

- (NSString *)copySubstringWithRange:(NSRange)range
{
    if (NSMaxRange(range) > self.length)
    {
        @throw [NSException exceptionWithName:NSRangeException reason:@"The range argument is invalid." userInfo:nil];
    }
    
    unichar *characters = malloc(range.length * sizeof(unichar));
    
    if (!characters)
    {
        @throw [NSException exceptionWithName:NSMallocException reason:@"Low memory." userInfo:nil];
    }
    
    [self getCharacters:characters range:range];
    
    NSString *string = [[NSString alloc] initWithCharactersNoCopy:characters length:range.length freeWhenDone:YES];
    
    return string;
}

#pragma mark - Trimming a String

- (NSString *)copyStringByTrimming
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *string = [self copyStringByTrimmingCharactersInSet:characterSet];
    
    return string;
}

- (NSString *)stringByTrimming
{
    NSString *string = [[self copyStringByTrimming] autorelease];
    return string;
}

- (NSString *)copyStringByTrimmingLeft
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *string = [self copyStringByTrimmingLeftCharactersInSet:characterSet];
    
    return string;
}

- (NSString *)stringByTrimmingLeft
{
    NSString *string = [[self copyStringByTrimmingLeft] autorelease];
    return string;
}

- (NSString *)copyStringByTrimmingRight
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *string = [self copyStringByTrimmingRightCharactersInSet:characterSet];
    
    return string;
}

- (NSString *)stringByTrimmingRight
{
    NSString *string = [[self copyStringByTrimmingRight] autorelease];
    return string;
}

- (NSString *)copyStringByTrimmingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSString *timmedString = nil;
    
    if (characterSet)
    {
        NSRange range;
        range.location = 0;
        range.length = self.length;
        
        // Trimming right.
        
        while (range.length > 0)
        {
            NSUInteger index = NSMaxRange(range) - 1;
            unichar character = [self characterAtIndex:index];
            
            if (![characterSet characterIsMember:character])
            {
                break;
            }
            
            range.length -= 1;
        }
        
        // Trimming left.
        
        while (range.length > 0)
        {
            NSUInteger index = range.location;
            unichar character = [self characterAtIndex:index];
            
            if (![characterSet characterIsMember:character])
            {
                break;
            }
            
            range.location += 1;
            range.length -= 1;
        }
        
        // Copying a substring in the range.
        
        timmedString = [self copySubstringWithRange:range];
    }
    
    return timmedString;
}

- (NSString *)stringByTrimmingCharactersInSet:(NSCharacterSet *)characterSet
{
    NSString *string = [[self copyStringByTrimmingCharactersInSet:characterSet] autorelease];
    return string;
}

- (NSString *)copyStringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet
{
    NSString *timmedString = nil;
    
    if (characterSet)
    {
        NSRange range;
        range.location = 0;
        range.length = self.length;
        
        while (range.length > 0)
        {
            NSUInteger index = range.location;
            unichar character = [self characterAtIndex:index];
            
            if (![characterSet characterIsMember:character])
            {
                break;
            }
            
            range.location += 1;
            range.length -= 1;
        }
        
        // Copying a substring in the range.
        
        timmedString = [self copySubstringWithRange:range];
    }
    
    return timmedString;
}

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet
{
    NSString *string = [[self copyStringByTrimmingLeftCharactersInSet:characterSet] autorelease];
    return string;
}

- (NSString *)copyStringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet
{
    NSString *timmedString = nil;
    
    if (characterSet)
    {
        NSRange range;
        range.location = 0;
        range.length = self.length;
        
        while (range.length > 0)
        {
            NSUInteger index = NSMaxRange(range) - 1;
            unichar character = [self characterAtIndex:index];
            
            if (![characterSet characterIsMember:character])
            {
                break;
            }
            
            range.length -= 1;
        }
        
        // Copying a substring in the range.
        
        timmedString = [self copySubstringWithRange:range];
    }
    
    return timmedString;
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet
{
    NSString *string = [[self copyStringByTrimmingRightCharactersInSet:characterSet] autorelease];
    return string;
}

- (NSString *)copyStringByTrimmingStrings:(NSString *)string0, ...
{
    NSString *trimmedString = nil;
    
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        trimmedString = [self copyStringByTrimmingStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
    
    return trimmedString;
}

- (NSString *)stringByTrimmingStrings:(NSString *)string0, ...
{
    NSString *trimmedString = nil;
    
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        trimmedString = [self stringByTrimmingStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
    
    return trimmedString;
}

- (NSString *)copyStringByTrimmingLeftStrings:(NSString *)string0, ...
{
    NSString *trimmedString = nil;
    
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        trimmedString = [self copyStringByTrimmingLeftStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
    
    return trimmedString;
}

- (NSString *)stringByTrimmingLeftStrings:(NSString *)string0, ...
{
    NSString *trimmedString = nil;
    
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        trimmedString = [self stringByTrimmingLeftStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
    
    return trimmedString;
}

- (NSString *)copyStringByTrimmingRightStrings:(NSString *)string0, ...
{
    NSString *trimmedString = nil;
    
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        trimmedString = [self copyStringByTrimmingRightStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
    
    return trimmedString;
}

- (NSString *)stringByTrimmingRightStrings:(NSString *)string0, ...
{
    NSString *trimmedString = nil;
    
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        trimmedString = [self stringByTrimmingRightStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
    
    return trimmedString;
}

- (NSString *)copyStringByTrimmingStringsInSet:(NSSet *)stringSet
{
    NSString *timmedString = nil;
    
    if (stringSet)
    {
        NSRange range;
        range.location = 0;
        range.length = self.length;
        
        BOOL stoped;
        
        // Trimming right.
        
        stoped = NO;
        
        while (!stoped && (range.length > 0))
        {
            stoped = YES;
            
            for (NSString *string in stringSet)
            {
                if ([self hasSuffix:string range:range])
                {
                    NSUInteger stringLength = string.length;
                    
                    if (stringLength > 0)
                    {
                        range.length -= stringLength;
                        
                        stoped = NO;
                    }
                }
            }
        }
        
        // Trimming left.
        
        stoped = NO;
        
        while (!stoped && (range.length > 0))
        {
            stoped = YES;
            
            for (NSString *string in stringSet)
            {
                if ([self hasPrefix:string range:range])
                {
                    NSUInteger stringLength = string.length;
                    
                    if (stringLength > 0)
                    {
                        range.location += stringLength;
                        range.length -= stringLength;
                        
                        stoped = NO;
                    }
                }
            }
        }

        // Copying a substring in the range.
        
        timmedString = [self copySubstringWithRange:range];
    }
    
    return timmedString;
}

- (NSString *)stringByTrimmingStringsInSet:(NSSet *)stringSet
{
    NSString *string = [[self copyStringByTrimmingStringsInSet:stringSet] autorelease];
    return string;
}

- (NSString *)copyStringByTrimmingLeftStringsInSet:(NSSet *)stringSet
{
    NSString *timmedString = nil;
    
    if (stringSet)
    {
        NSRange range;
        range.location = 0;
        range.length = self.length;
        
        BOOL stoped;
        
        // Trimming left.
        
        stoped = NO;
        
        while (!stoped && (range.length > 0))
        {
            stoped = YES;
            
            for (NSString *string in stringSet)
            {
                if ([self hasPrefix:string range:range])
                {
                    NSUInteger stringLength = string.length;
                    
                    if (stringLength > 0)
                    {
                        range.location += stringLength;
                        range.length -= stringLength;
                        
                        stoped = NO;
                    }
                }
            }
        }
        
        // Copying a substring in the range.
        
        timmedString = [self copySubstringWithRange:range];
    }
    
    return timmedString;
}

- (NSString *)stringByTrimmingLeftStringsInSet:(NSSet *)stringSet
{
    NSString *string = [[self copyStringByTrimmingLeftStringsInSet:stringSet] autorelease];
    return string;
}

- (NSString *)copyStringByTrimmingRightStringsInSet:(NSSet *)stringSet
{
    NSString *timmedString = nil;
    
    if (stringSet)
    {
        NSRange range;
        range.location = 0;
        range.length = self.length;
        
        BOOL stoped;
        
        // Trimming right.
        
        stoped = NO;
        
        while (!stoped && (range.length > 0))
        {
            stoped = YES;
            
            for (NSString *string in stringSet)
            {
                if ([self hasSuffix:string range:range])
                {
                    NSUInteger stringLength = string.length;
                    
                    if (stringLength > 0)
                    {
                        range.length -= stringLength;
                        
                        stoped = NO;
                    }
                }
            }
        }
        
        // Copying a substring in the range.
        
        timmedString = [self copySubstringWithRange:range];
    }
    
    return timmedString;
}

- (NSString *)stringByTrimmingRightStringsInSet:(NSSet *)stringSet
{
    NSString *string = [[self copyStringByTrimmingRightStringsInSet:stringSet] autorelease];
    return string;
}

#pragma mark - Identifying and Comparing Strings

+ (NSComparisonResult)compareLeftString:(NSString *)leftString rightString:(NSString *)rightString
{
    NSComparisonResult comparisonResult;
    
    if (leftString && rightString)
    {
        comparisonResult = [leftString compare:rightString];
    }
    
    else if (!leftString && rightString)
    {
        comparisonResult = NSOrderedAscending;
    }
    
    else if (leftString && !rightString)
    {
        comparisonResult = NSOrderedDescending;
    }

    // !leftString && !rightString
    else
    {
        comparisonResult = NSOrderedSame;
    }
    
    return comparisonResult;
}

+ (NSComparisonResult)compareLeftString:(NSString *)leftString rightString:(NSString *)rightString options:(NSStringCompareOptions)options
{
    NSComparisonResult comparisonResult;
    
    if (leftString && rightString)
    {
        comparisonResult = [leftString compare:rightString options:options];
    }
    
    else if (!leftString && rightString)
    {
        comparisonResult = NSOrderedAscending;
    }
    
    else if (leftString && !rightString)
    {
        comparisonResult = NSOrderedDescending;
    }
    
    // !leftString && !rightString
    else
    {
        comparisonResult = NSOrderedSame;
    }
    
    return comparisonResult;
}

+ (NSComparisonResult)caseIdenticalCompareLeftString:(NSString *)leftString rightString:(NSString *)rightString
{
    NSComparisonResult comparisonResult;
    
    if (leftString && rightString)
    {
        comparisonResult = [leftString caseIdenticalCompare:rightString];
    }
    
    else if (!leftString && rightString)
    {
        comparisonResult = NSOrderedAscending;
    }
    
    else if (leftString && !rightString)
    {
        comparisonResult = NSOrderedDescending;
    }
    
    // !leftString && !rightString
    else
    {
        comparisonResult = NSOrderedSame;
    }
    
    return comparisonResult;
}

+ (NSComparisonResult)caseInsensitiveCompareLeftString:(NSString *)leftString rightString:(NSString *)rightString
{
    NSComparisonResult comparisonResult;
    
    if (leftString && rightString)
    {
        comparisonResult = [leftString caseInsensitiveCompare:rightString];
    }
    
    else if (!leftString && rightString)
    {
        comparisonResult = NSOrderedAscending;
    }
    
    else if (leftString && !rightString)
    {
        comparisonResult = NSOrderedDescending;
    }
    
    // !leftString && !rightString
    else
    {
        comparisonResult = NSOrderedSame;
    }
    
    return comparisonResult;
}

+ (NSComparisonResult)localizedCompareLeftString:(NSString *)leftString rightString:(NSString *)rightString
{
    NSComparisonResult comparisonResult;
    
    if (leftString && rightString)
    {
        comparisonResult = [leftString localizedCompare:rightString];
    }
    
    else if (!leftString && rightString)
    {
        comparisonResult = NSOrderedAscending;
    }
    
    else if (leftString && !rightString)
    {
        comparisonResult = NSOrderedDescending;
    }
    
    // !leftString && !rightString
    else
    {
        comparisonResult = NSOrderedSame;
    }
    
    return comparisonResult;
}

+ (NSComparisonResult)localizedCaseInsensitiveCompareLeftString:(NSString *)leftString rightString:(NSString *)rightString
{
    NSComparisonResult comparisonResult;
    
    if (leftString && rightString)
    {
        comparisonResult = [leftString localizedCaseInsensitiveCompare:rightString];
    }
    
    else if (!leftString && rightString)
    {
        comparisonResult = NSOrderedAscending;
    }
    
    else if (leftString && !rightString)
    {
        comparisonResult = NSOrderedDescending;
    }
    
    // !leftString && !rightString
    else
    {
        comparisonResult = NSOrderedSame;
    }
    
    return comparisonResult;
}

- (NSComparisonResult)caseIdenticalCompare:(NSString *)rightString
{
    NSComparisonResult comparisonResult = NSOrderedDescending;
    
    if (rightString)
    {
        NSUInteger leftStringLength = self.length;
        NSUInteger rightStringLength = rightString.length;
        
        NSUInteger stringLength = MIN(leftStringLength, rightStringLength);
        
        comparisonResult = NSOrderedSame;
        
        NSUInteger index = 0;
        
        for (; index < stringLength; index++)
        {
            unichar leftCharacter = [self characterAtIndex:index];
            unichar rightCharacter = [rightString characterAtIndex:index];
            
            if (leftCharacter < rightCharacter)
            {
                comparisonResult = NSOrderedAscending;
                break;
            }
            
            else if (leftCharacter > rightCharacter)
            {
                comparisonResult = NSOrderedDescending;
                break;
            }
        }
        
        if (index == stringLength)
        {
            if (leftStringLength < rightStringLength)
            {
                comparisonResult = NSOrderedAscending;
            }
            
            else if (leftStringLength > rightStringLength)
            {
                comparisonResult = NSOrderedDescending;
            }
        }
    }
    
    return comparisonResult;
}

- (BOOL)hasPrefix:(NSString *)prefix range:(NSRange)range
{
    NSUInteger maxRange = NSMaxRange(range);
    
    if (maxRange > self.length)
    {
        @throw [NSException exceptionWithName:NSRangeException reason:@"The range argument is invalid." userInfo:nil];
    }
    
    BOOL hasPrefix = NO;
    
    NSUInteger prefixLength = prefix.length;
    
    if ((prefixLength > 0) && (prefixLength <= maxRange))
    {
        hasPrefix = YES;
        
        for (NSUInteger index = 0; index < prefixLength; index++)
        {
            unichar character1 = [self characterAtIndex:(range.location + index)];
            unichar character2 = [prefix characterAtIndex:index];
            
            if (character1 != character2)
            {
                hasPrefix = NO;
                break;
            }
        }
    }
    
    return hasPrefix;
}

- (BOOL)hasSuffix:(NSString *)suffix range:(NSRange)range
{
    NSUInteger maxRange = NSMaxRange(range);
    
    if (maxRange > self.length)
    {
        @throw [NSException exceptionWithName:NSRangeException reason:@"The range argument is invalid." userInfo:nil];
    }
    
    BOOL hasSuffix = NO;
    
    NSUInteger suffixLength = suffix.length;
    
    if ((suffixLength > 0) && (suffixLength <= maxRange))
    {
        hasSuffix = YES;
        
        for (NSUInteger index = 0; index < suffixLength; index++)
        {
            unichar character1 = [self characterAtIndex:(maxRange - index - 1)];
            unichar character2 = [suffix characterAtIndex:(suffixLength - index - 1)];
            
            if (character1 != character2)
            {
                hasSuffix = NO;
                break;
            }
        }
    }
    
    return hasSuffix;
}

#pragma mark - Working with Encodings

- (NSData *)dataUsingUTF8StringEncoding
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

@end

@implementation NSMutableString (NSMutableStringRENSMutableString)

#pragma mark - Modifying a String

- (void)deleteAllCharacters
{
    NSRange range;
    range.location = 0;
    range.length = self.length;
    
    [self deleteCharactersInRange:range];
}

#pragma mark - Trimming a String

- (void)trim
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    [self trimCharactersInSet:characterSet];
}

- (void)trimLeft
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    [self trimLeftCharactersInSet:characterSet];
}

- (void)trimRight
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    [self trimRightCharactersInSet:characterSet];
}

- (void)trimCharactersInSet:(NSCharacterSet *)characterSet
{
    if (characterSet)
    {
        NSInteger index;
        NSInteger length;
        NSRange   range;
        
        // Trimming right.
        
        length = self.length;
        index = length - 1;
        
        for (; index > -1; index--)
        {
            unichar character = [self characterAtIndex:index];
            
            if (![characterSet characterIsMember:character])
            {
                break;
            }
        }
        
        range.location = index + 1;
        range.length = length - index - 1;
        
        if (range.length > 0)
        {
            [self deleteCharactersInRange:range];
        }
        
        // Trimming left.
        
        length = self.length;
        index = 0;
        
        for (; index < length; index++)
        {
            unichar character = [self characterAtIndex:index];
            
            if (![characterSet characterIsMember:character])
            {
                break;
            }
        }
        
        range.location = 0;
        range.length = index;
        
        if (range.length > 0)
        {
            [self deleteCharactersInRange:range];
        }
    }
}

- (void)trimLeftCharactersInSet:(NSCharacterSet *)characterSet
{
    if (characterSet)
    {
        NSInteger length = self.length;
        NSInteger index = 0;
        
        for (; index < length; index++)
        {
            unichar character = [self characterAtIndex:index];
            
            if (![characterSet characterIsMember:character])
            {
                break;
            }
        }
        
        NSRange range;
        range.location = 0;
        range.length = index;
        
        if (range.length > 0)
        {
            [self deleteCharactersInRange:range];
        }
    }
}

- (void)trimRightCharactersInSet:(NSCharacterSet *)characterSet
{
    if (characterSet)
    {
        NSInteger length = self.length;
        NSInteger index = length - 1;
        
        for (; index > -1; index--)
        {
            unichar character = [self characterAtIndex:index];
            
            if (![characterSet characterIsMember:character])
            {
                break;
            }
        }
        
        NSRange range;
        range.location = index + 1;
        range.length = length - index - 1;
        
        if (range.length > 0)
        {
            [self deleteCharactersInRange:range];
        }
    }
}

- (void)trimStrings:(NSString *)string0, ...
{
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        [self trimStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
}

- (void)trimLeftStrings:(NSString *)string0, ...
{
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        [self trimLeftStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
}

- (void)trimRightStrings:(NSString *)string0, ...
{
    if (string0)
    {
        NSMutableSet *strings = [[NSMutableSet alloc] init];
        
        va_list valist;
        va_start(valist, string0);
        
        NSString *string = string0;
        
        while (string)
        {
            [strings addObject:string];
            
            string = va_arg(valist, NSString *);
        }
        
        va_end(valist);
        
        [self trimRightStringsInSet:strings];
        
        [strings release];
        strings = nil;
    }
}

- (void)trimStringsInSet:(NSSet *)stringSet
{
    if (stringSet)
    {
        BOOL stoped;
        
        // Trimming Right.
        
        stoped = NO;
        
        while (!stoped)
        {
            stoped = YES;
            
            for (NSString *string in stringSet)
            {
                if ([self hasSuffix:string])
                {
                    NSRange range;
                    range.length = string.length;
                    range.location = self.length - range.length;
                    
                    if (range.length > 0)
                    {
                        stoped = NO;
                        
                        [self deleteCharactersInRange:range];
                    }
                }
            }
        }
        
        // Trimming Left.
        
        stoped = NO;
        
        while (!stoped)
        {
            stoped = YES;
            
            for (NSString *string in stringSet)
            {
                if ([self hasPrefix:string])
                {
                    NSRange range;
                    range.location = 0;
                    range.length = string.length;
                    
                    if (range.length > 0)
                    {
                        stoped = NO;
                        
                        [self deleteCharactersInRange:range];
                    }
                }
            }
        }
    }
}

- (void)trimLeftStringsInSet:(NSSet *)stringSet
{
    if (stringSet)
    {
        BOOL stoped = NO;
        
        while (!stoped)
        {
            stoped = YES;
            
            for (NSString *string in stringSet)
            {
                if ([self hasPrefix:string])
                {
                    NSRange range;
                    range.location = 0;
                    range.length = string.length;
                    
                    if (range.length > 0)
                    {
                        stoped = NO;
                        
                        [self deleteCharactersInRange:range];
                    }
                }
            }
        }
    }
}

- (void)trimRightStringsInSet:(NSSet *)stringSet
{
    if (stringSet)
    {
        BOOL stoped = NO;
        
        while (!stoped)
        {
            stoped = YES;
            
            for (NSString *string in stringSet)
            {
                if ([self hasSuffix:string])
                {
                    NSRange range;
                    range.length = string.length;
                    range.location = self.length - range.length;
                    
                    if (range.length > 0)
                    {
                        stoped = NO;
                        
                        [self deleteCharactersInRange:range];
                    }
                }
            }
        }
    }
}

@end
