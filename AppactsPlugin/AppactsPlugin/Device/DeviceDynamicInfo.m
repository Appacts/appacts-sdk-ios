//
//  DeviceDynamicInformation.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "DeviceDynamicInfo.h"
#import <UIKit/UIKit.h>

@interface DeviceDynamicInfo()

-(natural_t) getFreeRamInBytes;

@end

@implementation DeviceDynamicInfo

- (id)init
{
    return self;
}

- (DeviceGeneralInformation *)getDeviceGeneralInformation {
    
    uint64_t filesSystemAvailableBytes = 0.0f;
    
    NSError *error = nil;
    NSFileManager *nsfm = [[NSFileManager alloc] init];
    NSDictionary *attr = [nsfm attributesOfFileSystemForPath:@"/" error:&error];
    if (!error) {
        NSNumber *freeFileSystemInBytes = [attr objectForKey:NSFileSystemFreeSize];
        filesSystemAvailableBytes = [freeFileSystemInBytes floatValue];
    }
    
    int signalStrength = CTGetSignalStrength();
    
    DeviceGeneralInformation *deviceGeneralInformation = [[DeviceGeneralInformation alloc] initWithAvailableFlashDriveSize:filesSystemAvailableBytes availableMemorySize:self.getFreeRamInBytes battery:[[UIDevice currentDevice] batteryLevel] networkCoverage:signalStrength];
    
    return deviceGeneralInformation;
}

- (DeviceLocation *)getDeviceLocation {
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = locationManager.location;
    
    DeviceLocation *deviceLocation = [[DeviceLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    [locationManager stopUpdatingLocation];
    
    return deviceLocation;
    
}

-(natural_t) getFreeRamInBytes {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
#ifdef DEBUG
        NSLog(@"Failed to fetch vm statistics");
#endif
        return 0;
    }
    /* Stats in bytes */
    natural_t mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

@end
