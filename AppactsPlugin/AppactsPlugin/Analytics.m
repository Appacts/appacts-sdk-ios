//
//  Analytics.m
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import "Analytics.h"

#import "Data.h"
#import "DeviceDynamicInfo.h"
#import "DeviceInformation.h"
#import "ExceptionDatabaseLayer.h"
#import "ExceptionWebServiceLayer.h"
#import "EventType.h"
#import "HttpConnectionManager.h"
#import "Logger.h"
#import "Platform.h"
#import "Session.h"
#import "Settings.h"
#import "StatusType.h"
#import "Upload.h"
#import "Utils.h"
#import "WebServiceResponseType.h"

@interface Analytics()

{
    CFUUIDRef applicationId;
    NSString *applicationVersion;
    NSString *baseUrl;
    CFUUIDRef sessionId;

    Logger *logger;
    Settings *settings;
    Data *data;
    Upload *upload;

    DeviceInformation *deviceInformation;
    DeviceDynamicInformation *deviceDynamicInformation;
    Platform *platform;

    NSMutableArray *vectorScreenOpen;
    NSMutableArray *vectoreContentLoading;

    bool authenticationFailure;
    bool databaseExists;
    bool itemsWaitingToBeUploaded;
    int numberOfItemsWaitingToBeUploaded;
    int optStatusType;
    bool uploadWhileUsing;
    
    Boolean userProcessed;
    Boolean deviceLocationProcessed;
    Boolean upgradedProcessed;

    NSThread *threadUpload;
    NSObject *threadUploadLock;
    NSCondition *threadIsUploadingLock;
    bool threadIsUploading;
    Session *session;
    bool threadUploadInterrupted;
    bool started;
    bool stopped;
    
    NSNotificationCenter *notificatonReachability;
    Reachability *reachability;
}

@property (nonatomic) CFUUIDRef applicationId;
@property (nonatomic, strong) NSString *applicationVersion;
@property (nonatomic) CFUUIDRef sessionId;
@property (nonatomic, strong) NSString *baseUrl;

@property (nonatomic, strong) Logger *logger;
@property (nonatomic, strong) Settings *settings;
@property (nonatomic, strong) Data *data;
@property (nonatomic, strong) Upload *upload;

@property (nonatomic, strong) DeviceInformation *deviceInformation;
@property (nonatomic, strong) DeviceDynamicInfo *deviceDynamicInfo;
@property (nonatomic, strong) Platform *platform;

@property (nonatomic) NSMutableArray *vectorScreenOpen;
@property (nonatomic) NSMutableArray *vectoreContentLoading;

@property (nonatomic) bool authenticationFailure;
@property (nonatomic) bool databaseExists;
@property (nonatomic) bool itemsWaitingToBeUploaded;
@property (nonatomic) int numberOfItemsWaitingToBeUploaded;
@property (nonatomic) int optStatusType;
@property (nonatomic) bool uploadWhileUsing;

@property (nonatomic) Boolean userProcessed;
@property (nonatomic) Boolean deviceLocationProcessed;
@property (nonatomic) Boolean upgradedProcessed;

@property (nonatomic, strong) NSThread *threadUpload;
@property (nonatomic, strong) NSCondition *threadIsUploadingLock;
@property (nonatomic) bool threadIsUploading;
@property (nonatomic, strong) Session *session;
@property (nonatomic) bool threadUploadInterrupted;
@property (nonatomic) bool started;
@property (nonatomic) bool stopped;

@property (nonatomic) NSNotificationCenter *notificatonReachability;
@property (nonatomic) Reachability *reachability;

- (void)setupDatabase;
- (void)logSystemErrorWithExceptionDescriptive: (ExceptionDescriptive *)anExceptionDescriptive;
- (void)setItemsWaitingToBeUploaded;
- (void)uploadIntelligent;
- (void)uploadAll;
- (void)uploadSuccesfullyCompletedWithNumberOfItemsWaitingToBeUploadedBefore: (int)numberOfItemsWaitingToBeUploadedBefore;
- (void)uploadSystemErrorWithDeviceId: (CFUUIDRef)aDeviceId;
- (void)uploadCrashWithDeviceId: (CFUUIDRef)aDeviceId;
- (Boolean)uploadUserWithDeviceId: (CFUUIDRef)aDeviceId;
- (void)uploadErrorWithDeviceId: (CFUUIDRef)aDeviceId;
- (void)uploadEventWithDeviceId: (CFUUIDRef)aDeviceId;
- (void)uploadFeedbackWithDeviceId: (CFUUIDRef)aDeviceId;
- (Boolean)uploadDeviceLocationWithDeviceId: (CFUUIDRef)aDeviceId;
- (Boolean)uploadUpgradedWithDeviceId: (CFUUIDRef)aDeviceId;

