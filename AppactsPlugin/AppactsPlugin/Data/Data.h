//
//  Data.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApplicationStateType.h"
#import "ExceptionDatabaseLayer.h"
#import "OptStatusType.h"

#import "sqlite3.h"

@interface Data : NSObject

- (id)initWithConnectionString: (NSString *)aConnectionString;
- (void)create;
- (void)setup;
- (Boolean)exists;

- (sqlite3 *)openReadWriteConnection;
- (void)closeReadWriteConnection;

- (sqlite3 *)openReadOnlyConnection;
- (void)closeReadOnlyConnection;

- (NSObject *) getDatabaseLock;

- (void)dispose;
- (Boolean)upgradeSchemaWithCurrentPluginVersion: (int)aPluginVersion oldSchemaVersion: (int)aSchemaVersion;

@end
