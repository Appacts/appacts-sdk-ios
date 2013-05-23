Integration Examples
===============

##Basic Integration##

###Methods###

For basic integration, you can use the following methods:

    - (void)startWithApplicationId:(NSString *) baseUrl: (NSString *);
    - (void)logEventWithScreenName:(NSString *) eventName:(NSString *);
    - (void)stop;


####Sample Usage####

#####Import#####

    #import <AppactsPlugin/AppactsPlugin.h>
  
#####AppDelegate#####
  
  
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        //Set the event handler
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        
        //start main analytics session
        [[AnalyticsSingleton getInstance] startWithApplicationId:@"157df156-80d9-4c78-9cb4-e5c299526bb7" baseUrl:@"http://youserver.com/api/"];
        
        return YES;
    }
    
    - (void)applicationDidEnterBackground:(UIApplication *)application
    {
        //stop analytics session as applications goes to background
        [[AnalyticsSingleton getInstance] stop];
    }
    
    - (void)applicationWillEnterForeground:(UIApplication *)application
    {
        //start analytics session as applications comes back from backround
        [[AnalyticsSingleton getInstance] startWithApplicationId:@"157df156-80d9-4c78-9cb4-e5c299526bb7" baseUrl:@"http://youserver.com/api/"];
    }
    
    - (void)applicationWillTerminate:(UIApplication *)application
    {
        //end main analytics session
        [[AnalyticsSingleton getInstance] stop];
    }
    
    //We strongly recommend that you have generic uncaught exception handler
    void uncaughtExceptionHandler(NSException *exception) {
        [[AnalyticsSingleton getInstance] logErrorWithScreenName:@"AppDelegate" eventName:@"Uncaught" data:nil exception:exception];
    }
    
#####ViewController#####
    
    - (IBAction)btnGenerateClick:(id)sender
    {
        [[AnalyticsSingleton getInstance] logEventWithScreenName:@"Main" eventName:@"Generate"];
        
        NSArray *petNames = [[NSArray alloc] initWithObjects:@"Meow", @"Kitty", @"Sammy", @"Cat", @"Lucy", nil];
        
        self.lblName.text = [petNames objectAtIndex: arc4random() % [petNames count]];
    }
    

##Advanced Integration##

###Methods###

For advanced integration, you can use the following methods:

    + (id)init;
    + (void)startWithApplicationId:(NSString *)anApplicationId baseUrl: (NSString *);
    + (void)startWithApplicationId:(NSString *)anApplicationId baseUrl: (NSString *) uploadType:(UploadType)anUploadType;
    + (void)logErrorWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName data: (NSString*)aData exception: (NSException *)anException;
    + (void)logEventWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName data: (NSString*)aData;
    + (void)logEventWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName;
    - (void)logFeedbackWithScreenName: (NSString *)aScreenName rating: (RatingType)aRating comment: (NSString *)aComment;
    + (void)screenOpenWithScreenName: (NSString *)aScreenName;
    + (void)screenClosedWithScreenName: (NSString *)aScreenName;
    + (void)contentLoadingWithScreenName: (NSString *)aScreenName contentName: (NSString *)aContentName;
    + (void)contentLoadedWithScreenName:(NSString *)aScreenName contentName: (NSString *)aContentName;
    + (void)setUserInformationWithAge: (int)anAge sexType: (SexType)aSexType;
    + (Boolean)isUserInformationSet;
    - (void)setOptStatus: (OptStatusType)anOptStatusType;
    - (OptStatusType)getOptStatus;
    + (void)uploadWhileUsingAsync;
    + (void)uploadManual;
    + (void)stop;

#####Import#####

    #import <AppactsPlugin/AppactsPlugin.h>
    
####Getting an instance####

When your application is opened you need to obtain a new instance of IAnalytics. You can do this easily by using AnalyticsSingleton. For example:

#####Methods#####

    + (Analytics *)getInstance;


