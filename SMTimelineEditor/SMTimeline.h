//
//  SMTimeline.h
//  SMTimelineEditor
//
//  Created by Stephan Michels on 27.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMTimeline : NSObject

@property (copy, nonatomic) NSString *propertyName;
@property (strong, nonatomic) NSArray *segments;

@end
