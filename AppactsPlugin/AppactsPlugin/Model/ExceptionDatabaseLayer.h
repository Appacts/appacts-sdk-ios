//
//  ExceptionDatabaseLayer.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExceptionDescriptive.h"

@interface ExceptionDatabaseLayer : ExceptionDescriptive

- (id)initWithException:(NSException *)anException;
- (NSString *) toString;

@end
