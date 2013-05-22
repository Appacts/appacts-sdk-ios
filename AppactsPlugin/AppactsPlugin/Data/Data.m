//
//  Data.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Data.h"

@interface Data()

{
    NSString *connectionString;
    NSString *baseConnectionString;
    sqlite3 *databaseReadWrite;
    sqlite3 *databaseReadOnly;
    NSObject *databaseReadWriteLock;
}
@property (nonatomic, strong) NSString *connectionString;
@property (nonatomic, strong) NSString *baseConnectionString;
@property (nonatomic) sqlite3 *databaseReadWrite;
@property (nonatomic) sqlite3 *databaseReadOnly;
@property (nonatomic) NSObject *databaseLock;

@end

@implementation Data

@synthesize connectionString;
@synthesize baseConnectionString;
@synthesize databaseReadWrite;
@synthesize databaseReadOnly;
@synthesize databaseLock;

- (id)initWithConnectionString: (NSString *)aConnectionString {
    
    self = [super init];
    
    if(self) {
        self.connectionString = aConnectionString;
        
        self.baseConnectionString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) objectAtIndex:0];
        
        self.databaseLock = [[NSObject alloc] init];
    }
    
    return self;
}


- (void)create {
    @try {
        if (sqlite3_open([[self.baseConnectionString stringByAppendingString:self.connectionString] UTF8String], &databaseReadOnly) != SQLITE_OK) {
            @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
        }
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
}


- (void)setup {
    @try {
        sqlite3 *database = self.openReadWriteConnection;
        
        NSArray *sqlBase = [NSArray arrayWithObjects:
            @"CREATE TABLE 'Crash' ( 'ID' INTEGER PRIMARY KEY, 'applicationGuid' TEXT, 'DateCreated' TIMESTAMP, 'Version' NVARCHAR(64))",
        
            @"CREATE TABLE 'Error' ( 'ID' INTEGER PRIMARY KEY, 'applicationGuid' VARCHAR(36), 'DateCreated' TIMESTAMP,"
            @" 'Data' NVARCHAR(256), 'EventName' NVARCHAR(256),  'AvailableFlashDriveSize' INTEGER, "
            @" 'AvailableMemorySize' INTEGER, 'Battery' INTEGER, 'NetworkCoverage' INTEGER,"
            @" 'ErrorReason' NVARCHAR(1024), 'ErrorName' NVARCHAR(1024), "
            @" 'ScreenName' NVARCHAR(256), 'Version' NVARCHAR(64) "
            @"  )",
        
            @"CREATE TABLE 'Event' ( 'ID' INTEGER PRIMARY KEY, 'applicationGuid' NVARCHAR(36), 'DateCreated' TIMESTAMP,"
            @" 'Data' NVARCHAR(256), 'Event' INTEGER, 'EventName' NVARCHAR(256), 'Length' INTEGER, 'ScreenName' NVARCHAR(256), 'Version' NVARCHAR(64))",
        
            @"CREATE TABLE 'Feedback' ( 'ID' INTEGER PRIMARY KEY, 'applicationGuid' NVARCHAR(36), 'DateCreated' TIMESTAMP,"
            @" 'ScreenName' NVARCHAR(256), 'Feedback' TEXT, 'FeedbackRating' INTEGER, 'Version' NVARCHAR(64))",
        
            @"CREATE TABLE 'SystemError' ( 'ID' INTEGER PRIMARY KEY, 'applicationGuid' NVARCHAR(36), 'DateCreated' TIMESTAMP,"
            @" 'ErrorMessage' NVARCHAR(1024), 'ErrorStackTrace' TEXT, 'ErrorSource' NVARCHAR(1024), 'ErrorData' NVARCHAR(256),"
            @" 'Platform' INTEGER, 'SystemVersion' NVARCHAR(64), 'Version' NVARCHAR(64) )",
        
            @"CREATE TABLE 'User' (  'ID' INTEGER PRIMARY KEY, 'applicationGuid' NVARCHAR(36), 'DateCreated' TIMESTAMP,"
            @" 'Age' INTEGER, 'Sex' INTEGER, 'Status' INTEGER, 'Version' NVARCHAR(64))",
        
            @"CREATE TABLE 'Application' ( 'applicationGuid' NVARCHAR(36), 'DateCreated' TIMESTAMP, 'ApplicationState' INTEGER, 'OptStatus' INTEGER)",
        
            @"CREATE TABLE 'Device' ( 'DeviceGuid' NVARCHAR(36), 'DateCreated' TIMESTAMP, "
            @" 'Status' INTEGER, 'Latitude' NUMERIC(9,6), 'Longitude' NUMERIC(9, 6),"
            @" 'CountryName' NVARCHAR(256), 'CountryCode' NVARCHAR(256), 'CountryAdminAreaName' NVARCHAR(256), 'CountryAdminAreaCode' NVARCHAR(256))"
                              
            , nil];
        
        for (NSString *sqlStatement in sqlBase) {
            @autoreleasepool {
                if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
                    @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
                }
            }
        }
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
}

- (Boolean)exists {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:[self.baseConnectionString stringByAppendingString:self.connectionString]];
}

