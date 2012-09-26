//
//  SMAppDelegate.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 26.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMElement.h"

@interface SMAppDelegate ()

@property (weak) IBOutlet NSScrollView *outlineScrollView;
@property (weak) IBOutlet NSOutlineView *outline;
@property (weak) IBOutlet NSScrollView *tableScrollView;
@property (weak) IBOutlet NSTableView *table;

@property (strong, nonatomic) NSArray *elements;

@end

@implementation SMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self startSynchronizing];
    
    NSLog(@"Outline Scroll View: %p", self.outlineScrollView);
    NSLog(@"Table Scroll View: %p", self.tableScrollView);
    
    NSMutableArray *elements = [NSMutableArray arrayWithCapacity:3];
    
    SMElement *element1 = [[SMElement alloc] init];
    element1.name = @"Element 1";
    [elements addObject:element1];
    
    SMElement *element2 = [[SMElement alloc] init];
    element2.name = @"Element 2";
    [elements addObject:element2];
    
    SMElement *element3 = [[SMElement alloc] init];
    element3.name = @"Element 3";
    [elements addObject:element3];
    
    self.elements = elements;
    
    [self.outline reloadData];
    [self.table reloadData];
}

#pragma mark - Outline data source

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (!item) {
        return [self.elements count];
    }
    return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (!item) {
        return YES;
    }
    return NO;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        return [self.elements objectAtIndex:index];
    }
    return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    if ([item isKindOfClass:[SMElement class]]) {
        SMElement *element = item;
        return element.name;
    }
    return nil;
}

#pragma mark - Table data source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.elements count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
//    // The column identifier string is the easiest way to identify a table column. Much easier
//    // than keeping a reference to the table column object.
//    NSString *columnIdentifer = [aTableColumn identifier];
//    
//    // Get the name at the specified row in the namesArray
//    NSString *theName = [namesArray objectAtIndex:rowIndex];
//    
//    
//    // Compare each column identifier and set the return value to
//    // the Person field value appropriate for the column.
//    if ([columnIdentifer isEqualToString:@"name"]) {
//        returnValue = theName;
//    }
    
    SMElement *element = [self.elements objectAtIndex:rowIndex];
    return element.name;
}

#pragma mark - Scroll view

- (void)startSynchronizing {
    {
        // don't retain the watched view, because we assume that it will
        // be retained by the view hierarchy for as long as we're around.
        NSScrollView *synchronizedScrollView = self.outlineScrollView;
        
        // get the content view of the
        NSClipView *synchronizedContentView = [synchronizedScrollView contentView];
        
        // Make sure the watched view is sending bounds changed
        // notifications (which is probably does anyway, but calling
        // this again won't hurt).
        [synchronizedContentView setPostsBoundsChangedNotifications:YES];
        
        // a register for those notifications on the synchronized content view.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(synchronizedViewContentBoundsDidChange:)
                                                     name:NSViewBoundsDidChangeNotification
                                                   object:synchronizedContentView];
    }
    {
        // don't retain the watched view, because we assume that it will
        // be retained by the view hierarchy for as long as we're around.
        NSScrollView *synchronizedScrollView = self.tableScrollView;
        
        // get the content view of the
        NSClipView *synchronizedContentView = [synchronizedScrollView contentView];
        
        // Make sure the watched view is sending bounds changed
        // notifications (which is probably does anyway, but calling
        // this again won't hurt).
        [synchronizedContentView setPostsBoundsChangedNotifications:YES];
        
        // a register for those notifications on the synchronized content view.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(synchronizedViewContentBoundsDidChange:)
                                                     name:NSViewBoundsDidChangeNotification
                                                   object:synchronizedContentView];
    }
}

- (void)synchronizedViewContentBoundsDidChange:(NSNotification *)notification
{
    // get the changed content view from the notification
    NSClipView *changedContentView = [notification object];
    NSScrollView *changedScrollView = [changedContentView.documentView enclosingScrollView];
    NSLog(@"Changed scroll view: %p", changedScrollView);
    
    NSScrollView *scrollView = nil;
    if (changedScrollView == self.outlineScrollView) {
        scrollView = self.tableScrollView;
    } else {
        scrollView = self.outlineScrollView;
    }
    NSClipView *contentView = [scrollView contentView];
    
    // get the origin of the NSClipView of the scroll view that
    // we're watching
    NSPoint changedBoundsOrigin = [changedContentView documentVisibleRect].origin;;
    
    // get our current origin
    NSPoint curOffset = [contentView bounds].origin;
    NSPoint newOffset = curOffset;
    
    // scrolling is synchronized in the vertical plane
    // so only modify the y component of the offset
    newOffset.y = changedBoundsOrigin.y;
    
    // if our synced position is different from our current
    // position, reposition our content view
    if (!NSEqualPoints(curOffset, changedBoundsOrigin))
    {
        // note that a scroll view watching this one will
        // get notified here
        [contentView scrollToPoint:newOffset];
        // we have to tell the NSScrollView to update its
        // scrollers
        [scrollView reflectScrolledClipView:contentView];
    }
}

- (void)stopSynchronizing {
    {
        NSClipView* synchronizedContentView = [self.outlineScrollView contentView];
        
        // remove any existing notification registration
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSViewBoundsDidChangeNotification
                                                      object:synchronizedContentView];
    }
    {
        NSClipView* synchronizedContentView = [self.tableScrollView contentView];
        
        // remove any existing notification registration
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSViewBoundsDidChangeNotification
                                                      object:synchronizedContentView];
    }
}

@end
