//
//  SMTimelineView.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 27.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMTimelineView.h"
#import "SMTimeline.h"
#import "SMTimelineSegment.h"


@implementation SMTimelineView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    NSLog(@"bounds: %@", NSStringFromRect(self.frame));
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0.0f, -5.0f)];
    [path lineToPoint:NSMakePoint(5.0f, 0.0f)];
    [path lineToPoint:NSMakePoint(0.0f, 5.0f)];
    [path lineToPoint:NSMakePoint(-5.0f, 0.0f)];
    [path closePath];
    path.lineWidth = 0;
    
    for (SMTimelineSegment *segment in self.timeline.segments) {
        NSRect rect = NSInsetRect(self.bounds, 5.0f + 2.0f, 2.0f);
        rect.origin.x += segment.position;
        rect.size.width = segment.duration;
        
        if (segment.duration > 0) {
            [[NSColor redColor] setFill];
            NSRectFill(rect);
            [[NSColor blackColor] set];
            NSFrameRect(rect);
        }
        
        {
            NSPoint point = NSMakePoint(NSMinX(rect), NSMidY(rect));
            [NSGraphicsContext saveGraphicsState];
            NSAffineTransform* transform = [NSAffineTransform transform];
            [transform translateXBy:point.x yBy:point.y];
            //    [transform translateXBy:point.x + 0.5f yBy:point.y + 0.5f];
            [transform concat];
            
            [[NSColor whiteColor] setFill];
            [path fill];
            [[NSColor blackColor] set];
            [path stroke];
            [NSGraphicsContext restoreGraphicsState];
        }
        if (segment.duration > 0) {
            NSPoint point = NSMakePoint(NSMaxX(rect), NSMidY(rect));
            [NSGraphicsContext saveGraphicsState];
            NSAffineTransform* transform = [NSAffineTransform transform];
            [transform translateXBy:point.x yBy:point.y];
            //    [transform translateXBy:point.x + 0.5f yBy:point.y + 0.5f];
            [transform concat];
            
            [[NSColor whiteColor] setFill];
            [path fill];
            [[NSColor blackColor] set];
            [path stroke];
            [NSGraphicsContext restoreGraphicsState];
        }
    }
}

- (void)mouseDown:(NSEvent *)event {
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    SMTimelineSegment *selectedSegment = nil;
    BOOL selectedPosition = YES;
    NSRect bounds = self.bounds;
    for (SMTimelineSegment *segment in self.timeline.segments) {
        NSRect rect = NSMakeRect(2.0f + segment.position,
                                 NSMidY(bounds) - 5.0f,
                                 10.0f,
                                 10.0f);
        if (NSPointInRect(point, rect)) {
            selectedSegment = segment;
            selectedPosition = YES;
        }
        
        rect = NSMakeRect(2.0f + segment.position + segment.duration,
                          NSMidY(bounds) - 5.0f,
                          10.0f,
                          10.0f);
        if (NSPointInRect(point, rect)) {
            selectedSegment = segment;
            selectedPosition = NO;
        }
    }
	//if (selectedBoxIndex == NSNotFound) return;
    if (!selectedSegment) {
        return;
    }
    
    [[NSCursor closedHandCursor] set];
	while ([event type]!=NSLeftMouseUp) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		NSPoint currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];
		currentPoint.x = fminf(fmaxf(currentPoint.x, bounds.origin.x), bounds.size.width);
		currentPoint.y = fminf(fmaxf(currentPoint.y, bounds.origin.y), bounds.size.height);
        
		CGFloat dx = currentPoint.x-point.x;
		CGFloat dy = currentPoint.y-point.y;
        
        if (dx == 0.0f && dy == 0.0f) {
            continue;
        }
        
        CGFloat location = currentPoint.x - 7.0f;
        
        if (selectedPosition) {
            location = MAX(0, MIN(selectedSegment.position + selectedSegment.duration, location));

            selectedSegment.duration = selectedSegment.position + selectedSegment.duration - location;
            selectedSegment.position = location;
        } else {
            location = MAX(selectedSegment.position, MIN(2000, location));

            selectedSegment.duration = location - selectedSegment.position;
        }
        
		point = currentPoint;
        
        [self setNeedsDisplay:YES];
	}
    
    [[NSCursor openHandCursor] set];
}

@end
