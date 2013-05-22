//
//  ApplicationState.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 17/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationState : NSObject

{
    int state;
    NSDate *dateCreated;
}
@property (nonatomic) int state;
@property (nonatomic, strong) NSDate *dateCreated;

- (id)initWithState: (int)aState dateCreated: (NSDate *)aDateCreated;

@end