@end

@implementation Analytics

NSString * const connectionString = @"/appacts.db";
const int databaseVersion = 1;

@synthesize applicationId;
@synthesize applicationVersion;
@synthesize baseUrl;
@synthesize sessionId;

@synthesize logger;
@synthesize settings;
@synthesize data;
@synthesize upload;

@synthesize deviceInformation;
@synthesize deviceDynamicInfo;
@synthesize platform;

@synthesize vectorScreenOpen;
@synthesize vectoreContentLoading;

@synthesize authenticationFailure;
@synthesize databaseExists;
@synthesize itemsWaitingToBeUploaded;
@synthesize numberOfItemsWaitingToBeUploaded;
@synthesize optStatusType;
@synthesize uploadWhileUsing;

@synthesize userProcessed;
@synthesize deviceLocationProcessed;
@synthesize upgradedProcessed;

@synthesize threadUpload;
@synthesize threadIsUploadingLock;
@synthesize threadIsUploading;
@synthesize session;
@synthesize threadUploadInterrupted;
@synthesize started;
@synthesize stopped;

@synthesize notificatonReachability;
@synthesize reachability;

-(id)init {
    return [super init];
}

- (void)startWithApplicationId:(NSString *)anApplicationId
uploadType:(UploadType)anUploadType baseUrl:(NSString *)anBaseUrl {

    if(!self.started) {
        
        if(anBaseUrl == nil || anBaseUrl.length == 0)
        {
            @throw [[NSException alloc] initWithName:@"baseUrl" reason:@"You need to specify baseUrl, i.e. your server api url http://yoursite.com/api/" userInfo:nil];
        }
        self.baseUrl = anBaseUrl;
        
        self.applicationId = [Utils convertStringToUuid:anApplicationId];
        
        
        @try {
            self.applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        }
        @catch (NSException *exception) {
            self.applicationVersion = @"0";
        }
        [self setup];
        
        self.threadUploadInterrupted = false;
        self.started = true;
        self.stopped = false;
        
        if(anUploadType == WhileUsingAsync) {
            [self uploadWhileUsingAsync];
        }
    }
    
}

- (void)startWithApplicationId:(NSString *)anApplicationId baseUrl:(NSString *)anBaseUrl {
    [self startWithApplicationId:anApplicationId uploadType: WhileUsingAsync baseUrl: anBaseUrl];
}

