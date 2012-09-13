//
//  RENSInvocation.m
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2012.08.15.
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

#import "RENSInvocation.h"

@implementation NSInvocation (NSInvocationRENSInvocation)

#pragma mark - Initializing and Creating a NSInvocation

+ (NSInvocation *)invocationWithMethodSignature:(NSMethodSignature *)methodSignature selector:(SEL)selector
{
    if (!methodSignature)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: method signature argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    if (invocation)
    {
        invocation.selector = selector;
    }
    
    return invocation;
}

+ (NSInvocation *)invocationWithMethodSignature:(NSMethodSignature *)methodSignature selector:(SEL)selector arguments:(void *)pArgument0, ...
{
    if (!methodSignature)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: method signature argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    if (invocation)
    {
        invocation.selector = selector;
        
        NSUInteger numberOfArguments = methodSignature.numberOfArguments;
        
        if (numberOfArguments > 2)
        {
            [invocation setArgument:pArgument0 atIndex:2];
            
            if (numberOfArguments > 3)
            {
                va_list valist;
                va_start(valist, pArgument0);
                
                for (NSUInteger indexOfArgument = 3; indexOfArgument < numberOfArguments; indexOfArgument++)
                {
                    void *pArgument = va_arg(valist, void *);
                    
                    [invocation setArgument:pArgument atIndex:indexOfArgument];
                }                
                
                va_end(valist);
            }
        }
    }
    
    return invocation;
}

+ (NSInvocation *)invocationWithMethodSignature:(NSMethodSignature *)methodSignature selector:(SEL)selector retainedArguments:(BOOL)retainedArguments arguments:(void *)pArgument0, ...
{
    if (!methodSignature)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: method signature argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    if (invocation)
    {
        invocation.selector = selector;
        
        NSUInteger numberOfArguments = methodSignature.numberOfArguments;
        
        if (numberOfArguments > 2)
        {
            [invocation setArgument:pArgument0 atIndex:2];
            
            if (numberOfArguments > 3)
            {
                va_list valist;
                va_start(valist, pArgument0);
                
                for (NSUInteger indexOfArgument = 3; indexOfArgument < numberOfArguments; indexOfArgument++)
                {
                    void *pArgument = va_arg(valist, void *);
                    
                    [invocation setArgument:pArgument atIndex:indexOfArgument];
                }                
                
                va_end(valist);
            }
        }
        
        if (retainedArguments)
        {
            [invocation retainArguments];
        }
    }
    
    return invocation;
}

+ (NSInvocation *)invocationWithMethodSignature:(NSMethodSignature *)methodSignature target:(id)tagert selector:(SEL)selector
{
    if (!methodSignature)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: method signature argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!tagert)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: tagert argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    if (invocation)
    {
        invocation.selector = selector;
        invocation.target = tagert;
    }
    
    return invocation;
}

+ (NSInvocation *)invocationWithMethodSignature:(NSMethodSignature *)methodSignature target:(id)tagert selector:(SEL)selector arguments:(void *)pArgument0, ...
{
    if (!methodSignature)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: method signature argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!tagert)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: tagert argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    if (invocation)
    {
        invocation.selector = selector;
        invocation.target = tagert;
        
        NSUInteger numberOfArguments = methodSignature.numberOfArguments;
        
        if (numberOfArguments > 2)
        {
            [invocation setArgument:pArgument0 atIndex:2];
            
            if (numberOfArguments > 3)
            {
                va_list valist;
                va_start(valist, pArgument0);
                
                for (NSUInteger indexOfArgument = 3; indexOfArgument < numberOfArguments; indexOfArgument++)
                {
                    void *pArgument = va_arg(valist, void *);
                    
                    [invocation setArgument:pArgument atIndex:indexOfArgument];
                }                
                
                va_end(valist);
            }
        }
    }
    
    return invocation;
}

