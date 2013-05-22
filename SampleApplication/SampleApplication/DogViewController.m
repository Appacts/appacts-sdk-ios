//
//  DogViewController.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "DogViewController.h"

@interface DogViewController ()

@property NSArray * dogNames;

@end

@implementation DogViewController


@synthesize lblDogName;
@synthesize dogNames;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoderAndScreenName:aDecoder screenName:@"Dog"];
    
    if(self) {
        self.dogNames = [[NSArray alloc] initWithObjects:@"Woof", @"Doggie", @"Doug", @"Dog", @"Ben", nil];
    }
    
    return self;
}

- (IBAction)btnGenerateClick:(id)sender
{
    [[AnalyticsSingleton getInstance] logEventWithScreenName:self.screenName eventName:@"Generate" data:NULL];
    
    [[AnalyticsSingleton getInstance] contentLoadingWithScreenName:self.screenName contentName:@"GeneratingDog"];
    
    @try
    {
        self.lblDogName.text = [self.dogNames objectAtIndex: (arc4random() % [dogNames count]) + 1];
    }
    @catch (NSException *exception)
    {
        [[AnalyticsSingleton getInstance] logErrorWithScreenName:self.screenName eventName:@"Generate" data:NULL exception:exception];
    }
    
    [[AnalyticsSingleton getInstance] contentLoadedWithScreenName:self.screenName contentName:@"GeneratingDog"];
}

- (IBAction)btnFeedbackClick:(id)sender
{
    [self performSegueWithIdentifier:@"ShowFeedback" sender:self];
}

- (IBAction)btnCatClick:(id)sender
{
    [self performSegueWithIdentifier:@"ShowCat" sender:self];
}

@end
