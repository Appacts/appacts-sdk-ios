//
//  DeviceLocation.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 19/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@interface DeviceLocation : NSObject

{
    double latitude;
    double longitude;
    NSString *countryName;
    NSString *countryCode;
    NSString *countryAdminName;
    NSString *countryAdminCode;
    NSDate *dateCreated;
}
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *countryAdminName;
@property (nonatomic, strong) NSString *countryAdminCode;
@property (nonatomic, strong) NSDate *dateCreated;

- (id)initWithLatitude: (double)aLatitude longitude: (double)aLongitude;
- (id)initWithLatitude: (double)aLatitude longitude: (double)aLongitude dateCreated: (NSDate *)aDateCreated;
- (id)initWithLatitude: (double)aLatitude longitude: (double)aLongitude countryName: (NSString *)aCountryName countryCode: (NSString *)aCountryCode countryAdminName: (NSString *)aCountryAdminName countryAdminCode: (NSString *)aCountryAdminCode dateCreated: (NSDate *)aDateCreated;
- (id)initWithLatitude: (double)aLatitude longitude: (double)aLongitude countryName: (NSString *)aCountryName countryCode: (NSString *)aCountryCode countryAdminName: (NSString *)aCountryAdminName countryAdminCode: (NSString *)aCountryAdminCode;

@end