- (void)setup {
    
    self.authenticationFailure = false;
    self.databaseExists = false;
    self.itemsWaitingToBeUploaded = true;
    self.numberOfItemsWaitingToBeUploaded = 0;
    self.optStatusType = OptIn;
    self.uploadWhileUsing = false;
    
    self.userProcessed = false;
    self.deviceLocationProcessed = false;
    self.upgradedProcessed = false;
    
    [self setTheThreadIsUploading:false];
    
    self.sessionId = CFUUIDCreate(kCFAllocatorDefault);
    
    self.data = [[Data alloc] initWithConnectionString:connectionString];
    self.upload = [[Upload alloc] initWithBaseUrl:baseUrl];
    
    self.deviceInformation = [[DeviceInformation alloc] init];
    self.deviceDynamicInfo = [[DeviceDynamicInfo alloc] init];
    self.platform = [[Platform alloc] init];
    
    self.vectorScreenOpen = [[NSMutableArray alloc] init];
    self.vectoreContentLoading = [[NSMutableArray alloc] init];
    
    @try {
        [self setupDatabase];
        self.databaseExists = true;
    }
    @catch (ExceptionDatabaseLayer *ex) {
        NSLog(@"setup");
        NSLog(@"%@", ex.name);
    }

    if (self.databaseExists) {
        ApplicationMeta *applicationMeta = nil;
        Boolean applicationInitialSetup = false;
        
        @try {
            applicationMeta = [self.settings loadApplicationByApplicationId:self.applicationId];
            
            if(applicationMeta == nil) {
                applicationMeta = [[ApplicationMeta alloc] initWithApplicationId:self.applicationId applicationStateType:Closed dateCreated:[Utils getDateTimeNow] optStatus:OptIn];
                
                [self.settings saveApplicationMeta:applicationMeta];
                applicationInitialSetup = true;
            }
            
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
        
        self.optStatusType = applicationMeta.optStatus;
        
        @try {
            if(applicationMeta.state == Open) {
                Crash *crash = [[Crash alloc] initWithapplicationId:self.applicationId sessionId:applicationMeta.sessionId version:self.applicationVersion];
                
                [self.logger saveCrash:crash];
            }
            
            EventItem *eventItem = [[EventItem alloc] initWithApplicationId:self.applicationId screenName:NULL data:NULL eventType:ApplicationOpen eventName:NULL length:0 sessionId:self.sessionId version:self.applicationVersion];
            
            [self.logger saveEventItem:eventItem];
            
            applicationMeta.sessionId = self.sessionId;
            applicationMeta.state = Open;
            
            if(applicationMeta.version == NULL || ![self.applicationVersion isEqualToString:applicationMeta.version]) {
                applicationMeta.version = self.applicationVersion;
                applicationMeta.upgraded = !applicationInitialSetup;
            }
            
            [self.settings updateApplication:applicationMeta];
            
#ifdef DEBUG
            @throw [[ExceptionDatabaseLayer alloc] initWithMessage:@"Error testing"];
#endif
            
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
    }
    
    self.session = [[Session alloc] init];
}

- (void)setupDatabase {
    if (![self.data exists]) {
        [self.data create];
        [self.data setup];
    }
    
    self.logger = [[Logger alloc] initWithDatabaseReadWrite:[self.data openReadWriteConnection] databaseReadOnly:[self.data openReadOnlyConnection] databaseLock:[self.data getDatabaseLock]];
    self.settings = [[Settings alloc] initWithDatabaseReadWrite:[self.data openReadWriteConnection] databaseReadOnly:[self.data openReadOnlyConnection] databaseLock:[self.data getDatabaseLock]];
    
    PluginMeta *pluginMeta = NULL;
    
    @try {
        pluginMeta = [self.settings loadPluginMeta];
    }
    @catch(ExceptionDatabaseLayer *exceptionDatabaseLayer) {
        [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
    }
    
    if(pluginMeta == NULL) {
        pluginMeta = [[PluginMeta alloc] initWithSchemaVersionNumeric:-1];
    }
    
    int schemaVersionNumericOld = [self.deviceInformation getPluginVersionCode];
    
    if([self.data upgradeSchemaWithCurrentPluginVersion:[self.deviceInformation getPluginVersionCode] oldSchemaVersion:pluginMeta.schemaVersionNumeric]) {
        if(pluginMeta.schemaVersionNumeric == -1) {
            pluginMeta.schemaVersionNumeric = schemaVersionNumericOld;
            [self.settings savePluginMeta: pluginMeta];
        }
        else {
            pluginMeta.SchemaVersionNumeric = schemaVersionNumericOld;
            [self.settings updatePluginMeta: pluginMeta];
        }
    }
}

- (void)logErrorWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName data: (NSString*)aData exception: (NSException *)anException {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            ErrorItem *errorItem = [[ErrorItem alloc] initWithapplicationId:self.applicationId screenName:aScreenName data:aData deviceGeneralInformation:[self.deviceDynamicInfo getDeviceGeneralInformation] eventName:anEventName exception:anException sessionId:self.sessionId version:self.applicationVersion];
            
            [self.logger saveErrorItem:errorItem];
            
            [self setItemsWaitingToBeUploaded];
            
            if ([self itemsWaitingToBeUploaded]) {
                [self uploadIntelligent];
            }
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
    }
}

- (void)logEventWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName data: (NSString*)aData {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            EventItem *eventItem = [[EventItem alloc] initWithApplicationId:self.applicationId screenName:aScreenName data:aData eventType:Event eventName:anEventName length:0 sessionId:self.sessionId version:self.applicationVersion];
            
            [self.logger saveEventItem:eventItem];
            
            [self setItemsWaitingToBeUploaded];
            
            if ([self itemsWaitingToBeUploaded]) {
                [self uploadIntelligent];
            }
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
    }
}

- (void)logEventWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName {
    [self logEventWithScreenName:aScreenName eventName:anEventName data:NULL];
}

- (void)logFeedbackWithScreenName: (NSString *)aScreenName rating: (RatingType)aRating comment: (NSString *)aComment {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            FeedbackItem *feedbackItem = [[FeedbackItem alloc] initWithApplicationId:self.applicationId screenName:aScreenName message:aComment ratingType:aRating sessionId:self.sessionId version:self.applicationVersion];
            
            [self.logger saveFeedbackItem:feedbackItem];
            
            [self setItemsWaitingToBeUploaded];
            
            if ([self itemsWaitingToBeUploaded]) {
                [self uploadIntelligent];
            }
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
            @throw exceptionDatabaseLayer;
        }
    } else {
        @throw [[NSException alloc] initWithName:@"LogFeedback" reason:@"You can't save feedback when there is no database, analytics was not started or user is not opt in for analytics" userInfo:nil];
    }
}

