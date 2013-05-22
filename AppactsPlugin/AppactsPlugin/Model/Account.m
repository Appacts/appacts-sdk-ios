//
//  Account.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 14/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Account.h"

@implementation Account

@synthesize accountId;
@synthesize applicationId;

- (id)initWithAccountId: (CFUUIDRef)anAccountId applicationId: (CFUUIDRef)anApplicationId
{
    self.accountId = anAccountId;
    self.applicationId = anApplicationId;
    
    return self;
}

@end
