//
//  FeedbackViewController.h
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UIPickerView *pvRating;
@property (strong, nonatomic) NSArray *ratings;
@property (strong, nonatomic) IBOutlet UITextView *txtComment;

- (IBAction)backgroundTouched:(id)sender;

@end
