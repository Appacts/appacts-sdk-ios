//
//  ResponseWithGuidXMLReader.h
//  AppactsPlugin
//
//  Created by Zan Kavtaskin on 15/07/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceResponseType.h"
#import "Utils.h";

@interface ResponseWithGuidXMLReader : NSObject {
    CFUUIDRef webServiceResponseGuid;
    int webServiceResponseType;
    NSMutableString *currentProperty;
}

@property CFUUIDRef webServiceResponseGuid;
@property int webServiceResponseType;
@property (strong, nonatomic) NSMutableString *currentProperty;

- (void)parseXMLData:(NSData *)data;

@end
