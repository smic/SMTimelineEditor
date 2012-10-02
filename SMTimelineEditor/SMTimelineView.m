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
//    NSLog(@"bounds: %@", NSStringFromRect(self.frame));
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(0.0f, -5.5f)];
    [path lineToPoint:NSMakePoint(5.5f, 0.0f)];
    [path lineToPoint:NSMakePoint(0.0f, 5.5f)];
    [path lineToPoint:NSMakePoint(-5.5f, 0.0f)];
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
//            [transform translateXBy:point.x yBy:point.y];
                [transform translateXBy:point.x - 0.5f yBy:point.y/* + 0.5f*/];
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
//            [transform translateXBy:point.x yBy:point.y];
            [transform translateXBy:point.x - 0.5f yBy:point.y/* + 0.5f*/];
            [transform concat];
            
            [[NSColor whiteColor] setFill];
            [path fill];
            [[NSColor blackColor] set];
            [path stroke];
            [NSGraphicsContext restoreGraphicsState];
        }
    }
    
//    [[NSColor redColor] set];
//    [NSBezierPath strokeLineFromPoint:NSMakePoint(100.0f, NSMinY(self.bounds))
//                              toPoint:NSMakePoint(100.0f, NSMaxY(self.bounds))];
//    NSLog(@"frame=%@ superView=%@", NSStringFromRect(self.frame), NSStringFromRect(self.superview.frame));
}

typedef enum {
    SMHandleSegment = 0,
    SMHandleSegmentStart,
    SMHandleSegmentEnd,
} SMHandle;

- (void)mouseDown:(NSEvent *)event {
	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    SMTimelineSegment *selectedSegment = nil;
    NSUInteger selectedSegmentIndex = NSNotFound;
    SMHandle selectedHandle = SMHandleSegment;
    NSRect bounds = self.bounds;
    NSPoint handleOffset = NSZeroPoint;
    
    NSArray *segments = self.timeline.segments;
    
    NSUInteger segmentIndex = 0;
    for (SMTimelineSegment *segment in segments) {
        NSRect rect = NSMakeRect(2.0f + segment.position,
                                 NSMidY(bounds) - 5.0f,
                                 10.0f,
                                 10.0f);
        if (NSPointInRect(point, rect)) {
            selectedSegment = segment;
            selectedSegmentIndex = segmentIndex;
            selectedHandle = SMHandleSegmentStart;
            handleOffset = NSMakePoint(point.x - (segment.position + 2.0f + 5.0f), NSMidY(bounds));
            break;
        }
        
        rect = NSMakeRect(2.0f + segment.position + segment.duration,
                          NSMidY(bounds) - 5.0f,
                          10.0f,
                          10.0f);
        if (NSPointInRect(point, rect)) {
            selectedSegment = segment;
            selectedSegmentIndex = segmentIndex;
            selectedHandle = SMHandleSegmentEnd;
            handleOffset = NSMakePoint(point.x - (segment.position + segment.duration + 2.0f + 5.0f), NSMidY(bounds));
            break;
        }
        
        rect = NSMakeRect(2.0f + 5.0f + segment.position,
                          NSMidY(bounds) - 5.0f,
                          segment.duration,
                          10.0f);
        if (NSPointInRect(point, rect)) {
            selectedSegment = segment;
            selectedSegmentIndex = segmentIndex;
            selectedHandle = SMHandleSegment;
            handleOffset = NSMakePoint(point.x - (segment.position + 2.0f + 5.0f), NSMidY(bounds));
            break;
        }

        segmentIndex++;
    }
	//if (selectedBoxIndex == NSNotFound) return;
    if (!selectedSegment) {
        return;
    }
    
    NSLog(@"selectedHandle=%i handleOffset=%@", selectedHandle, NSStringFromPoint(handleOffset));
    
    SMTimelineSegment *previousSegment = selectedSegmentIndex > 0 ? [segments objectAtIndex:selectedSegmentIndex - 1] : nil;
    SMTimelineSegment *nextSegment = selectedSegmentIndex + 1 < [segments count] ? [segments objectAtIndex:selectedSegmentIndex + 1] : nil;
    
    [[NSCursor closedHandCursor] set];
	while ([event type]!=NSLeftMouseUp) {
		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		NSPoint currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];
		currentPoint.x = fminf(fmaxf(currentPoint.x, bounds.origin.x), bounds.size.width);
		currentPoint.y = fminf(fmaxf(currentPoint.y, bounds.origin.y), bounds.size.height);
        
		CGFloat dx = currentPoint.x - point.x;
		CGFloat dy = currentPoint.y - point.y;
        
        if (dx == 0.0f && dy == 0.0f) {
            continue;
        }
        
        
        CGFloat location = currentPoint.x - 2.0f - 5.0f - handleOffset.x;
        if (selectedHandle == SMHandleSegmentStart) {
            // greater or equal the zero
            location = MAX(0, location);
            // lesser or equal than the end of the segment
            location = MIN(selectedSegment.position + selectedSegment.duration, location);
            // greater or equal than the end of the previous segment
            if (previousSegment) {
                location = MAX(previousSegment.position + previousSegment.duration, location);
            }

            selectedSegment.duration = selectedSegment.position + selectedSegment.duration - location;
            selectedSegment.position = location;
        } else if (selectedHandle == SMHandleSegmentEnd) {
            // greather or equal than the segment start
            location = MAX(selectedSegment.position, location);
            // lesser or egaul than time end
            location = MIN(2000, location);
            // lesser than the start of the next segment
            if (nextSegment) {
                location = MIN(nextSegment.position, location);
            }

            selectedSegment.duration = location - selectedSegment.position;
        } else if (selectedHandle == SMHandleSegment) {
            // greater or equal the zero
            location = MAX(0, location);
            // lesser or egaul than time end
            location = MIN(2000 - selectedSegment.duration, location);
            if (previousSegment) {
                location = MAX(previousSegment.position + previousSegment.duration, location);
            }
            if (nextSegment) {
                location = MIN(nextSegment.position - selectedSegment.duration, location);
            }
            
            selectedSegment.position = location;
        }
        
		point = currentPoint;
        
        [self setNeedsDisplay:YES];
	}
    
    [[NSCursor openHandCursor] set];
}

@end
