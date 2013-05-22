//
//  HttpConnectionManager.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface HttpConnectionManager : NSObject

- (id)init;
+ (Boolean)hasNetworkCoverage;

@end
