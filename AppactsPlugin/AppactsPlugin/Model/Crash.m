//
//  Crash.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 17/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Crash.h"

@implementation Crash

- (id)initWithapplicationId: (CFUUIDRef)anApplicationId sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithApplicationId:anApplicationId sessionId:aSessionId version:aVersion];
    
    return self;
}

- (id)initWithid: (int)anId applicationId: (CFUUIDRef)anApplicationId dateCreated: (NSDate *)aDateCreated version: (NSString *)aVersion sessionId: (CFUUIDRef)aSessionId
{
    self = [super initWithid:anId applicationId:anApplicationId dateCreated:aDateCreated sessionId:aSessionId version:aVersion];
    
    return self;
}

@end
