//
//  KeyValuePair.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "KeyValuePair.h"

@implementation KeyValuePair

@synthesize key;
@synthesize value;

- (id)initWithKey: (NSString*)aKey value: (NSString *)aValue
{
    self.key = aKey;
    self.value = aValue;
    
    return self;
}

@end
