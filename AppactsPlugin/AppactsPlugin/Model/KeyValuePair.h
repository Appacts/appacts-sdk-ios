//
//  KeyValuePair.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 20/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyValuePair : NSObject

{
    NSString *key;
    NSString *value;
}
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;

- (id)initWithKey: (NSString*)aKey value: (NSString *)aValue;

@end
