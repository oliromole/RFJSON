//
//  RECMKeyWord.h
//  REExtendedCompiler
//
//  Created by Roman on 18/11/2012.
//  Copyright (c) 2012 Oliromole. All rights reserved.
//

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
