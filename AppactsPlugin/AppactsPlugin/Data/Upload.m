//
//  Upload.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Upload.h"

@interface Upload()

{
    NSMutableData *receivedData;
    NSString *baseUrl;
}
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic) NSMutableData *receivedData;


- (int)webServiceCallWithBaseUrl: (NSString *)aBaseUrl serviceUrl: (NSString *)aServiceUrl keyValuePair: (NSMutableArray *)aKeyValuePair;
- (NSString *)addToUrl: (NSString *)aUrl key: (NSString *)aKey value: (NSString *)aValue;

@end

@implementation Upload

@synthesize receivedData;
@synthesize baseUrl;

- (id)initWithBaseUrl: (NSString *)aBaseUrl
{
    self.baseUrl = aBaseUrl;
    
    return self;
}

- (CFUUIDRef)deviceWithApplicationId: (CFUUIDRef)anApplicationId model: (NSString *)aModel osVersion: (NSString *)anOsVersion
                          deviceType: (int)aDeviceType carrier: (NSString *)aCarrier
                  applicationVersion: (NSString *)anApplicationVersion timeZoneOffset: (int)aTimeZoneOffset
                              locale:(NSString *) anLocale screenWidth:(int)anScreenWidth screenHeight:(int)anScreenHeight
                        manufacturer:(NSString *)anManufacturer responseCode:(int *)aResponseCode
{
    
    CFUUIDRef deviceId = NULL;
    
    @try {
        NSString *urlString = [self.baseUrl stringByAppendingString: device];
        urlString = [self addToUrl:urlString key:APPLICATION_GUID value:[Utils convertUuidToString:anApplicationId]];
        urlString = [self addToUrl:urlString key:MODEL value:aModel];
        urlString = [self addToUrl:urlString key:PLATFORM_TYPE value:[NSString stringWithFormat:@"%i", aDeviceType]];
        urlString = [self addToUrl:urlString key:CARRIER value:aCarrier];
        urlString = [self addToUrl:urlString key:OPERATING_SYSTEM value:anOsVersion];
        urlString = [self addToUrl:urlString key:VERSION value:anApplicationVersion];
        urlString = [self addToUrl:urlString key:TIME_ZONE_OFFSET value:[NSString stringWithFormat:@"%i", aTimeZoneOffset]];
        urlString = [self addToUrl:urlString key:LOCALE value:anLocale];
        urlString = [self addToUrl:urlString key:RESOLUTION_WIDTH value:[NSString stringWithFormat:@"%i", anScreenWidth]];
        urlString = [self addToUrl:urlString key:RESOLUTION_HEIGHT value:[NSString stringWithFormat:@"%i", anScreenHeight]];
        urlString = [self addToUrl:urlString key:MANUFACTURER value:anManufacturer];
        
#ifdef DEBUG
        NSLog(urlString, nil);
#endif
        
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSData *theData = [NSURLConnection sendSynchronousRequest:(theRequest) returningResponse:nil error:nil];
        
        ResponseWithGuidXMLReader *responseWithGuidXMLReader = [[ResponseWithGuidXMLReader alloc] init];
        [responseWithGuidXMLReader parseXMLData:theData];
        
        *aResponseCode = [responseWithGuidXMLReader webServiceResponseType];
        
        if(*aResponseCode == Ok) {
            deviceId = [responseWithGuidXMLReader webServiceResponseGuid];
        }
        
#ifdef DEBUG
        if(*aResponseCode == Ok) {
            NSLog(@"Device Uuid: %@", [Utils convertUuidToString:deviceId]);
        }
        
        NSLog(@"Device Response Code: %d", *aResponseCode);
#endif
        
    }
    @catch (NSException *exception) {
        @throw [[ExceptionWebServiceLayer alloc] initWithException:exception];
    }
    
    return deviceId;
}

