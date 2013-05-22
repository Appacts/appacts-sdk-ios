//
//  EventItem.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "EventItem.h"

@implementation EventItem

@synthesize data;
@synthesize eventType;
@synthesize eventName;
@synthesize length;

- (id)initWithApplicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName data: (NSString *)aData eventType: (int)anEventType eventName: (NSString *)anEventName length: (long)aLength sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithApplicationId:anApplicationId screenName:aScreenName sessionId:aSessionId version:aVersion];
    
    self.data = aData;
    self.eventType = anEventType;
    self.eventName = anEventName;
    self.length = aLength;
    
    return self;
}

- (id)initWithId: (int)anId applicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName data: (NSString *)aData eventType: (int)anEventType eventName: (NSString *)anEventName length: (long)aLength dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithId:anId applicationId:anApplicationId screenName:aScreenName dateCreated:aDateCreated sessionId:aSessionId version:aVersion];
    
    self.data = aData;
    self.eventType = anEventType;
    self.eventName = anEventName;
    self.length = aLength;
    
    return self;
}

@end
