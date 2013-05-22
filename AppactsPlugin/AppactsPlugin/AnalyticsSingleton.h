//
//  AnalyticsSingleton.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 13/06/2012. Modified By Zan Kavtaskin 25/12/2012 23:04.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Analytics.h"

@interface AnalyticsSingleton : NSObject

+ (Analytics *)getInstance;

@end
