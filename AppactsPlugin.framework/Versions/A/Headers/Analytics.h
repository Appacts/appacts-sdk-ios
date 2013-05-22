//
//  Analytics.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 23/05/2012. Modified By Zan Kavtaskin 25/12/2012 23:04.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UploadType.h"
#import "ExceptionDescriptive.h"
#import "SexType.h"
#import "OptStatusType.h"
#import "RatingType.h"

@interface Analytics : NSObject

- (id)init;
- (void)startWithApplicationId:(NSString *)anApplicationId;
- (void)startWithApplicationId:(NSString *)anApplicationId uploadType:(UploadType)anUploadType;

- (void)logErrorWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName data: (NSString*)aData exception: (NSException *)anException;

- (void)logEventWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName data: (NSString*)aData;
- (void)logEventWithScreenName: (NSString *)aScreenName eventName: (NSString *)anEventName;

- (void)logFeedbackWithScreenName: (NSString *)aScreenName rating: (RatingType)aRating comment: (NSString *)aComment;

- (void)screenOpenWithScreenName: (NSString *)aScreenName;
- (void)screenClosedWithScreenName: (NSString *)aScreenName;

- (void)contentLoadingWithScreenName: (NSString *)aScreenName contentName: (NSString *)aContentName;
- (void)contentLoadedWithScreenName:(NSString *)aScreenName contentName: (NSString *)aContentName;

- (void)setUserInformationWithAge: (int)anAge sexType: (SexType)aSexType;
- (Boolean)isUserInformationSet;
- (void)setOptStatus: (OptStatusType)anOptStatusType;
- (OptStatusType)getOptStatus;
- (void)uploadWhileUsingAsync;
- (void)uploadManual;

- (void)stop;

@end
