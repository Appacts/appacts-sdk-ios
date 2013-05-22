//
//  DeviceInformation.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "DeviceType.h"

@interface DeviceInformation : NSObject

- (id)init;
- (int)getDeviceType;
- (long)getFlashDriveSize;
- (NSString *)getModel;
- (long)getMemorySize;
- (NSString *)getPluginVersion;
- (int)getPluginVersionCode;

+ (NSString *)pluginVersion;

@end
