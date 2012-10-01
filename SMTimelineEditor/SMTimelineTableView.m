//
//  SMTimelineTableView.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 28.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMTimelineTableView.h"
#import "SMGuideView.h"

@implementation SMTimelineTableView

- (CGFloat)rulerView:(NSRulerView *)rulerView willMoveMarker:(NSRulerMarker *)marker toLocation:(CGFloat)location {
    NSLog(@"will move marker:%@ toLocation:%f", marker, location);
    
    location = MAX(location, rulerView.originOffset);
    
    NSTimeInterval time = location;
    [(id)self.delegate timelineTableView:self didChangeTime:time];
    
    return location;
}

//- (void)rulerView:(NSRulerView *)rulerView didMoveMarker:(NSRulerMarker *)marker {
//    
//}

//- (void)awakeFromNib {
//    SMGuideView *guideView = [[SMGuideView alloc] initWithFrame:self.bounds];
//    guideView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
//    [self addSubview:guideView];
//}

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//    
//    // Drawing code here.
//    static NSColor *color = nil;
//    if (!color) {
//        color = [NSColor colorWithCalibratedRed:0.0f green:1.0f blue:0.0f alpha:0.4f];
//    }
//    [color set];
//    NSRectFill(dirtyRect);
//}


@end
