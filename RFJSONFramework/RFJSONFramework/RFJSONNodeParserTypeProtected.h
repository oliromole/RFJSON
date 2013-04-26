//
//  RFJSONNodeParserTypeProtected.h
//  ImmotopLu
//
//  Created by Roman Oliichuk on 2013.04.23.
//  Copyright (c) 2012 Roman Oliichuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (NSNumberRFJSONNodeParserTypeProtected)

// Initializing and Creating a NSNumber

+ (id)RFJSONNodeParserTypeArray;
+ (id)RFJSONNodeParserTypeBool;
+ (id)RFJSONNodeParserTypeNull;
+ (id)RFJSONNodeParserTypeNumber;
+ (id)RFJSONNodeParserTypeObject;
+ (id)RFJSONNodeParserTypeString;

@end