+ (NSInvocation *)invocationWithMethodSignature:(NSMethodSignature *)methodSignature target:(id)tagert selector:(SEL)selector retainedArguments:(BOOL)retainedArguments arguments:(void *)pArgument0, ...
{
    if (!methodSignature)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: method signature argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!tagert)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: tagert argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    
    if (invocation)
    {
        invocation.selector = selector;
        invocation.target = tagert;
        
        NSUInteger numberOfArguments = methodSignature.numberOfArguments;
        
        if (numberOfArguments > 2)
        {
            [invocation setArgument:pArgument0 atIndex:2];
            
            if (numberOfArguments > 3)
            {
                va_list valist;
                va_start(valist, pArgument0);
                
                for (NSUInteger indexOfArgument = 3; indexOfArgument < numberOfArguments; indexOfArgument++)
                {
                    void *pArgument = va_arg(valist, void *);
                    
                    [invocation setArgument:pArgument atIndex:indexOfArgument];
                }                
                
                va_end(valist);
            }
        }
        
        if (retainedArguments)
        {
            [invocation retainArguments];
        }
    }
    
    return invocation;
}

+ (NSInvocation *)invocationWithTarget:(id)tagert selector:(SEL)selector
{
    if (!tagert)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: tagert argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = nil;
    
    if (tagert && selector)
    {
        NSMethodSignature *methodSignature = [tagert methodSignatureForSelector:selector];
        
        if (!methodSignature)
        {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The %@ method is not found in the target.", NSStringFromSelector(selector)] userInfo:nil];
        }
        
        invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        
        if (invocation)
        {
            invocation.selector = selector;
            invocation.target = tagert;
        }
    }
    
    return invocation;
}

+ (NSInvocation *)invocationWithTarget:(id)tagert selector:(SEL)selector arguments:(void *)pArgument0, ...
{
    if (!tagert)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: tagert argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = nil;
    
    if (tagert && selector)
    {
        NSMethodSignature *methodSignature = [tagert methodSignatureForSelector:selector];
        
        if (!methodSignature)
        {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The %@ method is not found in the target.", NSStringFromSelector(selector)] userInfo:nil];
        }
        
        invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        
        if (invocation)
        {
            invocation.selector = selector;
            invocation.target = tagert;
            
            NSUInteger numberOfArguments = methodSignature.numberOfArguments;
            
            if (numberOfArguments > 2)
            {
                [invocation setArgument:pArgument0 atIndex:2];
                
                if (numberOfArguments > 3)
                {
                    va_list valist;
                    va_start(valist, pArgument0);
                    
                    for (NSUInteger indexOfArgument = 3; indexOfArgument < numberOfArguments; indexOfArgument++)
                    {
                        void *pArgument = va_arg(valist, void *);
                        
                        [invocation setArgument:pArgument atIndex:indexOfArgument];
                    }                
                    
                    va_end(valist);
                }
            }
        }
    }
    
    return invocation;
}

+ (NSInvocation *)invocationWithTarget:(id)tagert selector:(SEL)selector retainedArguments:(BOOL)retainedArguments arguments:(void *)pArgument0, ...
{
    if (!tagert)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: tagert argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    if (!selector)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: selector argument can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    NSInvocation *invocation = nil;
    
    if (tagert && selector)
    {
        NSMethodSignature *methodSignature = [tagert methodSignatureForSelector:selector];
        
        if (!methodSignature)
        {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"The %@ method is not found in the target.", NSStringFromSelector(selector)] userInfo:nil];
        }
        
        invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        
        if (invocation)
        {
            invocation.selector = selector;
            invocation.target = tagert;
            
            NSUInteger numberOfArguments = methodSignature.numberOfArguments;
            
            if (numberOfArguments > 2)
            {
                [invocation setArgument:pArgument0 atIndex:2];
                
                if (numberOfArguments > 3)
                {
                    va_list valist;
                    va_start(valist, pArgument0);
                    
                    for (NSUInteger indexOfArgument = 3; indexOfArgument < numberOfArguments; indexOfArgument++)
                    {
                        void *pArgument = va_arg(valist, void *);
                        
                        [invocation setArgument:pArgument atIndex:indexOfArgument];
                    }                
                    
                    va_end(valist);
                }
            }
            
            if (retainedArguments)
            {
                [invocation retainArguments];
            }
        }
    }
    
    return invocation;
}

@end

@implementation NSObject (NSObjectRENSInvocation)

#pragma mark - Sending Messages

