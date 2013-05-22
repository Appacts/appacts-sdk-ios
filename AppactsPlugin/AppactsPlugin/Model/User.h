//
//  User.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface User : Item

{
    int age;
    int sex;
    int status;
}
@property (nonatomic) int age;
@property (nonatomic) int sex;
@property (nonatomic) int status;

- (id)initWithAge: (int)anAge sexType: (int)aSexType statusType: (int)aStatusType applicationId: (CFUUIDRef)anApplicationId sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;
- (id)initWithId: (int)anId age: (int)anAge sexType: (int)aSexType statusType: (int)aStatusType applicationId: (CFUUIDRef)anApplicationId dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;

@end
