//
//  FeedbackViewController.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize lblRating;
@synthesize pvRating;
@synthesize ratings;
@synthesize txtComment;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoderAndScreenName:aDecoder screenName:@"Feedback"];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ratings = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
}

- (IBAction)btnChooseRatingClick:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    CGRect pvRatingFrame = self.pvRating.frame;
    pvRatingFrame.origin.y = 244.0f;
    self.pvRating.frame = pvRatingFrame;
    
    [UIView commitAnimations];
}

- (IBAction)btnCancelClick:(id)sender
{
    [self performSegueWithIdentifier:@"ShowCat" sender:self];
}

- (IBAction)btnSubmitClick:(id)sender
{
    @try
    {
        int rating = [[self.lblRating text] intValue];
        
        [[AnalyticsSingleton getInstance] logFeedbackWithScreenName:self.screenName rating:(RatingType)rating comment:[self.txtComment text]];
    }
    @catch (NSException *exception)
    {
        //todo: can't save feedback, see exception for more info.
    }
    
    [self performSegueWithIdentifier:@"ShowCat" sender:self];
}

- (IBAction)backgroundTouched:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    CGRect pvRatingFrame = self.pvRating.frame;
    pvRatingFrame.origin.y = 640.0f;
    self.pvRating.frame = pvRatingFrame;
    
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark PickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.ratings count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        return [self.ratings objectAtIndex:row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.lblRating.text = [self.ratings objectAtIndex:row];
}


@end
