//
//  Settings.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApplicationMeta.h"
#import "ApplicationState.h"
#import "DeviceLocation.h"
#import "ExceptionDatabaseLayer.h"
#import "OptStatusType.h"
#import "PluginMeta.h"
#import "User.h"

#import "sqlite3.h"

@interface Settings : NSObject

- (id)initWithDatabaseReadWrite:
        (sqlite3 *)aDatabaseReadWrite
               databaseReadOnly: (sqlite3 *) aDatabaseReadOnly
                   databaseLock: (NSObject *) aDatabaseLock;

- (CFUUIDRef)getDeviceId;
- (DeviceLocation *)getDeviceLocationByStatusType: (int)aStatusType;
- (User *)getUserByApplicationId: (CFUUIDRef)anApplicationId statusType: (int)aStatusType;
- (ApplicationMeta *)loadApplicationByApplicationId: (CFUUIDRef)anApplicationId;
- (PluginMeta *)loadPluginMeta;

- (void)saveUser: (User *)aUser;
- (void)saveDeviceLocation: (DeviceLocation *)aDeviceLocation statusType: (int)aStatusType;
- (void)saveDeviceId: (CFUUIDRef)aDeviceId dateCreated: (NSDate *)aDateCreated;
- (void)saveApplicationMeta: (ApplicationMeta *)anApplicationMeta;
- (void)savePluginMeta: (PluginMeta *)aPluginMeta;

- (void)updateUser: (User *)aUser statusType: (int)aStatusType;
- (void)updateApplication: (ApplicationMeta *)anApplicationMeta;
- (void)updatePluginMeta: (PluginMeta *)aPluginMeta;

@end
