//
//  Session.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

{
    NSDate *dateStart;
    NSString *name;
}
@property (nonatomic, strong) NSDate *dateStart;
@property (nonatomic, strong) NSString *name;

- (id)init;
- (id)initWithScreenName: (NSString *)aScreenName;
- (long)end;
- (bool)equalsWithObject: (NSObject *)anObject;

@end
