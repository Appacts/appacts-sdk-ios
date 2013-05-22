//
//  Platform.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Platform.h"

@implementation Platform

- (id)init {
    return self;
}

- (NSString *)getCarrier {
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    return [carrier carrierName];
}

- (NSString *)getOS {
    return [[UIDevice currentDevice] systemVersion];
}

@end
