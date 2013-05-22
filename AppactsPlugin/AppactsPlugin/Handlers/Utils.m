//
//  Utils.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSDate *)getDateTimeNow {
    return [[NSDate alloc] initWithTimeIntervalSinceNow:0];
}

+ (int)getTimeOffSet {
    return [[NSTimeZone localTimeZone] secondsFromGMT] / 3600;
}

+ (NSString *)dateTimeFormat: (NSDate *)aDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm"];
    
    NSLog(@"%@", [dateFormatter stringFromDate:aDate]);
    
    return [dateFormatter stringFromDate:aDate];
}

+ (NSString *)getValueNotNull: (NSString *)aString {
    if (aString == NULL || aString.length == 0) {
        return @"";
    }
    return aString;
}

+ (NSString *)convertUuidToString:(CFUUIDRef)anUuid   {
    NSString *string = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, anUuid);
    return string;
}

+ (CFUUIDRef)convertStringToUuid:(NSString *)anString   {
    CFUUIDRef uuid = CFUUIDCreateFromString(kCFAllocatorDefault, (__bridge CFStringRef)(anString));
    return uuid;
}

@end
