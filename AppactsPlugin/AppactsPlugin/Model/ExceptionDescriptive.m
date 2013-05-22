//
//  ExceptionDescriptive.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 19/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "ExceptionDescriptive.h"

@implementation ExceptionDescriptive

@synthesize stackTrace;
@synthesize data;
@synthesize source;

- (id)initWithMessage: (NSString *)aMessage
{
    self = [super initWithName:@"ExceptionDescriptive" reason:aMessage userInfo:nil];
    
    self.stackTrace = nil;
    self.data = nil;
    self.source = nil;
    
    return self;
}

- (id)initWithException: (NSException *)anException
{
    self = [super initWithName:anException.name reason:anException.reason userInfo:anException.userInfo];
    
    self.stackTrace = anException.reason;
    self.data = nil;
    self.source = nil;
    
    return self;
}

- (id)initWithException: (NSException *)anException data: (NSString *)aData
{
    self = [super initWithName:anException.name reason:anException.reason userInfo:anException.userInfo];
    
    self.stackTrace = anException.reason;
    self.data = aData;
    self.source = nil;
    
    return self;
}

- (id)initWithMessage: (NSString *)aMessage stackTrace: (NSString *)aStackTrace source: (NSString *)aSource data: (NSString *)aData
{
    self = [super initWithName:@"ExceptionDescriptive" reason:aMessage userInfo:nil];
    
    self.stackTrace = aStackTrace;
    self.data = aData;
    self.source = aSource;
    
    return self;
}

@end
