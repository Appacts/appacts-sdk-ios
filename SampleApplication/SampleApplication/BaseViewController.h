//
//  BaseViewController.h
//  SampleApplication
//
//  Created by Jamie Wheeldon on 15/07/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import <UIKit/UIKit.h>

#import <AppactsPlugin/AppactsPlugin.h>

@interface BaseViewController : UIViewController

{
    NSString *screenName;
}
@property (strong, nonatomic) NSString *screenName;

- (id)initWithCoderAndScreenName:(NSCoder *)nsCoder screenName: (NSString *)aScreenName;

@end
