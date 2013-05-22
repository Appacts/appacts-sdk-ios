//
//  DeviceGeneralInformation.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 18/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceGeneralInformation : NSObject

{
    uint64_t availableFlashDriveSize;
    long availableMemorySize;
    int battery;
    int networkCoverage;
}
@property (nonatomic) uint64_t availableFlashDriveSize;
@property (nonatomic) long availableMemorySize;
@property (nonatomic) int battery;
@property (nonatomic) int networkCoverage;

- (id)initWithAvailableFlashDriveSize: (uint64_t)anAvailableFlashDriveSize availableMemorySize: (long)anAvailableMemorySize battery: (int)aBattery networkCoverage: (int)aNetworkCoverage;

@end
