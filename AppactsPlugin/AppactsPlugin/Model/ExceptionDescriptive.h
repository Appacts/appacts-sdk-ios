//
//  ExceptionDescriptive.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 19/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExceptionDescriptive : NSException

{
    NSString *stackTrace;
    NSString *data;
    NSString *source;
}
@property (nonatomic, strong) NSString *stackTrace;
@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSString *source;

- (id)initWithMessage: (NSString *)aMessage;
- (id)initWithException: (NSException *)anException;
- (id)initWithException: (NSException *)anException data: (NSString *)aData;
- (id)initWithMessage: (NSString *)aMessage stackTrace: (NSString *)aStackTrace source: (NSString *)aSource data: (NSString *)aData;

@end
