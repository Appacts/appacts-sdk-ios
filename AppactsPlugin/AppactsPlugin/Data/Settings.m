//
//  Settings.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Settings.h"

@interface Settings()

{
    sqlite3 *databaseReadWrite;
    sqlite3 *databaseReadOnly;
}
@property (nonatomic) sqlite3 *databaseReadWrite;
@property (nonatomic) sqlite3 *databaseReadOnly;
@property (nonatomic) NSObject *databaseLock;

@end

@implementation Settings

@synthesize databaseReadWrite;
@synthesize databaseReadOnly;

@synthesize databaseLock;

- (id)initWithDatabaseReadWrite:
(sqlite3 *)aDatabaseReadWrite
               databaseReadOnly: (sqlite3 *) aDatabaseReadOnly
    databaseLock:(NSObject *)aDatabaseLock
{
    
    self = [super init];
    
    if(self) {
        self.databaseReadWrite = aDatabaseReadWrite;
        self.databaseReadOnly = aDatabaseReadOnly;
        self.databaseLock = aDatabaseLock;
    }

    return self;
}

- (CFUUIDRef)getDeviceId {
    
    CFUUIDRef deviceId = NULL;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        
        @try {
            
            const char *query = [@"SELECT DeviceGuid FROM Device" UTF8String];
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                int responseCode = sqlite3_step(statement);
                
                if (responseCode == SQLITE_ROW) {
                    deviceId = [Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)]];
                } else if(responseCode != SQLITE_DONE) {
                    @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadOnly), sqlite3_errcode(self.databaseReadOnly)]) userInfo:(nil)];
                }
            }
            else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadOnly), sqlite3_errcode(self.databaseReadOnly)]) userInfo:(nil)];
            }
            
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        }
        @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
    
    return deviceId;
}

- (DeviceLocation *)getDeviceLocationByStatusType: (int)aStatusType {
    
    DeviceLocation *deviceLocation = NULL;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        @try {
            const char *query = "SELECT Latitude, Longitude, CountryName, CountryCode, CountryAdminAreaName, CountryAdminAreaCode, DateCreated FROM Device WHERE Status = ?";
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_int(statement, 1, aStatusType);
                
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    deviceLocation = [[DeviceLocation alloc]
                                      initWithLatitude:(double)sqlite3_column_double(statement, 0)
                                      longitude:(double)sqlite3_column_double(statement, 1)
                                      countryName:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]
                                      countryCode:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]
                                      countryAdminName:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]
                                      countryAdminCode:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]
                                      dateCreated:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 6)]];
                }
                
            }
            else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadOnly), sqlite3_errcode(self.databaseReadOnly)]) userInfo:(nil)];
            }
            
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        }
        @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
    
    return deviceLocation;
}

- (User *)getUserByApplicationId: (CFUUIDRef)anApplicationId statusType: (int)aStatusType {
    
    User *user = NULL;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        
        @try {
            const char *query = "SELECT ID, applicationGuid, SessionId, DateCreated, Age, Sex, Status, Version FROM User WHERE ApplicationGuid = ? AND (0 = ? OR Status = ?)";
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:anApplicationId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 2, aStatusType);
                sqlite3_bind_int(statement, 3, aStatusType);
                
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    user = [[User alloc]
                            initWithId:(int)sqlite3_column_int(statement, 0)
                            age:(int)sqlite3_column_int(statement, 4)
                            sexType:(int)sqlite3_column_int(statement, 5)
                            statusType:(int)sqlite3_column_int(statement, 6)
                            applicationId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)]]
                            dateCreated:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 3)]
                            sessionId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]]
                            version:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]];
                }
            }
            else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadOnly), sqlite3_errcode(self.databaseReadOnly)]) userInfo:(nil)];
            }
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        }
        @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
    
    return user;
}

- (ApplicationMeta *)loadApplicationByApplicationId: (CFUUIDRef)anApplicationId {
    
    ApplicationMeta *applicationMeta = NULL;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        @try {
            const char *query = "SELECT ApplicationGuid, DateCreated, ApplicationState, SessionId, Version, Upgraded, OptStatus FROM Application WHERE ApplicationGuid = ?";
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:anApplicationId] UTF8String], -1, SQLITE_TRANSIENT);
                
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    applicationMeta = [[ApplicationMeta alloc]
                                       initWithApplicationId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)]]
                                       applicationStateType:(int)sqlite3_column_int(statement, 2)
                                       sessionId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]]
                                       dateCreated:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 2)]
                                       version:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]
                                       upgraded:(int)sqlite3_column_int(statement, 5) == 1
                                       optStatus:(int)sqlite3_column_int(statement, 6)];
                }
                
            }
            else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadOnly), sqlite3_errcode(self.databaseReadOnly)]) userInfo:(nil)];
            }
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        }
        @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
    
    return applicationMeta;
}

- (PluginMeta *)loadPluginMeta {
    
    PluginMeta *pluginMeta;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        
        @try {
            const char *query = [@"SELECT schemaVersionNumeric FROM Meta" UTF8String];
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    pluginMeta = [[PluginMeta alloc]
                                  initWithSchemaVersionNumeric:(int)sqlite3_column_int(statement, 0)];
                }
            }
            else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadOnly), sqlite3_errcode(self.databaseReadOnly)]) userInfo:(nil)];
            }
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        }
        @finally {
            if(statement != NULL) {
                sqlite3_finalize(statement);
            }
        }
        
    }
    
    return pluginMeta;
}

