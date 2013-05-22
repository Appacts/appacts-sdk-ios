//
//  User.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize age;
@synthesize sex;
@synthesize status;

- (id)initWithAge: (int)anAge sexType: (int)aSexType statusType: (int)aStatusType applicationId: (CFUUIDRef)anApplicationId sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithApplicationId:anApplicationId sessionId:aSessionId version:aVersion];
    
    self.age = anAge;
    self.sex = aSexType;
    self.status = aStatusType;
    
    return self;
}

- (id)initWithId: (int)anId age: (int)anAge sexType: (int)aSexType statusType: (int)aStatusType applicationId: (CFUUIDRef)anApplicationId dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion
{
    self = [super initWithid:anId applicationId:anApplicationId dateCreated:aDateCreated sessionId:aSessionId version:aVersion];
    
    self.age = anAge;
    self.sex = aSexType;
    self.status = aStatusType;
    
    return self;
}

@end
