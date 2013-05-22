//
//  FeedbackItem.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "FeedbackItem.h"

@implementation FeedbackItem

@synthesize message;
@synthesize rating;

- (id)initWithApplicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName message: (NSString *)aMessage ratingType: (int)aRatingType sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithApplicationId:anApplicationId screenName:aScreenName sessionId:aSessionId version:aVersion];
    
    self.message = aMessage;
    self.rating = aRatingType;
    
    return self;
}

- (id)initWithId: (int)anId applicationId: (CFUUIDRef)anApplicationId screenName: (NSString *)aScreenName message: (NSString *)aMessage ratingType: (int)aRatingType dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithId:anId applicationId:anApplicationId screenName:aScreenName dateCreated:aDateCreated sessionId:aSessionId version:aVersion];
    
    self.message = aMessage;
    self.rating = aRatingType;
    
    return self;
}

@end
