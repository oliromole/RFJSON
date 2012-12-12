//
//  RENSNotificationQueue.m
//  REExtendedFoundation
//  https://github.com/oliromole/REExtendedFoundation.git
//
//  Created by Roman Oliichuk on 2012.08.23.
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

#import "RENSNotificationQueue.h"

@implementation NSNotificationQueue (NSNotificationQueueRENSNotificationQueue)

#pragma mark - Managing Notifications

- (void)enqueueNotificationName:(NSString *)aName object:(id)anObject postingStyle:(NSPostingStyle)postingStyle
{
    NSNotification * notification = [NSNotification notificationWithName:aName object:anObject];
    
    [self enqueueNotification:notification postingStyle:postingStyle];
}

- (void)enqueueNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo postingStyle:(NSPostingStyle)postingStyle
{
    NSNotification * notification = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
    
    [self enqueueNotification:notification postingStyle:postingStyle];
}

- (void)enqueueNotificationName:(NSString *)aName object:(id)anObject postingStyle:(NSPostingStyle)postingStyle coalesceMask:(NSUInteger)coalesceMask forModes:(NSArray *)modes
{
    NSNotification * notification = [NSNotification notificationWithName:aName object:anObject];
    
    [self enqueueNotification:notification postingStyle:postingStyle coalesceMask:coalesceMask forModes:modes];
}

- (void)enqueueNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo postingStyle:(NSPostingStyle)postingStyle coalesceMask:(NSUInteger)coalesceMask forModes:(NSArray *)modes
{
    NSNotification * notification = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
    
    [self enqueueNotification:notification postingStyle:postingStyle coalesceMask:coalesceMask forModes:modes];
}

- (void)dequeueNotificationsMatching:(NSNotification *)notification
{
    [self dequeueNotificationsMatching:notification coalesceMask:NSNotificationCoalescingOnNameAndSender];
}

- (void)dequeueNotificationsMatchingName:(NSString *)aName
{
    NSObject *object = [[NSObject alloc] init];
    
    NSNotification *notification = [NSNotification notificationWithName:aName object:object];
    
    RENSObjectRelease(object);
    object = nil;
    
    [self dequeueNotificationsMatching:notification coalesceMask:NSNotificationCoalescingOnName];
}

- (void)dequeueNotificationsMatchingObject:(id)anObject
{
    NSNotification *notification = [NSNotification notificationWithName:@"NSNotificationName" object:anObject];
    
    [self dequeueNotificationsMatching:notification coalesceMask:NSNotificationCoalescingOnSender];
}

- (void)dequeueNotificationsMatchingName:(NSString *)aName object:(id)anObject
{
    NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
    
    [self dequeueNotificationsMatching:notification coalesceMask:NSNotificationCoalescingOnNameAndSender];
}

- (void)dequeueNotificationsMatchingName:(NSString *)aName object:(id)anObject coalesceMask:(NSUInteger)coalesceMask
{
    NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
    
    [self dequeueNotificationsMatching:notification coalesceMask:coalesceMask];
}

- (void)dequeueNotificationsMatchingName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo coalesceMask:(NSUInteger)coalesceMask
{
    NSNotification *notification = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
    
    [self dequeueNotificationsMatching:notification coalesceMask:coalesceMask];
}

@end
