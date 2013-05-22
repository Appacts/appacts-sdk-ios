//
//  EventItem.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemWithScreen.h"

@interface EventItem : ItemWithScreen

{
    NSString *data;
    int eventType;
    NSString *eventName;
    long length;
}
@property (nonatomic, strong) NSString *data;
@property (nonatomic) int eventType;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic) long length;

- (id)initWithApplicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName data: (NSString *)aData eventType: (int)anEventType eventName: (NSString *)anEventName length: (long)aLength sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;
- (id)initWithId: (int)anId applicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName data: (NSString *)aData eventType: (int)anEventType eventName: (NSString *)anEventName length: (long)aLength dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;

@end
