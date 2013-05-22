//
//  Account.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 14/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

{
    CFUUIDRef accountId;
    CFUUIDRef applicationId;
}
@property (nonatomic) CFUUIDRef accountId;
@property (nonatomic) CFUUIDRef applicationId;

- (id)initWithAccountId: (CFUUIDRef)anAccountId applicationId: (CFUUIDRef)anApplicationId;

@end
