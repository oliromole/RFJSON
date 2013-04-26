//
//  RFJSONNodeParserTypeProtected.m
//  ImmotopLu
//
//  Created by Roman Oliichuk on 2013.04.23.
//  Copyright (c) 2012 Roman Oliichuk. All rights reserved.
//

#import "RFJSONNodeParserTypeProtected.h"

#import "RFJSONNodeParserType.h"

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
