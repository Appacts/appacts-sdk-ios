//
//  AnalyticsSingleton.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 13/06/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "AnalyticsSingleton.h"

@interface AnalyticsSingleton()
{
    
}

@end

@implementation AnalyticsSingleton

static Analytics *analytics = NULL;

+ (Analytics *)getInstance {
    if (analytics == NULL) {
        @synchronized(self) {
            analytics = [[Analytics alloc] init];
        }
    }
    
    return analytics;
}

@end
