//
//  Upload.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "Crash.h"
#import "DeviceLocation.h"
#import "ErrorItem.h"
#import "EventItem.h"
#import "FeedbackItem.h"
#import "KeyValuePair.h"
#import "QueryStringKeyType.h"
#import "SystemError.h"
#import "User.h"
#import "Utils.h"
#import "WebServices.h"
#import "WebServiceResponseType.h"
#import "ResponseXMLReader.h"
#import "ResponseWithGuidXMLReader.h"
#import "ExceptionWebServiceLayer.h"
#import "ExceptionDescriptive.h"

@interface Upload : NSObject

- (id)initWithBaseUrl: (NSString *)aBaseUrl;

- (CFUUIDRef)deviceWithApplicationId: (CFUUIDRef)anApplicationId model: (NSString *)aModel osVersion: (NSString *)anOsVersion deviceType: (int)aDeviceType carrier: (NSString *)aCarrier applicationVersion: (NSString *)anApplicationVersion timeZoneOffset: (int)aTimeZoneOffset
                        responseCode: (int *)aResponseCode;

- (int)crashWithDeviceId: (CFUUIDRef)aDeviceId crash: (Crash *)aCrash;
- (int)errorWithDeviceId: (CFUUIDRef)aDeviceId errorItem: (ErrorItem *)anErrorItem;
- (int)eventWithDeviceId: (CFUUIDRef)aDeviceId eventItem: (EventItem *)anEventItem;
- (int)feedbackWithDeviceId: (CFUUIDRef)aDeviceId feedbackItem: (FeedbackItem *)aFeedbackItem;
- (int)systemErrorWithDeviceId: (CFUUIDRef)aDeviceId systemError: (SystemError *)aSystemError;
- (int)userWithDeviceId: (CFUUIDRef)aDeviceId user: (User *)aUser;
- (int)locationWithDeviceId: (CFUUIDRef)aDeviceId applicationId: (CFUUIDRef)anApplicationId deviceLocation: (DeviceLocation *)aDeviceLocation;

- (int)upgrade: (CFUUIDRef)aDeviceId applicationId: (CFUUIDRef)anApplicationId version: (NSString *)aVersion;

@end
