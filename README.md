Integration Examples
===============

##Basic Integration##

###Methods###

For basic integration, you can use the following methods:

  - (void)startWithApplicationId:(NSString *) serverUrl: (NSString *);
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
  ###ViewController###
  
  
  - (IBAction)btnGenerateClick:(id)sender
  {
      [[AnalyticsSingleton getInstance] logEventWithScreenName:@"Main" eventName:@"Generate"];
      
      NSArray *petNames = [[NSArray alloc] initWithObjects:@"Meow", @"Kitty", @"Sammy", @"Cat", @"Lucy", nil];
      
      self.lblName.text = [petNames objectAtIndex: arc4random() % [petNames count]];
  }
