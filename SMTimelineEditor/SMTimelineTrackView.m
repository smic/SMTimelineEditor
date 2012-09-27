//
//  SMTimelineTrackView.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 27.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMTimelineTrackView.h"
#import "SMTimeline.h"
#import "SMTimelineSegment.h"
#import "SMTimelineView.h"


@interface SMTimelineTrackView ()

//@property (readonly) SMTimeline *timeline;
@end

@implementation SMTimelineTrackView

//- (SMTimeline *)timeline {
//    return self.objectValue;
//}
//
//+ (NSSet *)keyPathsForValuesAffectingTimeline {
//    return [NSSet setWithObjects:@"objectValue", nil];
//}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib {
    SMTimelineView *timelineView = [self.subviews objectAtIndex:0];
    [timelineView bind:@"timeline" toObject:self withKeyPath:@"objectValue" options:nil];
}

//- (void)drawRect:(NSRect)dirtyRect {
//    // Drawing code here.
//    NSLog(@"bounds: %@", NSStringFromRect(self.frame));
//    
//    NSBezierPath *path = [NSBezierPath bezierPath];
//    [path moveToPoint:NSMakePoint(0.0f, -5.0f)];
//    [path lineToPoint:NSMakePoint(5.0f, 0.0f)];
//    [path lineToPoint:NSMakePoint(0.0f, 5.0f)];
//    [path lineToPoint:NSMakePoint(-5.0f, 0.0f)];
//    [path closePath];
//    path.lineWidth = 0;
//    
//    for (SMTimelineSegment *segment in self.timeline.segments) {
//        NSRect rect = NSInsetRect(self.bounds, 5.0f + 2.0f, 2.0f);
//        rect.origin.x += segment.position;
//        rect.size.width = segment.duration;
//        
//        {
//            [[NSColor redColor] setFill];
//            NSRectFill(rect);
//            [[NSColor blackColor] set];
//            NSFrameRect(rect);
//        }
//        
//        {
//            NSPoint point = NSMakePoint(NSMinX(rect), NSMidY(rect));
//            [NSGraphicsContext saveGraphicsState];
//            NSAffineTransform* transform = [NSAffineTransform transform];
//            [transform translateXBy:point.x yBy:point.y];
//            //    [transform translateXBy:point.x + 0.5f yBy:point.y + 0.5f];
//            [transform concat];
//            
//            [[NSColor whiteColor] setFill];
//            [path fill];
//            [[NSColor blackColor] set];
//            [path stroke];
//            [NSGraphicsContext restoreGraphicsState];
//        }
//        {
//            NSPoint point = NSMakePoint(NSMaxX(rect), NSMidY(rect));
//            [NSGraphicsContext saveGraphicsState];
//            NSAffineTransform* transform = [NSAffineTransform transform];
//            [transform translateXBy:point.x yBy:point.y];
//            //    [transform translateXBy:point.x + 0.5f yBy:point.y + 0.5f];
//            [transform concat];
//            
//            [[NSColor whiteColor] setFill];
//            [path fill];
//            [[NSColor blackColor] set];
//            [path stroke];
//            [NSGraphicsContext restoreGraphicsState];
//        }
//    }
//}
//
//- (NSView *)hitTest:(NSPoint)point {
//    NSLog(@"hitTest: %@", NSStringFromPoint(point));
//    NSView *result = [super hitTest:point];
//    NSLog(@"Result: %@", result);
//    return result;
//}
//
//- (void)mouseDown:(NSEvent *)event {
//	NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
//    SMTimelineSegment *selectedSegment = nil;
//    BOOL selectedPosition = YES;
//    NSRect bounds = self.bounds;
//    for (SMTimelineSegment *segment in self.timeline.segments) {
//        NSRect rect = NSMakeRect(2.0f + segment.position,
//                                 NSMidY(bounds) - 5.0f,
//                                 10.0f,
//                                 10.0f);
//        if (NSPointInRect(point, rect)) {
//            selectedSegment = segment;
//            selectedPosition = YES;
//        }
//        
//        rect = NSMakeRect(2.0f + segment.position + segment.duration,
//                          NSMidY(bounds) - 5.0f,
//                          10.0f,
//                          10.0f);
//        if (NSPointInRect(point, rect)) {
//            selectedSegment = segment;
//            selectedPosition = NO;
//        }
//    }
//	//if (selectedBoxIndex == NSNotFound) return;
//    if (!selectedSegment) {
//        return;
//    }
//    
//    [[NSCursor closedHandCursor] set];
//	while ([event type]!=NSLeftMouseUp) {
//		event = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
//		NSPoint currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];
//		currentPoint.x = fminf(fmaxf(currentPoint.x, bounds.origin.x), bounds.size.width);
//		currentPoint.y = fminf(fmaxf(currentPoint.y, bounds.origin.y), bounds.size.height);
//        
//		CGFloat dx = currentPoint.x-point.x;
//		CGFloat dy = currentPoint.y-point.y;
//        
//        if (dx == 0.0f && dy == 0.0f) {
//            continue;
//        }
//        
//        if (selectedPosition) {
//            if (selectedSegment.position + dx >= 0 && selectedSegment.duration - dx >= 0) {
//                selectedSegment.position += dx;
//                selectedSegment.duration -= dy;
//            }
//        } else {
//            if (selectedSegment.duration + dx >= 0 && selectedSegment.position + selectedSegment.duration + dx < 2000) {
//                selectedSegment.duration += dy;
//            }
//        }
//        
//		point = currentPoint;
//        
//        [self setNeedsDisplay:YES];
//	}
//    
//    [[NSCursor openHandCursor] set];
//}

@end
