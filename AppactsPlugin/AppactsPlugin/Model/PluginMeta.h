//
//  PluginMeta.h
//  SampleApplication
//
//  Created by Jamie Wheeldon on 16/09/2012.
//
//

#import <Foundation/Foundation.h>

@interface PluginMeta : NSObject

{
    int schemaVersionNumeric;
}
@property (nonatomic) int schemaVersionNumeric;

- (id)initWithSchemaVersionNumeric: (int)schemaVersionNumeric;

@end
