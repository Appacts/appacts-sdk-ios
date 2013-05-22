//
//  Crash.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 17/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "Item.h"

@interface Crash : Item

- (id)initWithapplicationId: (CFUUIDRef)anApplicationId sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;
- (id)initWithid: (int)anId applicationId: (CFUUIDRef)anApplicationId dateCreated: (NSDate *)aDateCreated version: (NSString *)aVersion sessionId: (CFUUIDRef)aSessionId;

@end
