//
//  ViewController.m
//  SampleApplicationBasic
//
//  Created by Zan Kavtaskin on 25/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize lblName;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnGenerateClick:(id)sender
{
    [[AnalyticsSingleton getInstance] logEventWithScreenName:@"Main" eventName:@"Generate"];
    
    NSArray *petNames = [[NSArray alloc] initWithObjects:@"Meow", @"Kitty", @"Sammy", @"Cat", @"Lucy", nil];
    
    self.lblName.text = [petNames objectAtIndex: arc4random() % [petNames count]];
}

@end
