//
//  CatViewController.h
//  SampleApplication
//
//  Created by Jamie Wheeldon on 21/06/2012.
//  Modified By Zan Kavtaskin on 26/12/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//  Problems? Suggestions? Let us now http://support.appacts.com

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CatViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *lblCatName;

@end