- (void)screenOpenWithScreenName: (NSString *)aScreenName {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            Session *aSession = [[Session alloc] initWithScreenName:aScreenName];
            
            @synchronized(self.vectorScreenOpen) {
                if(![self.vectorScreenOpen containsObject:aSession]) {
                    [self.vectorScreenOpen addObject:aSession];
                    
                    EventItem *eventItem = [[EventItem alloc] initWithApplicationId:self.applicationId screenName:aScreenName data:nil eventType:ScreenOpen eventName:nil length:0 sessionId:self.sessionId version:self.applicationVersion];
                    
                    [self.logger saveEventItem:eventItem];
                    
                    [self setItemsWaitingToBeUploaded];
                    
                    if ([self itemsWaitingToBeUploaded]) {
                        [self uploadIntelligent];
                    }
                }
            }
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
    }
}

- (void)screenClosedWithScreenName: (NSString *)aScreenName {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            long miliSeconds = 0;
            int index = -1;
            
            @synchronized(self.vectorScreenOpen) {
                for (int i = 0; i < self.vectorScreenOpen.count; i++) {
                    Session *aSession = [self.vectorScreenOpen objectAtIndex:(i)];

                    if ([aSession.name isEqualToString:aScreenName]) {
                        index = i;
                        miliSeconds = [aSession end];
                        break;
                    }
                }
                
                if(index != -1) {
                    [self.vectorScreenOpen removeObjectAtIndex:index];
                    
                    EventItem *eventItem = [[EventItem alloc] initWithApplicationId:self.applicationId screenName:aScreenName data:nil eventType:ScreenClosed eventName:nil length:miliSeconds sessionId:sessionId version:self.applicationVersion];
                    
                    [self.logger saveEventItem:eventItem];
                    
                    [self setItemsWaitingToBeUploaded];
                    
                    if ([self itemsWaitingToBeUploaded]) {
                        [self uploadIntelligent];
                    }
                    
                }
            }
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
    }
}

- (void)contentLoadingWithScreenName: (NSString *)aScreenName contentName: (NSString *)aContentName {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            Session *aSession = [[Session alloc] initWithScreenName:aScreenName];
            
            @synchronized(self.vectoreContentLoading) {
                if(![self.vectoreContentLoading containsObject:aSession]) {
                    [self.vectoreContentLoading addObject:aSession];
                    
                    EventItem *eventItem = [[EventItem alloc] initWithApplicationId:self.applicationId screenName:aScreenName data:nil eventType:ContentLoading eventName:aContentName length:0 sessionId:self.sessionId version:self.applicationVersion];
                    
                    [self.logger saveEventItem:eventItem];
                    
                    [self setItemsWaitingToBeUploaded];
                    
                    if ([self itemsWaitingToBeUploaded]) {
                        [self uploadIntelligent];
                    }
                }
            }
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
    }
}

- (void)contentLoadedWithScreenName:(NSString *)aScreenName contentName: (NSString *)aContentName {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            long miliSeconds = 0;
            int index = -1;
            
            @synchronized(self.vectoreContentLoading) {
                for (int i = 0; i < self.vectoreContentLoading.count; i++) {
                    Session *aSession = [self.vectoreContentLoading objectAtIndex:(i)];
                    
                    if ([aSession.name isEqualToString:aScreenName]) {
                        index = i;
                        miliSeconds = [aSession end];
                        
                        break;
                    }
                }
                
                if(index != -1) {
                    [self.vectoreContentLoading removeObjectAtIndex:index];
                    
                    EventItem *eventItem = [[EventItem alloc] initWithApplicationId:self.applicationId screenName:aScreenName data:nil eventType:ContentLoaded eventName:aContentName length:miliSeconds sessionId:self.sessionId version:self.applicationVersion];
                    
                    [self.logger saveEventItem:eventItem];
                    
                    [self setItemsWaitingToBeUploaded];
                    
                    if ([self itemsWaitingToBeUploaded]) {
                        [self uploadIntelligent];
                    }
                    
                }
            }
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
    }}

