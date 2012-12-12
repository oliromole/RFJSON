//
//  RENSPropertyList.h
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2012.08.12.
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

#import "REExtendedCompiler.h"

@interface NSPropertyListSerialization (NSPropertyListSerializationRENSPropertyListSerialization)

// Serializing a Property List

+ (NSData *)dataWithPropertyList:(id)plist error:(out NSError **)error NS_AVAILABLE(10_6, 4_0);
+ (NSData *)dataWithPropertyList:(id)plist;
+ (NSInteger)writePropertyList:(id)plist toStream:(NSOutputStream *)stream error:(out NSError **)error NS_AVAILABLE(10_6, 4_0);
+ (NSInteger)writePropertyList:(id)plist toStream:(NSOutputStream *)stream;

// Deserializing a Property List

+ (id)propertyListWithData:(NSData *)data error:(out NSError **)error NS_AVAILABLE(10_6, 4_0);
+ (id)propertyListWithData:(NSData *)data;
+ (id)propertyListWithStream:(NSInputStream *)stream error:(out NSError **)error NS_AVAILABLE(10_6, 4_0);
+ (id)propertyListWithStream:(NSInputStream *)stream;

@end
