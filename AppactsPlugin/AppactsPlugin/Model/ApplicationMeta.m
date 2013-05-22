//
//  ApplicationMeta.m
//  SampleApplication
//
//  Created by Jamie Wheeldon on 16/09/2012.
//
//

#import "ApplicationMeta.h"

@implementation ApplicationMeta

@synthesize id;
@synthesize state;
@synthesize dateCreated;
@synthesize sessionId;
@synthesize version;
@synthesize upgraded;
@synthesize optStatus;

-  (id)initWithApplicationId: (CFUUIDRef)anApplicationId applicationStateType: (ApplicationStateType)anApplicationStateType sessionId: (CFUUIDRef)aSessionId dateCreated: (NSDate *)aDateCreated version: (NSString *)aVersion upgraded: (Boolean)anUpgraded optStatus: (int)anOptStatus {
    self.Id = anApplicationId;
    self.state = anApplicationStateType;
    self.sessionId = aSessionId;
    self.dateCreated = aDateCreated;
    self.version = aVersion;
    self.upgraded = anUpgraded;
    self.optStatus = anOptStatus;
    
    return self;
}

-  (id)initWithApplicationId: (CFUUIDRef)anApplicationId applicationStateType: (ApplicationStateType)anApplicationStateType dateCreated: (NSDate *)aDateCreated optStatus: (int)anOptStatus {
    self.Id = anApplicationId;
    self.state = anApplicationStateType;
    self.dateCreated = aDateCreated;
    self.optStatus = anOptStatus;
    
    return self;
}

@end