- (void)saveUser: (User *)aUser {

    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "INSERT INTO User (ApplicationGuid, DateCreated, Age, Sex, Status, Version, SessionId) VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:aUser.applicationId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 2, aUser.dateCreated.timeIntervalSince1970);
                sqlite3_bind_int(statement, 3, aUser.age);
                sqlite3_bind_int(statement, 4, aUser.sex);
                sqlite3_bind_int(statement, 5, aUser.status);
                sqlite3_bind_text(statement, 6, [aUser.version UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [[Utils convertUuidToString:aUser.sessionId] UTF8String], -1, SQLITE_TRANSIENT);
                
                if(sqlite3_step(statement) != SQLITE_DONE) {
                    @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
                }
                
            } else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
            
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        } @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
}

- (void)saveDeviceLocation: (DeviceLocation *)aDeviceLocation statusType: (int)aStatusType {
    
    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "UPDATE Device SET Latitude = ?, Longitude = ?, CountryName = ?, CountryCode = ?, CountryAdminAreaName = ?, CountryAdminAreaCode = ?, Status = ?";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_double(statement, 1, aDeviceLocation.latitude);
                sqlite3_bind_double(statement, 2, aDeviceLocation.longitude);
                sqlite3_bind_text(statement, 3, [[Utils getValueNotNull: aDeviceLocation.countryName]  UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[Utils getValueNotNull: aDeviceLocation.countryCode]  UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [[Utils getValueNotNull: aDeviceLocation.countryAdminName]  UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [[Utils getValueNotNull: aDeviceLocation.countryAdminCode]  UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 7, aStatusType);
                
                if(sqlite3_step(statement) != SQLITE_DONE) {
                    @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
                }
            } else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
            
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        } @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
    
}

- (void)saveDeviceId: (CFUUIDRef)aDeviceId dateCreated: (NSDate *)aDateCreated {
    
    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "INSERT INTO Device (DeviceGuid, DateCreated, Status, Latitude, Longitude) VALUES (?, ?, 0, 0, 0)";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:aDeviceId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 2, aDateCreated.timeIntervalSince1970);
                
                if(sqlite3_step(statement) != SQLITE_DONE) {
                    @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
                }
            } else {
                    @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
            
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        } @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
    
}

- (void)saveApplicationMeta: (ApplicationMeta *)anApplicationMeta {

    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "INSERT INTO Application (ApplicationGuid, ApplicationState, DateCreated, Version, Upgraded, OptStatus) values (?, ?, ?, ?, ?, ?)";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:anApplicationMeta.id] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 2, anApplicationMeta.state);
                sqlite3_bind_int64(statement, 3, anApplicationMeta.dateCreated.timeIntervalSince1970);
                sqlite3_bind_text(statement, 4, [[Utils getValueNotNull:anApplicationMeta.version] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 5, anApplicationMeta.upgraded);
                sqlite3_bind_int(statement, 6, anApplicationMeta.optStatus);
                
                if(sqlite3_step(statement) != SQLITE_DONE) {
                    @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
                }
            } else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
            
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        } @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
}

- (void)savePluginMeta: (PluginMeta *)aPluginMeta {
    @try {
        
        const char *query = [[NSString stringWithFormat:
                              @"INSERT INTO Meta (schemaVersionNumeric) VALUES (%d)",
                              aPluginMeta.schemaVersionNumeric] UTF8String];
        
        @synchronized (self.databaseLock) {
            
            if (sqlite3_exec(self.databaseReadWrite, query, NULL, NULL, NULL) != SQLITE_OK) {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
        }
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
}

- (void)updateUser: (User *)aUser statusType: (int)aStatusType {
    @try {
        
        const char *query = [[NSString stringWithFormat:
                              @"UPDATE User SET Status = %d WHERE Id = %d",
                              aStatusType,
                              aUser.id] UTF8String];
        
        @synchronized (self.databaseLock) {
            
            if (sqlite3_exec(self.databaseReadWrite, query, NULL, NULL, NULL) != SQLITE_OK) {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
        }
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
}

- (void)updateApplication: (ApplicationMeta *)anApplicationMeta {
    
    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "UPDATE Application SET ApplicationState = ?, SessionId = ?, Version = ?, Upgraded = ?, OptStatus = ? WHERE ApplicationGuid = ?";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_int(statement, 1, anApplicationMeta.state);
                sqlite3_bind_text(statement, 2, [[Utils convertUuidToString:anApplicationMeta.sessionId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [[Utils getValueNotNull:anApplicationMeta.version] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 4, anApplicationMeta.upgraded);
                sqlite3_bind_int(statement, 5, anApplicationMeta.optStatus);
                sqlite3_bind_text(statement, 6, [[Utils convertUuidToString:anApplicationMeta.id] UTF8String], -1, SQLITE_TRANSIENT);
                
                if(sqlite3_step(statement) != SQLITE_DONE) {
                    @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
                }
            } else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        } @finally {
            if(statement != NULL)
                sqlite3_finalize(statement);
        }
    }
}

- (void)updatePluginMeta: (PluginMeta *)aPluginMeta {
    @try {
        
        const char *query = [[NSString stringWithFormat:
                              @"UPDATE Meta SET schemaVersionNumeric = %d",
                              aPluginMeta.schemaVersionNumeric] UTF8String];
        
        @synchronized (self.databaseLock) {
            
            if (sqlite3_exec(self.databaseReadWrite, query, NULL, NULL, NULL) != SQLITE_OK) {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
        }
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
}

@end
