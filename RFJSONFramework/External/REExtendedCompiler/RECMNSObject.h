//
//  RECMNSObject.h
//  REExtendedCompiler
//  https://github.com/oliromole/REExtendedCompiler.git
//
//  Created by Roman Oliichuk on 2012.11.18.
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

#import "RECMDefines.h"

#define RECM_NS_OBJECT_DEBUG 0

/*
 * You can use the below definitions if you want to write universal code for
 * manual reference counter and automatic reference counter.
 *
 */

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Universal code                                    * Manual reference counte                           * Automatic reference counter                       *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Example #1:                                       * Example #1:                                       * Example #1:                                       *
 *                                                   *                                                   *                                                   *
 * ...                                               * ...                                               * ...                                               *
 * NSObject *object0 = [[NSObject alloc] init];      * NSObject *object0 = [[NSObject alloc] init];      * NSObject *object0 = [[NSObject alloc] init];      *
 * NSObject *object1 = [[NSObject alloc] init];      * NSObject *object1 = [[NSObject alloc] init];      * NSObject *object1 = [[NSObject alloc] init];      *
 * ...                                               * ...                                               * ...                                               *
 * RENSObjectRelease(object0);                       * [object0 release];                                *                                                   *
 * object0 = RENSObjectRetain(object1);              * object0 = [object1 retain];                       * object0 = object1;                                *
 * ...                                               *  ...                                              * ...                                               *
 *                                                   *                                                   *                                                   *
 * but bad the next example:                         * but bad the next example:                         * but bad the next example:                         *
 *                                                   *                                                   *                                                   *
 * ...                                               * ...                                               *                                                   *
 * NSObject *object0 = [[NSObject alloc] init];      * NSObject *object0 = [[NSObject alloc] init];      *                                                   *
 * NSObject *object1 = [[NSObject alloc] init];      * NSObject *object1 = [[NSObject alloc] init];      *                                                   *
 * ...                                               * ...                                               *                                                   *
 * RENSObjectAutorelease(object0);                   * [object0 autorelease];                            *                                                   *
 * object0 = RENSObjectRetain(object1);              * object0 = [object1 retain];                       *                                                   *
 * ...                                               * ...                                               *                                                   *
 *                                                   *                                                   *                                                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Example #2:                                       *                                                   *                                                   *
 *                                                   *                                                   *                                                   *
 * ...                                               * ...                                               * ...                                               *
 * NSObject *object = [[NSObject alloc] init];       * NSObject *object = [[NSObject alloc] init];       * NSObject *object = [[NSObject alloc] init];       *
 * ...                                               * ...                                               * ...                                               *
 * RENSObjectRelease(object);                        * [object release];                                 *                                                   *
 * object = nil;                                     * object = nil;                                     * object = nil;                                     *
 * ...                                               * ...                                               * ...                                               *
 *                                                   *                                                   *                                                   *
 * but bad the next example:                         * but bad the next example:                         * but bad the next example:                         *
 *                                                   *                                                   *                                                   *
 * ...                                               * ...                                               *                                                   *
 * NSObject *object = [[NSObject alloc] init];       * NSObject *object = [[NSObject alloc] init];       *                                                   *
 * ...                                               * ...                                               *                                                   *
 * RENSObjectAutorelease(object);                    * [object autorelease];                             *                                                   *
 * object = nil;                                     * object = nil;                                     *                                                   *
 * ...                                               * ...                                               *                                                   *
 *                                                   *                                                   *                                                   *
 * and bad the next example:                         * and bad the next example:                         * and bad the next example:                         *
 *                                                   *                                                   *                                                   *
 * ...                                               * ...                                               *                                                   *
 * NSObject *object = [[NSObject alloc] init];       * NSObject *object = [[NSObject alloc] init];       *                                                   *
 * RENSObjectRelease(object);                        * [object autorelease];                             *                                                   *
 * ...                                               *  ...                                              *                                                   *
 *                                                   *                                                   *                                                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Example #3:                                       *                                                   *                                                   *
 *                                                   *                                                   *                                                   *
 * - (NSObject *)object                              * - (NSObject *)object                              * - (NSObject *)object                              *
 * {                                                 * {                                                 * {                                                 *
 *      ...                                          *      ...                                          *      ...                                          *
 *      NSObject *object = [[NSObject alloc] init];  *      NSObject *object = [[NSObject alloc] init];  *      NSObject *object = [[NSObject alloc] init];  *
 *      ...                                          *      ...                                          *      ...                                          *
 *      return RENSObjectAutorelease(object);        *      return [object autorelease];                 *      return object;                               *
 * }                                                 * }                                                 * }                                                 *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 * Example #4:                                       * Example #4:                                       * Example #4:                                       *
 *                                                   *                                                   *                                                   *
 * - (void)dealloc                                   * - (void)dealloc                                   * - (void)dealloc                                   *
 * {                                                 * {                                                 * {                                                 *
 *      ...                                          *      ...                                          *      ...                                          *
 *      RENSObjectSuperDealloc();                    *      [super dealloc];                             *                                                   *
 * }                                                 * }                                                 * }                                                 *
 *                                                   *                                                   *                                                   *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */

#if RECM_NS_OBJECT_DEBUG
#   if __has_feature(objc_arc)
#       define RENSObjectAutorelease(object) (NSLog(@"["#object" autorelease] ARC"), (object))
#       define RENSObjectRelease(object)     do { NSLog(@"["#object" release] ARC"); } while(0)
#       define RENSObjectRetain(object)      (NSLog(@"["#object" retain] ARC"),      (object))
#       define RENSObjectSuperDealloc()      do { NSLog(@"[super dealloc] ARC"); } while(0)
#   else
#       define RENSObjectAutorelease(object) (NSLog(@"["#object" autorelease] MRC"), [(object) autorelease])
#       define RENSObjectRelease(object)     (NSLog(@"["#object" release] MRC"),     [(object) release])
#       define RENSObjectRetain(object)      (NSLog(@"["#object" retain] MRC"),      [(object) retain])
#       define RENSObjectSuperDealloc()      (NSLog(@"[super dealloc] MRC"),         [super dealloc])
#   endif
#else
#   if __has_feature(objc_arc)
#       define RENSObjectAutorelease(object) (object)
#       define RENSObjectRelease(object)     do { } while(0)
#       define RENSObjectRetain(object)      (object)
#       define RENSObjectSuperDealloc()      do { } while(0)
#   else
#       define RENSObjectAutorelease(object) ([(object) autorelease])
#       define RENSObjectRelease(object)     ([(object) release])
#       define RENSObjectRetain(object)      ([(object) retain])
#       define RENSObjectSuperDealloc()      ([super dealloc])
#   endif
#endif
