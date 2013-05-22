//
//  ItemWithScreen.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface ItemWithScreen : Item

{
    NSString *screenName;
}
@property (nonatomic, strong) NSString *screenName;

- (id)initWithApplicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;
- (id)initWithId: (int)anId applicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;

@end
