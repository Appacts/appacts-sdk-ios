//
//  SplashViewController.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoderAndScreenName:aDecoder screenName:@"Splash"];
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[AnalyticsSingleton getInstance] getOptStatus] == None)
    {
        [self performSegueWithIdentifier:@"ShowTermsAndConditions" sender:self];
    }
    else if (![[AnalyticsSingleton getInstance] isUserInformationSet])
    {
        [self performSegueWithIdentifier:@"ShowDemographic" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowCat" sender:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