- (void)setUserInformationWithAge: (int)anAge sexType: (SexType)aSexType {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            User *user = [[User alloc] initWithAge:anAge sexType:aSexType statusType:Pending applicationId:self.applicationId sessionId:self.sessionId version:self.applicationVersion];
            
            [self.settings saveUser:user];
            
            [self setItemsWaitingToBeUploaded];
            
            if ([self itemsWaitingToBeUploaded]) {
                [self uploadIntelligent];
            }
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
            @throw exceptionDatabaseLayer;
        }
    } else {
        @throw [[NSException alloc] initWithName:@"setUserInformationWithAge" reason:@"You can't save user info when there is no database, analytics was not started or user is not opt in for analytics" userInfo:nil];
    }
}

- (Boolean)isUserInformationSet {
    bool isUserInformationSet = true;
    
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
        @try {
            isUserInformationSet = [self.settings getUserByApplicationId:self.applicationId statusType:All] != NULL;
        }
        @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
            [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
        }
    }
    
    return isUserInformationSet;
}

- (void)setOptStatus: (OptStatusType)anOptStatusType {
    @try {
        self.optStatusType = anOptStatusType;
        
        if (self.databaseExists) {
            ApplicationMeta *applicationMeta = [self.settings loadApplicationByApplicationId:self.applicationId];
            applicationMeta.OptStatus = anOptStatusType;
            [self.settings updateApplication:applicationMeta];
        }
    }
    @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
        [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
    }
}

- (OptStatusType)getOptStatus {
    OptStatusType anOptStatusType = None;
    
    @try {        
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
            ApplicationMeta *applicationMeta = [self.settings loadApplicationByApplicationId:self.applicationId];
            anOptStatusType = applicationMeta.optStatus;
        }
    }
    @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
        [self logSystemErrorWithExceptionDescriptive:exceptionDatabaseLayer];
    }
    
    return anOptStatusType;
}

- (void)uploadWhileUsingAsync {
    if (!self.uploadWhileUsing) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged) name:kReachabilityChangedNotification object:nil];
        
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];
        
        self.uploadWhileUsing = true;
    }
    
    [self uploadIntelligent];
}

- (void)reachabilityChanged:(NSNotification *) notice {
    NetworkStatus networkStatus = [self.reachability currentReachabilityStatus];
    
    if(networkStatus != NotReachable) {
        [self uploadIntelligent];
    }
}

- (void)stop {
    
    if(self.started)
    {
        @try {
            threadUploadInterrupted = true;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
            
            [reachability stopNotifier];
            
            if ([self getTheThreadIsUploading]) {
                [self.threadUpload cancel];
            }
        }
        @catch (NSException *ex) {
#ifdef DEBUG
            NSLog(@"%@%@", @"stop", ex.name);
#endif
        }
        
        if([self databaseExists]) {
            @try {
                EventItem *eventItem = [[EventItem alloc] initWithApplicationId:self.applicationId screenName:NULL data:NULL eventType:ApplicationClose eventName:NULL length:[self.session end] sessionId:sessionId version:self.applicationVersion];
                
                [self.logger saveEventItem:eventItem];
                
                ApplicationMeta *applicationState = [self.settings loadApplicationByApplicationId:self.applicationId];
                applicationState.state = Closed;
                
#ifdef DEBUG
                applicationState.state = Open;
#endif
                
                applicationState.sessionId = self.sessionId;
                [self.settings updateApplication:applicationState];
            }
            @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
                [self logSystemErrorWithExceptionDescriptive: exceptionDatabaseLayer];
            }
            
            @try {
                [self.threadIsUploadingLock lock];
                
                if([self getTheThreadIsUploading]) {
                    while([self getTheThreadIsUploading]) {
                        [self.threadIsUploadingLock wait];
                    }
                }
                
                [self.threadIsUploadingLock unlock];
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"%@%@", @"stop", ex.name);
#endif
            }
            @finally {
                [self.data dispose];
            }
            
            self.stopped = true;
            self.started = false;
#ifdef DEBUG
            NSLog(@"analytics disposed finish");
#endif
        }
    }
}

