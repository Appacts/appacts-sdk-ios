//
//  ApplicationMeta.h
//  SampleApplication
//
//  Created by Jamie Wheeldon on 16/09/2012.
//
//

#import <Foundation/Foundation.h>
#import "ApplicationStateType.h"

@interface ApplicationMeta : NSObject

{
    CFUUIDRef id;
    int state;
    NSDate *dateCreated;
    CFUUIDRef sessionId;
    NSString *version;
    Boolean upgraded;
    int optStatus;
}
@property (nonatomic) CFUUIDRef id;
@property (nonatomic) int state;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic) CFUUIDRef sessionId;
@property (nonatomic, strong) NSString *version;
@property (nonatomic) Boolean upgraded;
@property (nonatomic) int optStatus;

-  (id)initWithApplicationId: (CFUUIDRef)anApplicationId applicationStateType: (ApplicationStateType)anApplicationStateType sessionId: (CFUUIDRef)aSessionId dateCreated: (NSDate *)aDateCreated version: (NSString *)aVersion upgraded: (Boolean)anUpgraded optStatus: (int)anOptStatus;
-  (id)initWithApplicationId: (CFUUIDRef)anApplicationId applicationStateType: (ApplicationStateType)anApplicationStateType dateCreated: (NSDate *)aDateCreated optStatus: (int)anOptStatus;

@end
