//
//  SMElement.h
//  SMTimelineEditor
//
//  Created by Stephan Michels on 26.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMElement : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *timelines;

@end
