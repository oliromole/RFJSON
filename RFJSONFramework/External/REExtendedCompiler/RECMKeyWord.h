//
//  RECMKeyWord.h
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

#if __has_feature(objc_arc)
#   if __IPHONE_5_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
#       ifndef weak
#           define weak assign
#       endif
#   endif
#else
#   ifndef strong
#       define strong retain
#   endif
#   ifndef weak
#       define weak assign
#   endif
#endif

#if __has_feature(objc_arc)
#   if __IPHONE_5_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
#       ifndef __weak2
#           define __weak2 __unsafe_unretained
#       endif
#   else
#       ifndef __weak2
#           define __weak2 __weak
#       endif
#   endif
#else
#   ifndef __autoreleasing
#       define __autoreleasing
#   endif
#   ifndef __strong
#       define __strong
#   endif
#   ifndef __unsafe_unretained
#       define __unsafe_unretained
#   endif
#   ifndef __weak
#       define __weak
#   endif
#   ifndef __weak2
#       define __weak2
#   endif
#endif

#if !__has_feature(objc_arc)
#   ifndef __bridge
#       define __bridge
#   endif
#   ifndef __bridge_retained
#       define __bridge_retained
#   endif
#   ifndef __bridge_transfer
#       define __bridge_transfer
#   endif
#endif
