//
//  Item.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 17/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize id;
@synthesize applicationId;
@synthesize dateCreated;
@synthesize version;
@synthesize sessionId;

- (id)initWithApplicationId: (CFUUIDRef)anApplicationId sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self.id = 0;
    self.applicationId = anApplicationId;
    self.dateCreated = [Utils getDateTimeNow];
    self.version = aVersion;
    self.sessionId = aSessionId;
    
    return self;
}

- (id)initWithid: (int)anId applicationId: (CFUUIDRef)anApplicationId dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self.id = anId;
    self.applicationId = anApplicationId;
    self.dateCreated = aDateCreated;
    self.version = aVersion;
    self.sessionId = aSessionId;
    
    return self;
}

- (void)dealloc
{
    
}

@end
