//
//  Logger.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Crash.h"
#import "ExceptionDatabaseLayer.h"
#import "ErrorItem.h"
#import "EventItem.h"
#import "FeedbackItem.h"
#import "SystemError.h"
#import "Utils.h"

#import "sqlite3.h"

@interface Logger : NSObject

- (id)initWithDatabaseReadWrite:
    (sqlite3 *)aDatabaseReadWrite
               databaseReadOnly: (sqlite3 *) aDatabaseReadOnly databaseLock: (NSObject *) aDatabaseLock;

- (Crash *)getCrashByApplicationId: (CFUUIDRef)anApplicationId;
- (ErrorItem *)getErrorByApplicationId: (CFUUIDRef)anApplicationId;
- (EventItem *)getEventItemByApplicationId: (CFUUIDRef)anApplicationId;
- (FeedbackItem *)getFeedbackItemByApplicationId: (CFUUIDRef)anApplicationId;
- (SystemError *)getSystemErrorByApplicationId: (CFUUIDRef)anApplicationId;

- (void)removeEventItem: (EventItem *)eventItem;
- (void)removeFeedbackItem: (FeedbackItem *)feedbackItem;
- (void)removeErrorItem: (ErrorItem *)errorItem;
- (void)removeSystemError: (SystemError *)systemError;
- (void)removeCrash: (Crash *)crash;

- (void)saveEventItem: (EventItem *)eventItem;
- (void)saveFeedbackItem: (FeedbackItem *)feedbackItem;
- (void)saveErrorItem: (ErrorItem *)errorItem;
- (void)saveSystemError: (SystemError *)systemError;
- (void)saveCrash: (Crash *)crash;

@end
