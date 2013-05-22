//
//  EventType.h
//  AppactsPlugin
//
//  Created by Jamie Wheeldon on 13/06/2012.
//  Copyright (c) 2012 Appacts. All rights reserved.
//

#ifndef AppactsPlugin_EventType_h
#define AppactsPlugin_EventType_h

typedef enum {
    ApplicationOpen = 1,
	ApplicationClose = 2,
	Error = 3,
	Event = 4,
	Feedback = 5,
	ScreenClosed = 6,
	ContentLoaded = 7,
	ContentLoading = 8,
	ScreenOpen = 9
} EventType;

#endif
