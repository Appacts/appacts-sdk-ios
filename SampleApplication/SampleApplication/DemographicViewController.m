//
//  DemographicViewController.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "DemographicViewController.h"

@interface DemographicViewController ()

@end

@implementation DemographicViewController
@synthesize lblAge = _txtAge;
@synthesize lblSex = _txtSex;
@synthesize pvAge = _pvAge;
@synthesize pvSex = _pvSex;
@synthesize ages = _ages;
@synthesize sex = _sex;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoderAndScreenName:aDecoder screenName:@"Demographic"];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSMutableArray *stringArray = [[NSMutableArray alloc] init];
    for(int i = 1; i < 120; i++){
        [stringArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    self.ages = stringArray;
    
    self.sex = [[NSArray alloc] initWithObjects:@"Male", @"Female", nil];
}

- (void)viewDidUnload
{
    [self setLblAge:nil];
    [self setLblSex:nil];
    [self setPvAge:nil];
    [self setPvSex:nil];
    [super viewDidUnload];
}

- (IBAction)btnChooseAge:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    CGRect pvAgeFrame = self.pvAge.frame;
    pvAgeFrame.origin.y = 244.0f;
    self.pvAge.frame = pvAgeFrame;
    
    [UIView commitAnimations];
}

- (IBAction)btnChooseSex:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    CGRect pvSexFrame = self.pvSex.frame;
    pvSexFrame.origin.y = 244.0f;
    self.pvSex.frame = pvSexFrame;
    
    [UIView commitAnimations];
}

- (IBAction)btnSkipClick:(id)sender
{
    [self performSegueWithIdentifier:@"ShowCat" sender:self];
}

- (IBAction)btnOkClick:(id)sender
{
    
    int age = [[self.lblAge text] intValue];
    
    SexType sexType = Female;
    
    if([[self.lblSex text] isEqualToString:@"Male"]) {
        sexType = Male;
    }
    
    @try {
        [[AnalyticsSingleton getInstance] setUserInformationWithAge:age sexType:sexType];
    }
    @catch (NSException *exception) {
        //couldn't save user info db is not working or other issue, see exception
    }
    @finally {
        //todo: clean up
    }
    
    [self performSegueWithIdentifier:@"ShowCat" sender:self];
}

- (IBAction)backgroundTouched:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    
    CGRect pvAgeFrame = self.pvAge.frame;
    pvAgeFrame.origin.y = 640.0f;
    self.pvAge.frame = pvAgeFrame;
    
    CGRect pvSexFrame = self.pvSex.frame;
    pvSexFrame.origin.y = 640.0f;
    self.pvSex.frame = pvSexFrame;
    
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark -
#pragma mark PickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView: (UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRows = 0;
    
    if (pickerView.tag == 1)
    {
        numberOfRows = [self.ages count];
    }
    else if (pickerView.tag == 2)
    {
        numberOfRows = [self.sex count];
    }
    
    return numberOfRows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    
    if (pickerView.tag == 1)
    {
        title = [self.ages objectAtIndex:row];
    }
    else if (pickerView.tag == 2)
    {
        title = [self.sex objectAtIndex:row];
    }
    
    return title;
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        self.lblAge.text = [self.ages objectAtIndex:row];
    }
    else if (pickerView.tag == 2)
    {
        self.lblSex.text = [self.sex objectAtIndex:row];
    }
}

@end

