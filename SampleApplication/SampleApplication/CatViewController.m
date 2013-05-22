//
//  CatViewController.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "CatViewController.h"

@interface CatViewController ()

@property NSArray *catNames;

@end

@implementation CatViewController


@synthesize catNames;
@synthesize lblCatName;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoderAndScreenName:aDecoder screenName:@"Cat"];
    
    if(self) {
        self.catNames = [[NSArray alloc] initWithObjects:@"Meow", @"Kitty", @"Sammy", @"Cat", @"Lucy", nil];
    }
    
    return self;
}

- (IBAction)btnGenerateClick:(id)sender
{
    [[AnalyticsSingleton getInstance] logEventWithScreenName:self.screenName eventName:@"Generate" data:NULL];

    [[AnalyticsSingleton getInstance] contentLoadingWithScreenName:self.screenName contentName:@"GeneratingCat"];
    
    @try
    {
        self.lblCatName.text = [self.catNames objectAtIndex: (arc4random() % [catNames count]) + 1];
    }
    @catch (NSException *exception)
    {
        [[AnalyticsSingleton getInstance] logErrorWithScreenName:self.screenName eventName:@"Generate" data:NULL exception:exception];
    }
    
    [[AnalyticsSingleton getInstance] contentLoadedWithScreenName:self.screenName contentName:@"GeneratingCat"];
}

- (void)loadSomeData {
    [[AnalyticsSingleton getInstance] logEventWithScreenName:self.screenName eventName:@"Generate" data:NULL];
}

- (IBAction)btnDogClick:(id)sender
{
    [self performSegueWithIdentifier:@"ShowDog" sender:self];
}

- (IBAction)btnFeedbackClick:(id)sender
{
    [self performSegueWithIdentifier:@"ShowFeedback" sender:self];
}

@end
