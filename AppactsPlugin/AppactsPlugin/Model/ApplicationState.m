//
//  ApplicationState.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 17/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "ApplicationState.h"

@implementation ApplicationState

@synthesize state;
@synthesize dateCreated;

- (id)initWithState: (int)aState dateCreated: (NSDate *)aDateCreated;
{
    self.state = aState;
    self.dateCreated = aDateCreated;
    
    return self;
}

@end
