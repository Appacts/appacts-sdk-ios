//
//  SystemError.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "SystemError.h"

@implementation SystemError

@synthesize error;
@synthesize system;

- initWithApplicationId: (CFUUIDRef)anApplicationId exceptionDescriptive: (ExceptionDescriptive *)anExceptionDescriptive analyticsSystem: (AnalyticsSystem *)anAnalyticsSystem version: (NSString *)aVersion
{
    self = [super initWithApplicationId:anApplicationId sessionId:NULL version:aVersion];
    
    self.error = anExceptionDescriptive;
    self.system = anAnalyticsSystem;
    
    return self;
}

- initWithId: (int)anId applicationId: (CFUUIDRef)anApplicationId exceptionDescriptive: (ExceptionDescriptive *)anExceptionDescriptive analyticsSystem: (AnalyticsSystem *)anAnalyticsSystem dateCreated: (NSDate *)aDateCreated version: (NSString *)aVersion
{
    self = [super initWithid:anId applicationId:anApplicationId dateCreated:aDateCreated sessionId:NULL version:aVersion];
    
    self.error = anExceptionDescriptive;
    self.system = anAnalyticsSystem;
    
    return self;
}

@end
