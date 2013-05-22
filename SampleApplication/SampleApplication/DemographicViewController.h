//
//  DemographicViewController.h
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DemographicViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *lblAge;
@property (strong, nonatomic) IBOutlet UILabel *lblSex;
@property (strong, nonatomic) IBOutlet UIPickerView *pvAge;
@property (strong, nonatomic) IBOutlet UIPickerView *pvSex;
@property (strong, nonatomic) NSArray *ages;
@property (strong, nonatomic) NSArray *sex;

- (IBAction)backgroundTouched:(id)sender;

@end
