//
//  BaseViewController.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 15/07/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "BaseViewController.h"

@implementation BaseViewController

@synthesize screenName;

 
- (id)initWithCoderAndScreenName:(NSCoder *)nsCoder screenName: (NSString *)aScreenName
{
    self = [super initWithCoder:nsCoder];
    
    if(self)
    {
        self.screenName = aScreenName;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AnalyticsSingleton getInstance] screenOpenWithScreenName:self.screenName];
}

- (void)viewWillUnload
{
    [super viewDidUnload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[AnalyticsSingleton getInstance] screenClosedWithScreenName:self.screenName];
    
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