- (int)crashWithDeviceId: (CFUUIDRef)aDeviceId crash: (Crash *)aCrash {
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DEVICE_GUID value:[Utils convertUuidToString:aDeviceId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:APPLICATION_GUID value:[Utils convertUuidToString:aCrash.applicationId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DATE_CREATED value:[Utils dateTimeFormat:aCrash.dateCreated]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SESSION_ID value:[Utils convertUuidToString:aCrash.sessionId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:VERSION value:aCrash.version]];
    
    return [self webServiceCallWithBaseUrl:self.baseUrl serviceUrl:crash keyValuePair:keyValuePairs];
}

- (int)errorWithDeviceId: (CFUUIDRef)aDeviceId errorItem: (ErrorItem *)anErrorItem {
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DEVICE_GUID value:[Utils convertUuidToString:aDeviceId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:APPLICATION_GUID value:[Utils convertUuidToString:anErrorItem.applicationId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DATE_CREATED value:[Utils dateTimeFormat:anErrorItem.dateCreated]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DATA value:anErrorItem.data]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:EVENT_NAME value:anErrorItem.eventName]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:AVAILABLE_FLASH_DRIVE_SIZE value:[NSString stringWithFormat:@"%lld", anErrorItem.deviceInformation.availableFlashDriveSize]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:AVAILABLE_MEMORY_SIZE value:[NSString stringWithFormat:@"%ld", anErrorItem.deviceInformation.availableMemorySize]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:BATTERY value:[NSString stringWithFormat:@"%d", anErrorItem.deviceInformation.battery]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:ERROR_MESSAGE value:anErrorItem.error.description]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SCREEN_NAME value:anErrorItem.screenName]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SESSION_ID value:[Utils convertUuidToString:anErrorItem.sessionId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:VERSION value:anErrorItem.version]];
    
    return [self webServiceCallWithBaseUrl:self.baseUrl serviceUrl:error keyValuePair:keyValuePairs];
}

- (int)eventWithDeviceId: (CFUUIDRef)aDeviceId eventItem: (EventItem *)anEventItem {
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DEVICE_GUID value:[Utils convertUuidToString:aDeviceId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:APPLICATION_GUID value:[Utils convertUuidToString:anEventItem.applicationId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DATE_CREATED value:[Utils dateTimeFormat: anEventItem.dateCreated]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DATA value:[Utils getValueNotNull:anEventItem.data]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:EVENT_TYPE value:[NSString stringWithFormat:@"%d", anEventItem.eventType]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:EVENT_NAME value:[Utils getValueNotNull: anEventItem.eventName]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:LENGTH value:[NSString stringWithFormat:@"%ld", anEventItem.length]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SCREEN_NAME value:[Utils getValueNotNull: anEventItem.screenName]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SESSION_ID value:[Utils convertUuidToString:anEventItem.sessionId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:VERSION value:anEventItem.version]];
    
    return [self webServiceCallWithBaseUrl:self.baseUrl serviceUrl:event keyValuePair:keyValuePairs];
}

- (int)feedbackWithDeviceId: (CFUUIDRef)aDeviceId feedbackItem: (FeedbackItem *)aFeedbackItem {
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DEVICE_GUID value:[Utils convertUuidToString:aDeviceId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:APPLICATION_GUID value:[Utils convertUuidToString:aFeedbackItem.applicationId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DATE_CREATED value:[Utils dateTimeFormat:aFeedbackItem.dateCreated]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:VERSION value:aFeedbackItem.version]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SCREEN_NAME value:aFeedbackItem.screenName]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:FEEDBACK value:aFeedbackItem.message]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:FEEDBACK_RATING_TYPE value:[NSString stringWithFormat:@"%d", aFeedbackItem.rating]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SESSION_ID value:[Utils convertUuidToString:aFeedbackItem.sessionId]]];
    
    return [self webServiceCallWithBaseUrl:self.baseUrl serviceUrl:feedback keyValuePair:keyValuePairs];
}

- (int)systemErrorWithDeviceId: (CFUUIDRef)aDeviceId systemError: (SystemError *)aSystemError {
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DEVICE_GUID value:[Utils convertUuidToString:aDeviceId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:APPLICATION_GUID value:[Utils convertUuidToString:aSystemError.applicationId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DATE_CREATED value:[Utils dateTimeFormat:aSystemError.dateCreated]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:VERSION value:aSystemError.version]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:ERROR_MESSAGE value:aSystemError.error.description]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:PLATFORM_TYPE value:[NSString stringWithFormat:@"%d", aSystemError.system.deviceType]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SYSTEM_VERSION value:aSystemError.version]];
    
    return [self webServiceCallWithBaseUrl:self.baseUrl serviceUrl:systemError keyValuePair:keyValuePairs];
}

