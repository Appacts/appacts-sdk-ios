//
//  Item.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 17/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "Utils.h"

@interface Item : NSObject

{
    int id;
    CFUUIDRef applicationId;
    NSDate *dateCreated;
    NSString *version;
    CFUUIDRef sessionId;
}
@property (nonatomic) int id;
@property (nonatomic) CFUUIDRef applicationId;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSString *version;
@property (nonatomic) CFUUIDRef sessionId;


- (id)initWithApplicationId: (CFUUIDRef)anApplicationId sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;
- (id)initWithid: (int)anId applicationId: (CFUUIDRef)anApplicationId dateCreated: (NSDate *)aDateCreated sessionId: (CFUUIDRef)aSessionId version: (NSString *)aVersion;

@end