#####Sample#####

    Analytics * analytics = [[AnalyticsSingleton getInstance];


#####Optional#####

We suggest that you add an abstract base class into your application so that you have a common area from where everything derives. For example:
        
        //  BaseViewController.h
        @interface BaseViewController : UIViewController
        
        {
            NSString *screenName;
        }
        @property (strong, nonatomic) NSString *screenName;
        
        - (id)initWithCoderAndScreenName:(NSCoder *)nsCoder screenName: (NSString *)aScreenName;
        
        @end
        //  BaseViewController.m
        @implementation BaseViewController
        
        @synthesize screenName;
        
         
        - (id)initWithCoderAndScreenName:(NSCoder *)nsCoder screenName: (NSString *)aScreenName
        {
            self = [super initWithCoder:nsCoder];
            
            if(self)
            {
                self.screenName = aScreenName;
            }
            
            return self;
        }
        
        - (void)viewDidLoad
        {
            [super viewDidLoad];
            
            [[AnalyticsSingleton getInstance] screenOpenWithScreenName:self.screenName];
        }
        
        - (void)viewWillUnload
        {
            [super viewDidUnload];
        }
        
        - (void)viewDidUnload
        {
            [super viewDidUnload];
        }
        
        - (void)viewDidDisappear:(BOOL)animated
        {
            [[AnalyticsSingleton getInstance] screenClosedWithScreenName:self.screenName];
            
            [super viewDidDisappear:animated];
        }
        
        - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
        {
            return (interfaceOrientation == UIInterfaceOrientationPortrait);
        }
        
        @end

####Session Management####

Fantastic thing about iOS framework is that all of the application life-cycle event handlers can be found in one place. You need to update AppDelegate.m to call relevant methods.


#####Methods#####
    
    - (void)startWithApplicationId:(NSString *);
    - (void)stop;


#####Sample - AppDelegate#####


    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        //Set the event handler
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        
        //start main analytics session
        [[AnalyticsSingleton getInstance] startWithApplicationId:@"157df156-80d9-4c78-9cb4-e5c299526bb7" serverUrl:@"http://youserver.com/api/"];
        
        return YES;
    }
    
    - (void)applicationDidEnterBackground:(UIApplication *)application
    {
        //stop analytics session as applications goes to background
        [[AnalyticsSingleton getInstance] stop];
    }
    
    - (void)applicationWillEnterForeground:(UIApplication *)application
    {
        //start analytics session as applications comes back from backround
        [[AnalyticsSingleton getInstance] startWithApplicationId:@"157df156-80d9-4c78-9cb4-e5c299526bb7 serverUrl:@"http://youserver.com/api/""];
    }
    - (void)applicationWillTerminate:(UIApplication *)application
    {
        //end main analytics session
        [[AnalyticsSingleton getInstance] stop];
    }
    
    void uncaughtExceptionHandler(NSException *exception) {
        [[AnalyticsSingleton getInstance] logErrorWithScreenName:@"AppDelegate" eventName:@"Uncaught" data:nil exception:exception];
    }

Note: Please make sure that .Start & .Stop is always called from main thread, these two methods need to hook in to network coverage event handler.

####Opt In or Opt out?####

Every app is different. Your business needs to make a decision about how it wants to deal with its users. You can be really nice and ask your users whether or not they would like to participate in your customer experience improvement program. If they say yes you can use our services and log their experience. Alternatively you can make them opt in automatically by accepting your terms and conditions. Either way here is how you control opt in/ out in the terms and conditions scenario:

#####Methods#####

    - (void)setOptStatus: (OptStatusType)anOptStatusType;
    - (OptStatusType)getOptStatus;
    

#####Sample - GetOptStatus#####

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        
        if ([[AnalyticsSingleton getInstance] getOptStatus] == None)
        {
            [self performSegueWithIdentifier:@"ShowTermsAndConditions" sender:self];
        }
        else if (![[AnalyticsSingleton getInstance] isUserInformationSet])
        {
            [self performSegueWithIdentifier:@"ShowDemographic" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"ShowCat" sender:self];
        }
    }

#####Sample - SetOptStatus#####

    - (IBAction)btnAgreeClick:(id)sender
    {
        [[AnalyticsSingleton getInstance] setOptStatus:OptIn];
        
        if (![[AnalyticsSingleton getInstance] isUserInformationSet])
        {
            [self performSegueWithIdentifier:@"ShowDemographic" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"ShowCat" sender:self];
        }
    }


####Demographics####

To improve your app you need to know who is using it, how old they are, what their gender is & where they are from. We have made it easy for you to capture this information:

#####Methods#####

    - (void)setUserInformationWithAge: (int)anAge sexType: (SexType)aSexType;
    - (Boolean)isUserInformationSet;
    

#####Sample - IsUserInformationSet#####

    if (![[AnalyticsSingleton getInstance] isUserInformationSet])
    {
        [self performSegueWithIdentifier:@"ShowDemographic" sender:self];
    }


#####Sample - SetUserInformation#####

    @try {
        [[AnalyticsSingleton getInstance] setUserInformationWithAge:age sexType:sexType];
    }
    @catch (NSException *exception) {
        //couldn't save user info db is not working or other issue, see exception
    }
    @finally {
        //todo: clean up
    }
    
Note: Our plugin throws exception if it can't save users information. Normally this happens when user’s storage card is not present, it was corrupt, or device is full. As we throw an error you can notify a user that there was an issue or just handle it using in your app as per your business requirements.



####Logging and uploading your customers experience####


#####Methods#####

    - (void)logErrorWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName data: (NSString*)aData exception: (NSException *)anException;
    - (void)logEventWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName data: (NSString*)aData;
    - (void)logEventWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName;
    - (void)logFeedbackWithScreenName: (NSString *)aScreenName rating: (RatingType)aRating comment: (NSString *)aComment;
    - (void)screenOpenWithScreenName: (NSString *)aScreenName;
    - (void)screenClosedWithScreenName: (NSString *)aScreenName;
    - (void)contentLoadingWithScreenName: (NSString *)aScreenName contentName: (NSString *)aContentName;
    - (void)contentLoadedWithScreenName:(NSString *)aScreenName contentName: (NSString *)aContentName;
    - (void)uploadWhileUsingAsync;
    - (void)uploadManual;


