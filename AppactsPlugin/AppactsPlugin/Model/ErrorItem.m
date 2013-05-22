//
//  ErrorItem.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "ErrorItem.h"

@implementation ErrorItem

@synthesize data;
@synthesize deviceInformation;
@synthesize eventName;
@synthesize error;

- (id)initWithapplicationId:(CFUUIDRef)anApplicationId screenName: (NSString*)aScreenName data: (NSString *)aData deviceGeneralInformation: (DeviceGeneralInformation *)aDeviceGeneralInformation eventName: (NSString *)anEventName exception: (NSException *)anException sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithApplicationId:anApplicationId screenName:aScreenName sessionId:aSessionId version:aVersion];
    
    self.data = aData;
    self.deviceInformation = aDeviceGeneralInformation;
    self.eventName = anEventName;
    self.error = anException;
    
    return self;
}

- (id)initWithId: (int)anId applicationId:(CFUUIDRef)anApplicationId screenName: (NSString*)aScreenName data: (NSString *)aData deviceGeneralInformation: (DeviceGeneralInformation *)aDeviceGeneralInformation eventName: (NSString *)anEventName exception: (NSException *)anException dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithId:anId applicationId:anApplicationId screenName:aScreenName dateCreated:aDateCreated sessionId:aSessionId version:aVersion];
    
    self.data = aData;
    self.deviceInformation = aDeviceGeneralInformation;
    self.eventName = anEventName;
    self.error = anException;
    
    return self;
}

@end
