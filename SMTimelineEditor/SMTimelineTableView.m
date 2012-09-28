//
//  SMTimelineTableView.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 28.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMTimelineTableView.h"

@implementation SMTimelineTableView

- (CGFloat)rulerView:(NSRulerView *)rulerView willMoveMarker:(NSRulerMarker *)marker toLocation:(CGFloat)location {
    NSLog(@"will move marker:%@ toLocation:%f", marker, location);
    
    location = MAX(location, rulerView.originOffset);
    
    return location;
}

@end
