//
//  DeviceDynamicInformation.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import "DeviceGeneralInformation.h"
#import "DeviceLocation.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

@interface DeviceDynamicInfo : NSObject

- (id)init;
- (DeviceGeneralInformation *)getDeviceGeneralInformation;
- (DeviceLocation *)getDeviceLocation;

@end
