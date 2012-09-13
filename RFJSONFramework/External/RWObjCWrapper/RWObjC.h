//
//  RWObjC.h
//  RWObjCWrapper
//
//  Created by Roman Oliichuk on 20/07/2012.
//  Copyright (c) 2012 Oliromole. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_INLINE NSString *RWObjCNSStringFromBool(BOOL value)
{
    NSString *nsString = (value ? @"YES" : @"NO");
    return nsString;
}

NS_INLINE BOOL RWObjCBoolFromNSString(NSString *nsString)
{
    BOOL value = (nsString && [nsString isEqual:@"YES"]);
    return value;
}

#define NSStringFromBool(value) RWObjCNSStringFromBool(value)
#define NSBoolFromString(nsString) RWObjCBoolFromNSString(nsString)