#####Sample - LogError#####

    @try
    {    
        NSArray *catNames = [[NSArray alloc] initWithObjects:@"Meow", @"Kitty", @"Sammy", @"Cat", @"Lucy", nil];

        self.lblCatName.text = [catNames objectAtIndex: arc4random() % [catNames count]];
    }
    @catch (NSException *exception)
    {
        [[AnalyticsSingleton getInstance] logErrorWithScreenName:self.screenName eventName:@"Generate" data:NULL exception:exception];
    }


#####Sample - LogEvent#####

    - (IBAction)btnGenerateClick:(id)sender
    {
        [[AnalyticsSingleton getInstance] logEventWithScreenName:self.screenName eventName:@"Generate" data:NULL];
    }


#####Sample - LogFeedback#####

    @try
    {
        int rating = [[self.lblRating text] intValue];
        
        [[AnalyticsSingleton getInstance] logFeedbackWithScreenName:self.screenName rating:(RatingType)rating comment:[self.txtComment text]];
    }
    @catch (NSException *exception)
    {
        //todo: can't save feedback, see exception for more info.
    }
    
Note: Our plugin throws exception if it can't save users information. Normally this happens when user’s storage card is not present, it was corrupt, or device is full. As we throw an error you can notify a user that there was an issue or just handle it using in your app as per your business requirements.



#####Sample - ScreenOpen & ScreenClosed#####

    - (void)viewDidLoad
    {
        [super viewDidLoad];
        
        [[AnalyticsSingleton getInstance] screenOpenWithScreenName:self.screenName];
    }
    
    - (void)viewDidDisappear:(BOOL)animated
    {
        [[AnalyticsSingleton getInstance] screenClosedWithScreenName:self.screenName];
        
        [super viewDidDisappear:animated];
    }


Note: Screen names need to be unique for each screen. We collect screen names in our plugin so that when Screen Closed is called we can calculate how long the user was on the screen for. You can use ScreenOpen many times but it will only register each unique screen name once.

#####Sample - ContentLoading & ContentLoaded#####

    [[AnalyticsSingleton getInstance] contentLoadingWithScreenName:self.screenName contentName:@"GeneratingContent"];
    
    @try
    {
       //call your web service
    }
    @catch (NSException *exception)
    {
        [[AnalyticsSingleton getInstance] logErrorWithScreenName:self.screenName eventName:@"Getting data" data:NULL exception:exception];
    }
    
    [[AnalyticsSingleton getInstance] contentLoadedWithScreenName:self.screenName contentName:@"GeneratingContent"];


####Sample - UploadWhileUsingAsync & UploadManual####

We have created two methods for two different scenarios:

#UploadWhileUsingAsync – use this when you are creating a light application, i.e. utilities, forms, etc.. Using this method we will take care of all data uploading. As soon as the user creates an event we will try and upload this event to our servers and present it to you in your reports. The aim of this approach is to prevent waiting and obtain data straight away. Using this approach is recommended by our team as this will monitor network coverage, event queues and it will do its best to get data to our servers immediately.

#UploadManual – use this when you have a very event heavy application i.e. game. Using this method you will need to raise the upload event manually when you are ready. This is a very light approach and popular among some app makers, however data might not be uploaded to our servers for days/ weeks (depending on the app use) therefore statistics will be delayed.

#UploadWhileUsingAsync & UploadManual – you could always use both together. You can specify that you want to upload manually and later call UploadWhileUsingAsync. The example below will demonstrate this.

#####UploadWhileUsingAsync#####

    [[AnalyticsSingleton getInstance] startWithApplicationId:@"157df156-80d9-4c78-9cb4-e5c299526bb7" serverUrl:@"http://youserver.com/api/" uploadType:WhileUsingAsync];


By specifying Upload Type While Using Async during the initial singleton request, the plugin will automatically start uploading data while a user is using the app.

#####UploadManual#####

    [[AnalyticsSingleton getInstance] startWithApplicationId:@"157df156-80d9-4c78-9cb4-e5c299526bb7" serverUrl:@"http://youserver.com/api/" uploadType:Manual];

By specifying Upload Type Manual during the initial singleton request, the plugin will not upload any data. It will just collect it and you will need to manually trigger either “UploadManual” or “UploadWhileUsingAsync” i.e.

    - (IBAction)btnGenerateClick:(id)sender
    {
        [[AnalyticsSingleton getInstance] logEventWithScreenName:self.screenName eventName:@"Generate"];
        [[AnalyticsSingleton getInstance] uploadManual];
    }
    

You have to manually trigger upload if you want an upload to take place at a certain point. As mentioned before it has many draw backs, although it must be used in heavy data collection scenarios.

    - (IBAction)btnGenerateClick:(id)sender
    {
        [[AnalyticsSingleton getInstance] logEventWithScreenName:self.screenName eventName:@"Generate"];
        [[AnalyticsSingleton getInstance] uploadWhileUsingAsync];
    }


You can call UploadWhileUsingAsync manually later if you called your singleton with “Manual”. This can be useful in different scenarios but this approach should be rarely used.

