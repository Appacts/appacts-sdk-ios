//
//  DeviceGeneralInformation.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 18/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "DeviceGeneralInformation.h"

@implementation DeviceGeneralInformation

@synthesize availableFlashDriveSize;
@synthesize availableMemorySize;
@synthesize battery;
@synthesize networkCoverage;

- (id)initWithAvailableFlashDriveSize: (uint64_t)anAvailableFlashDriveSize availableMemorySize: (long)anAvailableMemorySize battery: (int)aBattery networkCoverage: (int)aNetworkCoverage
{
    self.availableFlashDriveSize = anAvailableFlashDriveSize;
    self.availableMemorySize = anAvailableMemorySize;
    self.battery = aBattery;
    self.networkCoverage = aNetworkCoverage;
    
    return self;
}

@end
