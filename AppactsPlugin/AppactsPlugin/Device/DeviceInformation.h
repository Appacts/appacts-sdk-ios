#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "DeviceType.h"
#import "ScreenResolution.h"

@interface DeviceInformation : NSObject

- (id)init;
- (int)getDeviceType;
- (long)getFlashDriveSize;
- (NSString *)getModel;
- (long)getMemorySize;
- (NSString *)getPluginVersion;
- (int)getPluginVersionCode;
- (NSString *)getLocale;
- (ScreenResolution *)getScreenResolution;
- (NSString *)getManufacturer;

+ (NSString *)pluginVersion;

@end
