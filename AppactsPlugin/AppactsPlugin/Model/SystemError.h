//
//  SystemError.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "ExceptionDescriptive.h"
#import "AnalyticsSystem.h"

@interface SystemError : Item

{
    ExceptionDescriptive *error;
    AnalyticsSystem *system;
}
@property (nonatomic, strong) ExceptionDescriptive *error;
@property (nonatomic, strong) AnalyticsSystem *system;

- initWithApplicationId: (CFUUIDRef)anApplicationId exceptionDescriptive: (ExceptionDescriptive *)anExceptionDescriptive analyticsSystem: (AnalyticsSystem *)anAnalyticsSystem version: (NSString *)aVersion;
- initWithId: (int)anId applicationId: (CFUUIDRef)anApplicationId exceptionDescriptive: (ExceptionDescriptive *)anExceptionDescriptive analyticsSystem: (AnalyticsSystem *)anAnalyticsSystem dateCreated: (NSDate *)aDateCreated version: (NSString *)aVersion;

@end
