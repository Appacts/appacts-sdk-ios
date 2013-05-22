//
//  Logger.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Logger.h"

@interface Logger()

{
    sqlite3 *databaseReadWrite;
    sqlite3 *databaseReadOnly;
}
@property (nonatomic) sqlite3 *databaseReadWrite;
@property (nonatomic) sqlite3 *databaseReadOnly;

@property (nonatomic) NSObject *databaseLock;

@end

@implementation Logger

@synthesize databaseReadWrite;
@synthesize databaseReadOnly;
@synthesize databaseLock;


- (id)initWithDatabaseReadWrite:
(sqlite3 *)aDatabaseReadWrite
               databaseReadOnly: (sqlite3 *) aDatabaseReadOnly
            databaseLock: (NSObject *) aDatabaseLock
{
    
    self = [super init];
    
    if(self) {
        self.databaseReadWrite = aDatabaseReadWrite;
        self.databaseReadOnly = aDatabaseReadOnly;
        self.databaseLock = aDatabaseLock;
    }
    
    return self;
}

- (Crash *)getCrashByApplicationId: (CFUUIDRef)anApplicationId {
    
    Crash *crash = NULL;
    sqlite3_stmt *statement;
    
    
    @synchronized(self.databaseLock) {
        
        @try {
            const char *query =  "SELECT ID, applicationGuid, SessionId, DateCreated, Version FROM Crash WHERE applicationGuid = ? LIMIT 1";
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:anApplicationId] UTF8String], -1, SQLITE_TRANSIENT);

                if (sqlite3_step(statement) == SQLITE_ROW) {
                    crash = [[Crash alloc]
                             initWithid:(int)sqlite3_column_int(statement, 0)
                             applicationId: [Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)]]
                             dateCreated:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 3)]
                             version:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]
                             sessionId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]]];
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
    
    return crash;
}

- (ErrorItem *)getErrorByApplicationId: (CFUUIDRef)anApplicationId {
    
    ErrorItem *errorItem = NULL;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        
        @try {
            const char *query = "SELECT ID, applicationGuid, SessionId, DateCreated, Data, EventName, AvailableFlashDriveSize, AvailableMemorySize, Battery, NetworkCoverage, ErrorReason, ErrorName, ScreenName, Version FROM Error WHERE applicationGuid = ? LIMIT 1";
            
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:anApplicationId] UTF8String], -1, SQLITE_TRANSIENT);
                
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    errorItem = [[ErrorItem alloc]
                                 initWithId:(int)sqlite3_column_int(statement, 0)
                                 applicationId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)]]
                                 screenName:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 12)]
                                 data:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]
                                 deviceGeneralInformation:[[DeviceGeneralInformation alloc] initWithAvailableFlashDriveSize:(uint64_t)sqlite3_column_int64(statement, 6) availableMemorySize:(long)sqlite3_column_int64(statement, 7) battery:(long)sqlite3_column_int(statement, 8) networkCoverage:(long)sqlite3_column_int(statement, 9)]
                                 eventName:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]
                                 exception:[[NSException alloc] initWithName:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 11)] reason:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 10)] userInfo:nil]
                                 dateCreated:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 3)]
                                 sessionId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]]
                                 version:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 13)]];
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
    
    return errorItem;
}

- (EventItem *)getEventItemByApplicationId: (CFUUIDRef)anApplicationId {
    
    EventItem *eventItem = NULL;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        
        @try {
            
            const char *query = "SELECT ID, applicationGuid, SessionId, DateCreated, Data, Event, EventName, Length, ScreenName, Version FROM Event WHERE applicationGuid = ? LIMIT 1";
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:anApplicationId] UTF8String], -1, SQLITE_TRANSIENT);
                
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    eventItem = [[EventItem alloc]
                                 initWithId:(int)sqlite3_column_int(statement, 0)
                                 applicationId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)]]
                                 screenName:(const char *)sqlite3_column_text(statement, 8) != NULL ? [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 8)] : nil
                                 data:(const char *)sqlite3_column_text(statement, 4) != NULL ? [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)] : nil
                                 eventType:(int)sqlite3_column_int(statement, 5)
                                 eventName:(const char *)sqlite3_column_text(statement, 6) != NULL ? [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 6)] : nil
                                 length:(long)sqlite3_column_double(statement, 7)
                                 dateCreated:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 3)]
                                 sessionId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]]
                                 version:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 9)]];
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
    
    return eventItem;
}