- (int)userWithDeviceId: (CFUUIDRef)aDeviceId user: (User *)aUser {
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DEVICE_GUID value:[Utils convertUuidToString: aDeviceId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:APPLICATION_GUID value:[Utils convertUuidToString:aUser.applicationId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DATE_CREATED value:[Utils dateTimeFormat:aUser.dateCreated]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:VERSION value:aUser.version]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:AGE value:[NSString stringWithFormat:@"%d", aUser.age]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SEX_TYPE value:[NSString stringWithFormat:@"%d", aUser.sex]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:SESSION_ID value:[Utils convertUuidToString:aUser.sessionId]]];
    
    return [self webServiceCallWithBaseUrl:self.baseUrl serviceUrl:user keyValuePair:keyValuePairs];
}

- (int)locationWithDeviceId: (CFUUIDRef)aDeviceId applicationId: (CFUUIDRef)anApplicationId deviceLocation: (DeviceLocation *)aDeviceLocation {
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:LOCATION_LONGITUDE value:[NSString stringWithFormat:@"%f", aDeviceLocation.longitude]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:LOCATION_LATITUDE value:[NSString stringWithFormat:@"%f", aDeviceLocation.latitude]]];
    
    if(aDeviceLocation.countryName  != nil)
        [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:LOCATION_COUNTRY value:[NSString stringWithFormat:@"%@", aDeviceLocation.countryName]]];
    
    if(aDeviceLocation.countryCode != nil)
        [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:LOCATION_COUNTRY_CODE value:[NSString stringWithFormat:@"%@", aDeviceLocation.countryCode]]];
    
    if(aDeviceLocation.countryAdminName != nil)
        [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:LOCATION_ADMIN value:[NSString stringWithFormat:@"%@", aDeviceLocation.countryAdminName]]];
    
    if(aDeviceLocation.countryAdminCode != nil)
        [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:LOCATION_ADMIN_CODE value:[NSString stringWithFormat:@"%@", aDeviceLocation.countryAdminCode]]];
    
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DEVICE_GUID value:[Utils convertUuidToString:aDeviceId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:APPLICATION_GUID value:[Utils convertUuidToString:anApplicationId]]];
    
    return [self webServiceCallWithBaseUrl:self.baseUrl serviceUrl:location keyValuePair:keyValuePairs];
}

- (int)upgrade: (CFUUIDRef)aDeviceId applicationId: (CFUUIDRef)anApplicationId version: (NSString *)aVersion {
    NSMutableArray *keyValuePairs = [[NSMutableArray alloc] init];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:DEVICE_GUID value:[Utils convertUuidToString:aDeviceId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:APPLICATION_GUID value:[Utils convertUuidToString:anApplicationId]]];
    [keyValuePairs addObject:[[KeyValuePair alloc] initWithKey:VERSION value:aVersion]];
    
    return [self webServiceCallWithBaseUrl:self.baseUrl serviceUrl:upgrade keyValuePair:keyValuePairs];
}

- (int)webServiceCallWithBaseUrl: (NSString *)aBaseUrl serviceUrl: (NSString *)aServiceUrl keyValuePair: (NSMutableArray *)akeyValuePairs {
    int responseCode = GeneralError;
    
    @try {
        NSString *urlString = [aBaseUrl stringByAppendingString: aServiceUrl];
        
        for(int i = 0; i < akeyValuePairs.count; i++) {
            
            @autoreleasepool {
                
                KeyValuePair *keyValuePairs = [akeyValuePairs objectAtIndex:i];
                
                urlString = [self addToUrl:urlString key:keyValuePairs.key value:keyValuePairs.value];
                
            }
        }
        
#ifdef DEBUG
        NSLog(@"Request: %@", urlString);
#endif
    
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        NSData *theData = [NSURLConnection sendSynchronousRequest:(theRequest) returningResponse:nil error:nil];
        
        ResponseXMLReader *responseXmlReader = [[ResponseXMLReader alloc] init];
        [responseXmlReader parseXMLData:theData];
        
        responseCode = [responseXmlReader webServiceResponseType];
#ifdef DEBUG
        NSLog(@"Response Code: %d", responseCode);
#endif
        
    }
    @catch (NSException *exception) {
        @throw [[ExceptionWebServiceLayer alloc] initWithException:exception];
    }
    
    return responseCode;
}

- (NSString *)addToUrl: (NSString *)aUrl key: (NSString *)aKey value: (NSString *)aValue {
    if ([aUrl rangeOfString:@"?"].location != NSNotFound) {
        return [NSString stringWithFormat:@"%@&%@=%@",aUrl, aKey, [[Utils getValueNotNull:aValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return [NSString stringWithFormat:@"%@?%@=%@",aUrl, aKey, [[Utils getValueNotNull:aValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
