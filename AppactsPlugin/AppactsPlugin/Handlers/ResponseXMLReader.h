//
//  ResponseXMLReader.h
//  AppactsPlugin
//
//  Created by Zan Kavtaskin on 08/07/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebServiceResponseType.h"


@interface ResponseXMLReader : NSObject {
    int webServiceResponseType;
    NSMutableString *currentProperty;
}

@property int webServiceResponseType;
@property (retain) NSMutableString *currentProperty;

- (void)parseXMLData:(NSData *)data;

@end
