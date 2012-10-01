//
//  SMGuideView.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 01.10.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMGuideView.h"

@implementation SMGuideView

static char SMObservationContext;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self addObserver:self forKeyPath:@"time" options:0 context:&SMObservationContext];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
//    static NSColor *color = nil;
//    if (!color) {
//        color = [NSColor colorWithCalibratedRed:1.0f green:0.0f blue:0.0f alpha:0.4f];
//    }
//    [color set];
//    NSRectFill(dirtyRect);
    
    CGFloat x = /*5.0f + 2.0f +*/ roundf(self.time - NSMinX(self.frame));
    
    [[NSColor blackColor] set];
    [NSBezierPath setDefaultLineWidth:0];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(x + 0.5f, NSMinY(self.bounds))
                              toPoint:NSMakePoint(x + 0.5f, NSMaxY(self.bounds))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &SMObservationContext) {
        return;
    }
    
    [self setNeedsDisplay:YES];
}

@end
