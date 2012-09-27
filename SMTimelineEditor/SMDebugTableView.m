//
//  SMDebugTableView.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 27.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMDebugTableView.h"

@implementation SMDebugTableView

- (void)mouseDown:(NSEvent *)event {
    NSLog(@"Stack: %@", [NSThread callStackSymbols]);
    [super mouseDown:event];
}

- (void)selectRowIndexes:(NSIndexSet *)indexes byExtendingSelection:(BOOL)extend {
    NSLog(@"Stack: %@", [NSThread callStackSymbols]);
    [super selectRowIndexes:indexes byExtendingSelection:extend];
}

@end
