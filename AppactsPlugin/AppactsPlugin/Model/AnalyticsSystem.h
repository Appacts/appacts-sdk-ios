//
//  AnalyticsSystem.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 17/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsSystem : NSObject

{
    int deviceType;
    NSString *version;
}
@property (nonatomic) int deviceType;
@property (nonatomic, strong) NSString *version;

- (id)initWithDeviceType: (int)aDeviceType version: (NSString *)aVersion;

@end
