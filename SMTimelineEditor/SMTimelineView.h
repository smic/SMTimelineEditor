//
//  SMTimelineView.h
//  SMTimelineEditor
//
//  Created by Stephan Michels on 27.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMTimeline;

@interface SMTimelineView : NSView

@property (strong, nonatomic) SMTimeline *timeline;

@end