- (sqlite3 *)openReadWriteConnection {
    
    if (self.databaseReadWrite == nil) {
        @try {
            if (sqlite3_open_v2([[self.baseConnectionString stringByAppendingString:self.connectionString] UTF8String], &databaseReadWrite, SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX | SQLITE_OPEN_SHAREDCACHE, NULL) != SQLITE_OK) {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
            }
            
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        }
        
    }
    
    return self.databaseReadWrite;
}

- (void)closeReadWriteConnection {
    @try {
        if (self.databaseReadWrite != nil) {
            sqlite3_close(self.databaseReadWrite);
            self.databaseReadWrite = nil;
        }
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
}

- (sqlite3 *)openReadOnlyConnection {
    if (self.databaseReadOnly == nil) {
        @try {
            if (sqlite3_open_v2([[self.baseConnectionString stringByAppendingString:self.connectionString] UTF8String], &databaseReadOnly, SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX | SQLITE_OPEN_SHAREDCACHE, NULL) != SQLITE_OK) {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadOnly), sqlite3_errcode(self.databaseReadOnly)]) userInfo:(nil)];
            }
        }
        @catch (NSException *exception) {
            @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
        }
    }
    
    return self.databaseReadOnly;
}

- (void)closeReadOnlyConnection {
    @try {
        if (self.databaseReadOnly != nil) {
            sqlite3_close(self.databaseReadOnly);
            self.databaseReadOnly = nil;
        }
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
}

- (NSObject *) getDatabaseLock {
    return self.databaseLock;
}

- (void)dispose {
    @try {
        [self closeReadOnlyConnection];
        [self closeReadWriteConnection];
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
}

- (Boolean)upgradeSchemaWithCurrentPluginVersion: (int)aPluginVersion oldSchemaVersion: (int)aSchemaVersion {
    Boolean upgraded = false;
    
    @try {
        sqlite3 *database = self.openReadWriteConnection;
        
        if (aPluginVersion != aSchemaVersion) {
            NSArray *sqlAlter = NULL;
            
            if (aSchemaVersion == -1) {
                sqlAlter = self.upgradeSchemaAddSessionAndMeta;
            }
            
            if (sqlAlter != NULL) {
                for (NSString *sqlStatement in sqlAlter) {
                    @autoreleasepool {
                     
                        if (sqlite3_exec(database, [sqlStatement UTF8String], NULL, NULL, NULL) != SQLITE_OK) {
                            @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code:%d ", sqlite3_errmsg(self.databaseReadWrite), sqlite3_errcode(self.databaseReadWrite)]) userInfo:(nil)];
                        }
                        
                    }
                }
            }
            
            upgraded = true;
        }
        
    }
    @catch (NSException *exception) {
        @throw [[ExceptionDatabaseLayer alloc] initWithException:(exception)];
    }
    
    return upgraded;
}

-(NSArray *)upgradeSchemaAddSessionAndMeta {
    NSArray *sqlAlter = [NSArray arrayWithObjects:
        @"ALTER TABLE 'Crash' ADD 'SessionId' NVARCHAR(36)",
        @"ALTER TABLE 'Error' ADD 'SessionId' NVARCHAR(36)",
        @"ALTER TABLE 'Event' ADD 'SessionId' NVARCHAR(36)",
        @"ALTER TABLE 'Feedback' ADD 'SessionId' NVARCHAR(36)",
        @"ALTER TABLE 'User' ADD 'SessionId' NVARCHAR(36)",
        @"ALTER TABLE Application ADD SessionId NVARCHAR(36)",
        @"ALTER TABLE Application ADD Version NVARCHAR(64)",
        @"ALTER TABLE Application ADD Upgraded BOOLEAN",
        @"CREATE TABLE Meta ('schemaVersionNumeric' INTEGER)", nil];
    
    return sqlAlter;
}

@end