- (id)performInvocation:(NSInvocation *)invocation
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [invocation invokeWithTarget:self];
    
    NSMethodSignature *methodSignature = invocation.methodSignature;
    
    NSUInteger methodReturnLength = methodSignature.methodReturnLength;
    
    NSUInteger numberOfIds = (methodReturnLength + sizeof(id) - 1) / sizeof(id);
    
    if (numberOfIds == 0)
    {
        numberOfIds = 1;
    }
    
    id ids[numberOfIds];
    memset(ids, 0, (numberOfIds * sizeof(id)));
    
    if (methodReturnLength > 0)
    {
        [invocation getReturnValue:ids];
    }
    
    id returnValue = ids[0];
    return returnValue;
}

- (void)performInvocation:(NSInvocation *)invocation returnValue:(void *)returnLocation
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [invocation invokeWithTarget:self];
    
    if (returnLocation)
    {
        [invocation getReturnValue:returnLocation];
    }
}

- (void)performInvocation:(NSInvocation *)invocation onThread:(NSThread *)thread waitUntilDone:(BOOL)wait
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [self performSelector:@selector(performInvocation:) onThread:thread withObject:invocation waitUntilDone:wait];
}

- (void)performInvocation:(NSInvocation *)invocation onThread:(NSThread *)thread waitUntilDone:(BOOL)wait modes:(NSArray *)modes
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [self performSelector:@selector(performInvocation:) onThread:thread withObject:invocation waitUntilDone:wait modes:modes];
}

- (void)performInvocation:(NSInvocation *)invocation afterDelay:(NSTimeInterval)delay
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [self performSelector:@selector(performInvocation:) withObject:invocation afterDelay:delay];
}

- (void)performInvocation:(NSInvocation *)invocation afterDelay:(NSTimeInterval)delay inModes:(NSArray *)modes
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [self performSelector:@selector(performInvocation:) withObject:invocation afterDelay:delay inModes:modes];
}

- (void)performInvocationInBackground:(NSInvocation *)invocation
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [self performSelectorInBackground:@selector(performInvocation:) withObject:invocation];
}

- (void)performInvocationOnMainThread:(NSInvocation *)invocation waitUntilDone:(BOOL)wait
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [self performSelectorOnMainThread:@selector(performInvocation:) withObject:invocation waitUntilDone:wait];
}

- (void)performInvocationOnMainThread:(NSInvocation *)invocation waitUntilDone:(BOOL)wait modes:(NSArray *)modes
{
    if (!invocation)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"-[%@ %@]: invocation can not be nil.", NSStringFromClass(self.class), NSStringFromSelector(_cmd)] userInfo:nil];
    }
    
    [self performSelectorOnMainThread:@selector(performInvocation:) withObject:invocation waitUntilDone:wait modes:modes];
}

- (void)performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait
{
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:selector];
    
    [self performInvocationOnMainThread:invocation waitUntilDone:wait];
}

- (void)performSelectorOnMainThread:(SEL)selector waitUntilDone:(BOOL)wait modes:(NSArray *)modes
{
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:selector];
    
    [self performInvocationOnMainThread:invocation waitUntilDone:wait modes:modes];
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object1 withObject:(id)object2 waitUntilDone:(BOOL)wait
{
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:selector retainedArguments:YES arguments:object1, object2];
    
    [self performInvocationOnMainThread:invocation waitUntilDone:wait];
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object1 withObject:(id)object2 waitUntilDone:(BOOL)wait modes:(NSArray *)modes
{
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:selector retainedArguments:YES arguments:object1, object2];
    
    [self performInvocationOnMainThread:invocation waitUntilDone:wait modes:modes];
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3 waitUntilDone:(BOOL)wait
{
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:selector retainedArguments:YES arguments:object1, object2, object3];
    
    [self performInvocationOnMainThread:invocation waitUntilDone:wait];
}

- (void)performSelectorOnMainThread:(SEL)selector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3 waitUntilDone:(BOOL)wait modes:(NSArray *)modes
{
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:selector retainedArguments:YES arguments:object1, object2, object3];
    
    [self performInvocationOnMainThread:invocation waitUntilDone:wait modes:modes];
}

@end