- (FeedbackItem *)getFeedbackItemByApplicationId: (CFUUIDRef)anApplicationId {
    
    FeedbackItem *feedbackItem = NULL;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        
        @try {
            const char *query = "SELECT ID, applicationGuid, SessionId, DateCreated, ScreenName, Feedback, FeedbackRating, Version FROM Feedback WHERE applicationGuid = ? LIMIT 1";
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:anApplicationId] UTF8String], -1, SQLITE_TRANSIENT);
                
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    feedbackItem = [[FeedbackItem alloc]
                                    initWithId:(int)sqlite3_column_int(statement, 0)
                                    applicationId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)]]
                                    screenName:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]
                                    message:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]
                                    ratingType:(int)sqlite3_column_int(statement, 6)
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
    
    return feedbackItem;
}

- (SystemError *)getSystemErrorByApplicationId: (CFUUIDRef)anApplicationId {
    
    SystemError *systemError;
    sqlite3_stmt *statement;
    
    @synchronized(self.databaseLock) {
        
        @try {
            const char *query = "SELECT ID, applicationGuid, DateCreated, ErrorMessage, Platform, SystemVersion, Version FROM SystemError WHERE applicationGuid = ? LIMIT 1";
            
            
            if (sqlite3_prepare_v2(self.databaseReadOnly, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:anApplicationId] UTF8String], -1, SQLITE_TRANSIENT);
                
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    systemError = [[SystemError alloc]
                                   initWithId:(int)sqlite3_column_int(statement, 0)
                                   applicationId:[Utils convertStringToUuid:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)]]
                                   exceptionDescriptive:[[ExceptionDescriptive alloc] initWithMessage:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]]
                                   analyticsSystem:[[AnalyticsSystem alloc] initWithDeviceType:(int)sqlite3_column_int(statement, 4) version:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]]
                                   dateCreated:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 2)]
                                   version:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]];
                }
            }
            else {
                @throw [[NSException alloc] initWithName:(@"sqlite") reason:([NSString stringWithFormat:@"message: %s code: %d ", sqlite3_errmsg(self.databaseReadOnly), sqlite3_errcode(self.databaseReadOnly)]) userInfo:(nil)];
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
    
    return systemError;
}

