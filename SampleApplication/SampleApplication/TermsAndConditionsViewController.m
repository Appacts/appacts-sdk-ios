//
//  TermsAndConditionsViewController.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "TermsAndConditionsViewController.h"

@interface TermsAndConditionsViewController ()

@end

@implementation TermsAndConditionsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoderAndScreenName:aDecoder screenName:@"TermsAndCondition"];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)btnDoNotAgreeClick:(id)sender
{
    if (![[AnalyticsSingleton getInstance] isUserInformationSet])
    {
        [self performSegueWithIdentifier:@"ShowDemographic" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowCat" sender:self];
    }
}

- (IBAction)btnAgreeClick:(id)sender
{
    [[AnalyticsSingleton getInstance] setOptStatus:OptIn];
    
    if (![[AnalyticsSingleton getInstance] isUserInformationSet])
    {
        [self performSegueWithIdentifier:@"ShowDemographic" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowCat" sender:self];
    }
}

@end