- (void)logSystemErrorWithExceptionDescriptive: (ExceptionDescriptive *)anExceptionDescriptive {
    @try {
    if (self.databaseExists && self.started && self.optStatusType == OptIn) {
            
#ifdef DEBUG
                NSLog(@"errorIdentified");
                NSLog(@"reason:  %@", anExceptionDescriptive.reason);
                NSLog(@"stack trace:  %@", anExceptionDescriptive.stackTrace);
                NSLog(@"source: %@", anExceptionDescriptive.source);
#endif
            
            [self.logger saveSystemError:[[SystemError alloc] initWithApplicationId:self.applicationId exceptionDescriptive:anExceptionDescriptive analyticsSystem:[[AnalyticsSystem alloc] initWithDeviceType:[deviceInformation getDeviceType] version:[deviceInformation getPluginVersion]] version:self.applicationVersion]];
            
            [self setItemsWaitingToBeUploaded];
        }
    }
    @catch (ExceptionDatabaseLayer *exceptionDatabaseLayer) {
        
#ifdef DEBUG
        NSLog(@"errorIdentified while saving error");
        NSLog(@"reason: %@", exceptionDatabaseLayer.reason);
        NSLog(@"stackTrace: %@", exceptionDatabaseLayer.stackTrace);
        NSLog(@"source: %@", exceptionDatabaseLayer.source);
#endif
        
    }
}

- (void)setItemsWaitingToBeUploaded {
    self.numberOfItemsWaitingToBeUploaded = self.numberOfItemsWaitingToBeUploaded + 1;
    self.itemsWaitingToBeUploaded = true;
}

- (void)uploadManual {
    
    if (self.itemsWaitingToBeUploaded &&
        [HttpConnectionManager hasNetworkCoverage] &&
        !self.authenticationFailure &&
        self.optStatusType == OptIn &&
        !self.stopped &&
        self.databaseExists &&
        !self.getTheThreadIsUploading) {
        
        [self.threadIsUploadingLock lock];
        
        if(![self getTheThreadIsUploading]) {
            self.threadUpload = [[NSThread alloc] initWithTarget:self selector:@selector(uploadAll:) object:nil];
            [self.threadUpload setThreadPriority:0.2];
            [self.threadUpload start];
        }
        
        [self.threadIsUploadingLock unlock];
        
    }
}

- (void)uploadIntelligent {
    
    if (self.itemsWaitingToBeUploaded &&
        [HttpConnectionManager hasNetworkCoverage] &&
        !self.authenticationFailure &&
        self.optStatusType == OptIn &&
        !self.stopped &&
        self.databaseExists) {
        
#ifdef DEBUG   
        NSLog(@"Upload thread is active:");
        NSLog(self.getTheThreadIsUploading ? @"True" : @"False");
#endif
        
        [self.threadIsUploadingLock lock];
        
        if (![self getTheThreadIsUploading]) {
            [self setTheThreadIsUploading:true];
            
            self.threadUpload = [[NSThread alloc] initWithTarget:self selector:@selector(uploadAll) object:nil];
            [self.threadUpload setThreadPriority:0.2];
            [self.threadUpload start];
        }
        
        [self.threadIsUploadingLock unlock];
        
    }
    
}

