//
//  ErrorItem.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceDynamicInformation.h"
#import "DeviceGeneralInformation.h"
#import "ExceptionDescriptive.h"
#import "ItemWithScreen.h"

@interface ErrorItem : ItemWithScreen

{
    NSString *data;
    DeviceGeneralInformation *deviceInformation;
    NSString *eventName;
    NSException *error;
}
@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) DeviceGeneralInformation *deviceInformation;
@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSException *error;

- (id)initWithapplicationId:(CFUUIDRef)anApplicationId screenName: (NSString*)aScreenName data: (NSString *)aData deviceGeneralInformation: (DeviceGeneralInformation *)aDeviceGeneralInformation eventName: (NSString *)anEventName exception: (NSException *)exception sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;

- (id)initWithId: (int)anId applicationId:(CFUUIDRef)anApplicationId screenName: (NSString*)aScreenName data: (NSString *)aData deviceGeneralInformation: (DeviceGeneralInformation *)aDeviceGeneralInformation eventName: (NSString *)anEventName exception: (NSException *)anException dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;

@end
