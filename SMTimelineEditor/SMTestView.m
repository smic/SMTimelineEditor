//
//  SMTestView.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 27.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMTestView.h"

@implementation SMTestView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)event {
    NSLog(@"Mouse down");
}

@end
