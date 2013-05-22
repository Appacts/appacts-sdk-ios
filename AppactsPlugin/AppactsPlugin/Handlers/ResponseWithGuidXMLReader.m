//
//  ResponseWithGuidXMLReader.m
//  AppactsPlugin
//
//  Created by Zan Kavtaskin on 15/07/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "ResponseWithGuidXMLReader.h"

@implementation ResponseWithGuidXMLReader

@synthesize webServiceResponseType, currentProperty, webServiceResponseGuid;

-(id)init {
    return self;
}

- (void)parseXMLData:(NSData *)data {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
	[parser setDelegate:self];
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if (qName) {
        elementName = qName;
    }
    if([elementName isEqualToString:@"ResponseCode"] 
           || [elementName isEqualToString:@"Object"]) {
            self.currentProperty = [[NSMutableString alloc] init];
    } 
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([elementName isEqualToString:@"ResponseCode"]) {
        self.WebServiceResponseType = self.currentProperty.intValue;
    } else if([elementName isEqualToString:@"Object"]) {
        self.webServiceResponseGuid = [Utils convertStringToUuid:self.currentProperty];
    }

	self.currentProperty = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.currentProperty && string && [string length] > 0) {
        [currentProperty appendString:string];
    }
}


@end