- (void)uploadAll {
    
    @autoreleasepool {
        
#ifdef DEBUG
        NSLog(@"uploadAll Started");
#endif
        
        CFUUIDRef deviceId = NULL;
        Boolean exceptionWasRaised = false;
        
        if (!self.threadUploadInterrupted) {
            @try {
                int responseCode;
                deviceId = [self.settings getDeviceId];
                
                if (deviceId == NULL) {
                    deviceId = [self.upload deviceWithApplicationId:self.applicationId model:[deviceInformation getModel] osVersion:[self.platform getOS] deviceType:iOS carrier:[self.platform getCarrier] applicationVersion:self.applicationVersion timeZoneOffset:[Utils getTimeOffSet] responseCode:&responseCode];
                    
                    if(responseCode == Ok) {
                        [self.settings saveDeviceId:deviceId dateCreated:[Utils getDateTimeNow]];
                    } else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
                        self.authenticationFailure = true;
                        exceptionWasRaised = true;
                    }
                    else if (responseCode == GeneralError) {
                        exceptionWasRaised = true;
                    }
                }
                else {
                    if(!self.upgradedProcessed) {
                        self.upgradedProcessed = [self uploadUpgradedWithDeviceId: deviceId];
                    }
                }
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"device setup error: %@", [ex name]);
#endif
                exceptionWasRaised = true;
            }
        }
        
        int numberOfItemsWaitingToBeUploadedBefore = self.numberOfItemsWaitingToBeUploaded;
        
        if(!self.threadUploadInterrupted && !exceptionWasRaised) {
            @try {
                [self uploadSystemErrorWithDeviceId:deviceId];
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"upload System error: %@", [ex name]);
#endif
                exceptionWasRaised = true;
            }
        }
        
        if(!self.threadUploadInterrupted && !exceptionWasRaised) {
            @try {
                [self uploadCrashWithDeviceId:deviceId];
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"upload Crash error: %@", [ex name]);
#endif
                exceptionWasRaised = true;
            }
        }
        
        if(!self.threadUploadInterrupted && !exceptionWasRaised && !self.userProcessed) {
            @try {
                self.userProcessed = [self uploadUserWithDeviceId:deviceId];
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"upload user error: %@", [ex name]);
#endif
                exceptionWasRaised = true;
            }
        }
        
        if(!self.threadUploadInterrupted && !exceptionWasRaised) {
            @try {
                [self uploadErrorWithDeviceId:deviceId];
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"upload error error: %@", [ex name]);
#endif
                exceptionWasRaised = true;
            }
        }
        
        if(!self.threadUploadInterrupted && !exceptionWasRaised) {
            @try {
                [self uploadEventWithDeviceId:deviceId];
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"upload event error: %@", [ex name]);
#endif
                exceptionWasRaised = true;
            }
        }
        
        if(!self.threadUploadInterrupted && !exceptionWasRaised) {
            @try {
                [self uploadFeedbackWithDeviceId:deviceId];
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"upload feedback error: %@", [ex name]);
#endif
                exceptionWasRaised = true;
            }
        }
        
        if(!self.threadUploadInterrupted && !exceptionWasRaised && !deviceLocationProcessed) {
            @try {
                self.deviceLocationProcessed = [self uploadDeviceLocationWithDeviceId:deviceId];
            }
            @catch (NSException *ex) {
#ifdef DEBUG
                NSLog(@"upload device location error: %@", [ex name]);
#endif
                exceptionWasRaised = true;
            }
        }
        
        if (!exceptionWasRaised) {
            [self uploadSuccesfullyCompletedWithNumberOfItemsWaitingToBeUploadedBefore:numberOfItemsWaitingToBeUploadedBefore];
        }
        
        [self setTheThreadIsUploading:false];
        
#ifdef DEBUG
        NSLog(@"uploadAll Completed");
#endif
        
    }
    
}

- (void) uploadSuccesfullyCompletedWithNumberOfItemsWaitingToBeUploadedBefore: (int)numberOfItemsWaitingToBeUploadedBefore
{
    if (!self.threadUploadInterrupted) {
        if(numberOfItemsWaitingToBeUploadedBefore == self.numberOfItemsWaitingToBeUploaded) {
            itemsWaitingToBeUploaded = false;
        }
    }
}

- (void)uploadSystemErrorWithDeviceId: (CFUUIDRef)aDeviceId {
    SystemError *systemError = NULL;
    
    do {
        @autoreleasepool {
            systemError = [self.logger getSystemErrorByApplicationId:self.applicationId];
            
            if (systemError != NULL) {
                int responseCode = [self.upload systemErrorWithDeviceId:aDeviceId systemError:systemError];
                
                if (responseCode == Ok) {
                    [self.logger removeSystemError:systemError];
                }
                else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
                    self.authenticationFailure = true;
                    return;
                }
                else if (responseCode == GeneralError) {
                    return;
                }
            }
        }

    } while (systemError != NULL && !self.threadUploadInterrupted);
}

- (void)uploadCrashWithDeviceId: (CFUUIDRef)aDeviceId {
    Crash *crash = NULL;
    
    do {
        
        @autoreleasepool {
            crash = [self.logger getCrashByApplicationId:self.applicationId];
            
            if (crash != NULL) {
                int responseCode = [self.upload crashWithDeviceId:aDeviceId crash:crash];
                
                if (responseCode == Ok) {
                    [self.logger removeCrash:crash];
                }
                else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
                    self.authenticationFailure = true;
                    return;
                }
                else if (responseCode == GeneralError) {
                    return;
                }
            }
        }
        
    } while (crash != NULL && !self.threadUploadInterrupted);
}

- (Boolean)uploadUserWithDeviceId: (CFUUIDRef)aDeviceId {
    User *user = [self.settings getUserByApplicationId:self.applicationId statusType:Pending];
        
    if (user != NULL && user.status == Pending) {
        int responseCode = [self.upload userWithDeviceId:aDeviceId user:user];
            
        if (responseCode == Ok) {
            [self.settings updateUser:user statusType:Processed];
            return true;
        }
        else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
            self.authenticationFailure = true;
            return false;
        }
    } else if(user == NULL) {
        return false;
    }
    
    return true;
}

