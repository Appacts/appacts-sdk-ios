//
//  DeviceInformation.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "DeviceInformation.h"

@interface DeviceInformation()

{
    
}

@end

@implementation DeviceInformation

NSString * const pluginVersion = @"0.9.950.900";

- (id)init {
    return self;
}

- (int)getDeviceType {
    return iOS;
} 

- (long)getFlashDriveSize {
    uint64_t totalSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
    }
    
    return totalSpace;
}

- (NSString *)getModel {
    return [[UIDevice currentDevice] model];
}

- (long)getMemorySize {
    return 0;
}

- (NSString *)getPluginVersion {
    return DeviceInformation.pluginVersion;
}

- (int)getPluginVersionCode {
    return [DeviceInformation.pluginVersion stringByReplacingOccurrencesOfString:@"." withString:@""].intValue;
}

+ (NSString *)pluginVersion {
    return pluginVersion;
}

@end
