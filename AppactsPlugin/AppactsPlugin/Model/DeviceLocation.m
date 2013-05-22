//
//  DeviceLocation.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 19/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "DeviceLocation.h"

@implementation DeviceLocation

@synthesize latitude;
@synthesize longitude;
@synthesize countryName;
@synthesize countryCode;
@synthesize countryAdminName;
@synthesize countryAdminCode;
@synthesize dateCreated;

- (id)initWithLatitude: (double)aLatitude longitude: (double)aLongitude
{
    self = [super init];
    
    if(self) {
        
        self.latitude = aLatitude;
        self.longitude = aLongitude;
        self.countryName = nil;
        self.countryCode = nil;
        self.countryAdminName = nil;
        self.countryAdminCode = nil;
        self.dateCreated = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    }
    
    return self;
}

- (id)initWithLatitude: (double)aLatitude longitude: (double)aLongitude dateCreated: (NSDate *)aDateCreated
{
    self.latitude = aLatitude;
    self.longitude = aLongitude;
    self.countryName = nil;
    self.countryCode = nil;
    self.countryAdminName = nil;
    self.countryAdminCode = nil;
    self.dateCreated = aDateCreated;
    
    return self;
}

- (id)initWithLatitude: (double)aLatitude longitude: (double)aLongitude countryName: (NSString *)aCountryName countryCode: (NSString *)aCountryCode countryAdminName: (NSString *)aCountryAdminName countryAdminCode: (NSString *)aCountryAdminCode dateCreated: (NSDate *)aDateCreated
{
    self.latitude = aLatitude;
    self.longitude = aLongitude;
    self.countryName = aCountryName;
    self.countryCode = aCountryCode;
    self.countryAdminName = aCountryAdminName;
    self.countryAdminCode = aCountryAdminCode;
    self.dateCreated = aDateCreated;
    return self;
}

- (id)initWithLatitude: (double)aLatitude longitude: (double)aLongitude countryName: (NSString *)aCountryName countryCode: (NSString *)aCountryCode countryAdminName: (NSString *)aCountryAdminName countryAdminCode: (NSString *)aCountryAdminCode
{
    self.latitude = aLatitude;
    self.longitude = aLongitude;
    self.countryName = aCountryName;
    self.countryCode = aCountryCode;
    self.countryAdminName = aCountryAdminName;
    self.countryAdminCode = aCountryAdminCode;
    self.dateCreated = [Utils getDateTimeNow];
    return self;
}

@end