- (void)removeEventItem: (EventItem *)eventItem {
    
    sqlite3_stmt *statement;
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "DELETE FROM Event WHERE Id = ?";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_int(statement, 1, eventItem.id);
                
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

- (void)removeFeedbackItem: (FeedbackItem *)feedbackItem {
    
    sqlite3_stmt *statement;
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "DELETE FROM Feedback WHERE Id =  ?";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_int(statement, 1, feedbackItem.id);
                
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

- (void)removeErrorItem: (ErrorItem *)errorItem {
    
    sqlite3_stmt *statement;
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "DELETE FROM Error WHERE Id =  ?";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_int(statement, 1, errorItem.id);
                
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

- (void)removeSystemError: (SystemError *)systemError {

    sqlite3_stmt *statement;
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "DELETE FROM SystemError WHERE Id =  ?";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_int(statement, 1, systemError.id);
                
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

- (void)removeCrash: (Crash *)crash {
    sqlite3_stmt *statement;
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "DELETE FROM Crash WHERE Id = ?";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_int(statement, 1, crash.id);
                
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

- (void)saveEventItem: (EventItem *)eventItem {
    
    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "INSERT INTO Event (applicationGuid, DateCreated, Data, Event, EventName, Length, ScreenName, Version, SessionId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:eventItem.applicationId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 2, eventItem.dateCreated.timeIntervalSince1970);
                sqlite3_bind_text(statement, 3, [[Utils getValueNotNull:eventItem.data] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 4, eventItem.eventType);
                sqlite3_bind_text(statement, 5, [[Utils getValueNotNull:eventItem.eventName] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 6, eventItem.length);
                sqlite3_bind_text(statement, 7, [[Utils getValueNotNull:eventItem.screenName] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 8, [[Utils getValueNotNull:eventItem.version] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 9, [[Utils convertUuidToString:eventItem.sessionId] UTF8String], -1, SQLITE_TRANSIENT);
                
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

- (void)saveFeedbackItem: (FeedbackItem *)feedbackItem {
    
    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "INSERT INTO Feedback (applicationGuid, DateCreated, ScreenName, Feedback, FeedbackRating, Version, SessionId) VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:feedbackItem.applicationId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 2, feedbackItem.dateCreated.timeIntervalSince1970);
                sqlite3_bind_text(statement, 3, [[Utils getValueNotNull:feedbackItem.screenName] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[Utils getValueNotNull:feedbackItem.message] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 5, feedbackItem.rating);
                sqlite3_bind_text(statement, 6, [feedbackItem.version UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [[Utils convertUuidToString:feedbackItem.sessionId] UTF8String], -1, SQLITE_TRANSIENT);
                
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

- (void)saveErrorItem: (ErrorItem *)errorItem  {
    
    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "INSERT INTO Error (applicationGuid, DateCreated, ErrorReason, ErrorName, Data, EventName, AvailableFlashDriveSize, AvailableMemorySize, Battery, NetworkCoverage, ScreenName, Version, SessionId) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
    
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:errorItem.applicationId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 2, errorItem.dateCreated.timeIntervalSince1970);
                sqlite3_bind_text(statement, 3, [[Utils getValueNotNull:errorItem.error.reason] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[Utils getValueNotNull:errorItem.error.name] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [[Utils getValueNotNull:errorItem.data] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [[Utils getValueNotNull:errorItem.eventName] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 7, errorItem.deviceInformation.availableFlashDriveSize);
                sqlite3_bind_int64(statement, 8, errorItem.deviceInformation.availableMemorySize);
                sqlite3_bind_int(statement, 9, errorItem.deviceInformation.battery);
                sqlite3_bind_int(statement, 10, errorItem.deviceInformation.networkCoverage);
                sqlite3_bind_text(statement, 11, [[Utils getValueNotNull:errorItem.screenName] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 12, [errorItem.version UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 13, [[Utils convertUuidToString:errorItem.sessionId] UTF8String], -1, SQLITE_TRANSIENT);
                
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

- (void)saveSystemError: (SystemError *)systemError {

    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "INSERT INTO SystemError (applicationGuid, DateCreated, ErrorMessage, ErrorStackTrace, ErrorSource, ErrorData, Platform, SystemVersion, Version) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:systemError.applicationId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 2, systemError.dateCreated.timeIntervalSince1970);
                sqlite3_bind_text(statement, 3, [[Utils getValueNotNull:systemError.error.description] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[Utils getValueNotNull:systemError.error.stackTrace] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [[Utils getValueNotNull:systemError.error.source] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [[Utils getValueNotNull: systemError.error.data] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 7,  systemError.system.deviceType);
                sqlite3_bind_text(statement, 8, [[Utils getValueNotNull: systemError.system.version] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 9, [[Utils getValueNotNull:systemError.version] UTF8String], -1, SQLITE_TRANSIENT);
                
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

- (void)saveCrash: (Crash *)crash {
    
    sqlite3_stmt *statement;
    
    @synchronized (self.databaseLock) {
        @try {
            
            const char *query = "INSERT INTO Crash (applicationGuid, DateCreated, Version, SessionId) VALUES (?, ?, ?, ?)";
            
            if(sqlite3_prepare_v2(self.databaseReadWrite, query, -1, &statement, NULL) == SQLITE_OK) {
                
                sqlite3_bind_text(statement, 1, [[Utils convertUuidToString:crash.applicationId] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int64(statement, 2, crash.dateCreated.timeIntervalSince1970);
                sqlite3_bind_text(statement, 3, [crash.version UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[Utils convertUuidToString:crash.sessionId] UTF8String], -1, SQLITE_TRANSIENT);
                
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

@end
