//
//  RFJSONNodeParserTypeProtected.h
//  StoAmigo
//
//  Created by Roman Oliichuk on 08/09/2012.
//  Copyright (c) 2012 Roman Oliichuk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "REExtendedCompiler.h"

@interface NSNumber (NSNumberRFJSONNodeParserTypeProtected)

// Initializing and Creating a NSNumber

+ (id)RFJSONNodeParserTypeArray;
+ (id)RFJSONNodeParserTypeBool;
+ (id)RFJSONNodeParserTypeNull;
+ (id)RFJSONNodeParserTypeNumber;
+ (id)RFJSONNodeParserTypeObject;
+ (id)RFJSONNodeParserTypeString;

@end
