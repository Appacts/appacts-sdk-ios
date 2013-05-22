//
//  AppDelegate.m
//  SampleApplicationBasic
//
//  Created by Zan Kavtaskin on 25/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Set the event handler
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //start main analytics session
    [[AnalyticsSingleton getInstance] startWithApplicationId:@"84ddec93-198a-449c-9069-fa842536d25c" baseUrl:@"http://api-dev.appacts.com/"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //stop analytics session as applications goes to background
    [[AnalyticsSingleton getInstance] stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //start analytics session as applications comes back from backround
    [[AnalyticsSingleton getInstance] startWithApplicationId:@"84ddec93-198a-449c-9069-fa842536d25c" baseUrl:@"http://api-dev.appacts.com/"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //end main analytics session
    [[AnalyticsSingleton getInstance] stop];
}

//We strongly recommend that you have generic uncaught exception handler
void uncaughtExceptionHandler(NSException *exception) {
    [[AnalyticsSingleton getInstance] logErrorWithScreenName:@"AppDelegate" eventName:@"Uncaught" data:nil exception:exception];
}

@end
