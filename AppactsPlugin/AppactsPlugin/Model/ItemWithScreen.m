//
//  ItemWithScreen.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "ItemWithScreen.h"

@implementation ItemWithScreen

@synthesize screenName;

- (id)initWithApplicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithApplicationId:anApplicationId sessionId:aSessionId version:aVersion];
            
    self.screenName = aScreenName;
    
    return self;
}

- (id)initWithId: (int)anId applicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithid: anId applicationId:anApplicationId dateCreated:aDateCreated sessionId:aSessionId version:aVersion];
    
    self.screenName = aScreenName;
    
    return self;
}

@end
