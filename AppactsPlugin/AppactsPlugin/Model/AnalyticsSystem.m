//
//  AnalyticsSystem.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 17/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "AnalyticsSystem.h"

@implementation AnalyticsSystem

@synthesize deviceType;
@synthesize version;

- (id)initWithDeviceType: (int)aDeviceType version: (NSString *)aVersion
{
    self.deviceType = aDeviceType;
    self.version = aVersion;
    
    return self;
}

@end
