//
//  HttpConnectionManager.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "HttpConnectionManager.h"

@interface HttpConnectionManager()

{
    
}

@end

@implementation HttpConnectionManager

- (id)init {
    return self;
}

+ (Boolean)hasNetworkCoverage {
    
    Reachability *r = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
    
}

@end
