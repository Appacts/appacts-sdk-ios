//
//  Session.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Session.h"

@implementation Session

@synthesize dateStart;
@synthesize name;

- (id)init
{
    self = [super init];

    if(self) {
        self.dateStart = [[NSDate alloc] initWithTimeIntervalSinceNow:0];;
    }
    
    return self;
}

- (id)initWithScreenName: (NSString *)aScreenName
{
    self = [super init];
    
    if(self) {
        
        self.name = aScreenName;
        self.dateStart = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    }
    
    return self;
}

- (long)end
{
    return ([[NSDate alloc] initWithTimeIntervalSinceNow:0].timeIntervalSince1970 - self.dateStart.timeIntervalSince1970) * 1000;
}

- (bool)equalsWithObject: (NSObject *)anObject
{
    if (self.class == anObject.class) {
        return [((Session *)anObject).name isEqualToString:self.name];
    }
    
    return false;
}

@end