- (void)uploadErrorWithDeviceId: (CFUUIDRef)aDeviceId {
    ErrorItem *errorItem = NULL;
    
    do {
        
        @autoreleasepool {
            
            errorItem = [self.logger getErrorByApplicationId:self.applicationId];
            
            if (errorItem != NULL) {
                int responseCode = [self.upload errorWithDeviceId:aDeviceId errorItem:errorItem];
                
                if (responseCode == Ok) {
                    [self.logger removeErrorItem:errorItem];
                }
                else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
                    self.authenticationFailure = true;
                    return;
                }
                else if (responseCode == GeneralError) {
                    return;
                }
            }
            
        }
        
    } while (errorItem != NULL && !self.threadUploadInterrupted);
}

- (void)uploadEventWithDeviceId: (CFUUIDRef)aDeviceId {
    EventItem *eventItem = NULL;
    
    do {
        
        @autoreleasepool {
            
            eventItem = [self.logger getEventItemByApplicationId:self.applicationId];
            
            if (eventItem != NULL) {
                int responseCode = [self.upload eventWithDeviceId:aDeviceId eventItem:eventItem];
                
                if (responseCode == Ok) {
                    [self.logger removeEventItem:eventItem];
                }
                else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
                    self.authenticationFailure = true;
                    return;
                }
                else if (responseCode == GeneralError) {
                    return;
                }
            }
            
        }
        
    } while (eventItem != NULL && !self.threadUploadInterrupted);
}

- (void)uploadFeedbackWithDeviceId: (CFUUIDRef)aDeviceId {
    FeedbackItem *feedbackItem = NULL;
    
    do {
        
        @autoreleasepool {
        
            feedbackItem = [self.logger getFeedbackItemByApplicationId:self.applicationId];
            
            if (feedbackItem != NULL) {
                int responseCode = [self.upload feedbackWithDeviceId:aDeviceId feedbackItem:feedbackItem];
                
                if (responseCode == Ok) {
                    [self.logger removeFeedbackItem:feedbackItem];
                }
                else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
                    self.authenticationFailure = true;
                    return;
                }
                else if (responseCode == GeneralError) {
                    return;
                }
            }
            
        }
        
    } while (feedbackItem != NULL && !self.threadUploadInterrupted);
}

- (Boolean)uploadDeviceLocationWithDeviceId: (CFUUIDRef)aDeviceId {
    DeviceLocation *deviceLocation = [self.settings getDeviceLocationByStatusType:Processed];
    
    if (deviceLocation == NULL) {
        DeviceLocation *deviceLocationPending = [self.settings getDeviceLocationByStatusType:Pending];
        
        if (deviceLocationPending == NULL) {
            @try {
                deviceLocationPending = [self.deviceDynamicInfo getDeviceLocation];
            
                [self.settings saveDeviceLocation:deviceLocationPending statusType:Pending];
            }
            @catch (NSException *ex) {
                NSLog(@"%@%@%@", [ex name], [ex reason], [ex description]);
                deviceLocationPending = NULL;
            }
        }
    
        if (deviceLocationPending != NULL) {
            int responseCode = [self.upload locationWithDeviceId:aDeviceId applicationId:self.applicationId deviceLocation:deviceLocationPending];
            
            if (responseCode == Ok) {
                [self.settings saveDeviceLocation:deviceLocationPending statusType:Processed];
                return true;
            }
            else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
                self.authenticationFailure = true;
                return false;
            }
            else if (responseCode == GeneralError) {
                return false;
            }
        }
        else {
            return false;
        }
    }
    
    return true;
}

- (Boolean)uploadUpgradedWithDeviceId: (CFUUIDRef)aDeviceId {
    ApplicationMeta *applicationMeta = [self.settings loadApplicationByApplicationId:self.applicationId];
    
    if (applicationMeta.upgraded) {
        int responseCode = [self.upload upgrade:aDeviceId applicationId:self.applicationId version:applicationMeta.version];
        
        if (responseCode == Ok) {
            applicationMeta.upgraded = false;
            [self.settings updateApplication:applicationMeta];
            return true;
        }
        else if (responseCode == InactiveAccount || responseCode == InactiveApplication) {
            self.authenticationFailure = true;
            return false;
        }
        else if (responseCode == GeneralError) {
            return false;
        }
    }
    
    return true;
}

- (void)setTheThreadIsUploading: (bool)aThreadIsUploading {
    [self.threadIsUploadingLock lock];
    self.threadIsUploading = aThreadIsUploading;
    [self.threadIsUploadingLock signal];
    [self.threadIsUploadingLock unlock];
    
}

- (bool)getTheThreadIsUploading {
    return self.threadIsUploading;
}

@end
