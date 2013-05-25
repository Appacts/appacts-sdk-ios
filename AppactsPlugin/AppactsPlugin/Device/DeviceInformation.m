#import "DeviceInformation.h"


@interface DeviceInformation()

{
    
}

@end

@implementation DeviceInformation

NSString * const pluginVersion = @"1.1.0.2322";

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

- (NSString *)getLocale {
    return [[NSLocale currentLocale] localeIdentifier];
}

- (ScreenResolution *)getScreenResolution {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return [[ScreenResolution alloc] initWithScreenWidth:screenBounds.size.width screenHeight:screenBounds.size.height];
}

- (NSString *)getManufacturer {
    return @"Apple";
}

+ (NSString *)pluginVersion {
    return pluginVersion;
}

@end
