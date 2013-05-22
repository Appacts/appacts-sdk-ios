//
//  FeedbackItem.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemWithScreen.h"

@interface FeedbackItem : ItemWithScreen

{
    NSString *message;
    int rating;
}
@property (nonatomic, strong) NSString *message;
@property (nonatomic) int rating;

- (id)initWithApplicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName message: (NSString *)aMessage ratingType: (int)aRatingType sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;
- (id)initWithId: (int)anId applicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName message: (NSString *)aMessage ratingType: (int)aRatingType dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;

@end
