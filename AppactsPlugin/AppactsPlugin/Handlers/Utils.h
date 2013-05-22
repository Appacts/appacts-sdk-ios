//
//  Utils.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSDate *)getDateTimeNow;
+ (int)getTimeOffSet;
+ (NSString *)dateTimeFormat: (NSDate *)aDate;
+ (NSString *)getValueNotNull: (NSString *)aString ;
+ (NSString *)convertUuidToString: (CFUUIDRef)anUuid;
+ (CFUUIDRef)convertStringToUuid:(NSString *)anString;
@end
