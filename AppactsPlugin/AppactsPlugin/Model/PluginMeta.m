//
//  PluginMeta.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 16/09/2012.
//
//

#import "PluginMeta.h"

@implementation PluginMeta

@synthesize schemaVersionNumeric;

- (id)initWithSchemaVersionNumeric: (int)aSchemaVersionNumeric {
    self.schemaVersionNumeric = aSchemaVersionNumeric;
    
    return self;
}

@end
