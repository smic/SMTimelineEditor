//
//  SMAppDelegate.m
//  SMTimelineEditor
//
//  Created by Stephan Michels on 26.09.12.
//  Copyright (c) 2012 Stephan Michels. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMElement.h"
#import "SMTimeline.h"
#import "SMTimelineSegment.h"


static NSString * const SMElementPropertyX = @"SMElementPropertyX";
static NSString * const SMElementPropertyY = @"SMElementPropertyY";
static NSString * const SMElementPropertyWidth = @"SMElementPropertyWidth";
static NSString * const SMElementPropertyHeight = @"SMElementPropertyHeight";

@interface SMAppDelegate ()

@property (weak) IBOutlet NSScrollView *outlineScrollView;
@property (weak) IBOutlet NSOutlineView *outline;
@property (weak) IBOutlet NSScrollView *tableScrollView;
@property (weak) IBOutlet NSTableView *table;

@property (strong, nonatomic) NSArray *elements;
@property (strong, nonatomic) NSMutableIndexSet *expandedElements;

@end

@implementation SMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self startSynchronizing];
    
    self.tableScrollView.hasHorizontalRuler = YES;
//    self.tableScrollView.horizontalRulerView.reservedThicknessForAccessoryView = 0.0f;
    self.tableScrollView.horizontalRulerView.reservedThicknessForMarkers = 0.0f;
    self.tableScrollView.rulersVisible = YES;
    NSLog(@"height=%f", self.tableScrollView.horizontalRulerView.frame.size.height);
    
    NSLog(@"Outline Scroll View: %p", self.outlineScrollView);
    NSLog(@"Table Scroll View: %p", self.tableScrollView);
    
//    [self.table sizeToFit];
    
    NSMutableArray *elements = [NSMutableArray arrayWithCapacity:3];
    
    SMElement *element1 = [[SMElement alloc] init];
    element1.name = @"Element 1";
    [elements addObject:element1];
    
    SMTimeline *timeline1 = [[SMTimeline alloc] init];
    timeline1.propertyName = @"X";
    
    SMTimelineSegment *segment1 = [[SMTimelineSegment alloc] init];
    segment1.position = 100;
    segment1.duration = 100;
    
    SMTimelineSegment *segment2 = [[SMTimelineSegment alloc] init];
    segment2.position = 250;
    segment2.duration = 100;
    
    timeline1.segments = @[segment1, segment2];
    
    SMTimeline *timeline2 = [[SMTimeline alloc] init];
    timeline2.propertyName = @"Y";
    
    SMTimelineSegment *segment3 = [[SMTimelineSegment alloc] init];
    segment3.position = 100;
    segment3.duration = 100;
    
    SMTimelineSegment *segment4 = [[SMTimelineSegment alloc] init];
    segment4.position = 250;
    segment4.duration = 100;
    
    timeline2.segments = @[segment3, segment4];
    
    element1.timelines = @[timeline1, timeline2];
    
    SMElement *element2 = [[SMElement alloc] init];
    element2.name = @"Element 2";
    [elements addObject:element2];
    
    SMElement *element3 = [[SMElement alloc] init];
    element3.name = @"Element 3";
    [elements addObject:element3];
    
    self.elements = elements;
    
    self.expandedElements = [NSMutableIndexSet indexSet];
    
    [self.outline reloadData];
    [self.table reloadData];
}

#pragma mark - Private methods

- (NSUInteger)numberOfRows {
    NSUInteger numberOfRows = 0;
    for (NSInteger elementIndex = [self.elements count] - 1; elementIndex >= 0; elementIndex--) {
        numberOfRows++;
        if ([self.expandedElements containsIndex:elementIndex]) {
            SMElement *element = [self.elements objectAtIndex:elementIndex];
            numberOfRows += [element.timelines count];
        }
    }
    return numberOfRows;
}

- (NSIndexPath *)indexPathForRow:(NSUInteger)rowIndex {
    NSUInteger elementIndex = 0;
    do {
        NSUInteger numberOfRows = 1;
        if ([self.expandedElements containsIndex:elementIndex]) {
            SMElement *element = [self.elements objectAtIndex:elementIndex];
            numberOfRows += [element.timelines count];
        }
        
        if (rowIndex < numberOfRows) {
            if (rowIndex == 0) {
                return [NSIndexPath indexPathWithIndex:elementIndex];
            } else {
                NSUInteger indexes[] = {elementIndex, rowIndex - 1};
                return [NSIndexPath indexPathWithIndexes:indexes length:2];
            }
        }
        
        rowIndex -= numberOfRows;
        elementIndex ++;
    } while (YES);
    return nil;
}

- (NSUInteger)rowForIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert(indexPath.length == 1 || indexPath.length == 2);
    NSUInteger elementIndex = [indexPath indexAtPosition:0];
    NSUInteger rowIndex = 0;
    for (NSUInteger actualElementIndex = 0; actualElementIndex < [self.elements count]; actualElementIndex++) {
        if (actualElementIndex == elementIndex) {
            if ([indexPath length] == 2) {
                return rowIndex + [indexPath indexAtPosition:1];
            } else {
                return rowIndex;
            }
        }
        rowIndex++;
        if ([self.expandedElements containsIndex:actualElementIndex]) {
            SMElement *element = [self.elements objectAtIndex:actualElementIndex];
            rowIndex += [element.timelines count];
        }
    }
    return NSNotFound;
}

#pragma mark - Outline data source

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    if (!item) {
        return [self.elements count];
    }
    if ([item isKindOfClass:[SMElement class]]) {
        SMElement *element = (SMElement *)item;
        return [element.timelines count];
    }
    return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (!item) {
        return YES;
    }
    if ([item isKindOfClass:[SMElement class]]) {
        SMElement *element = (SMElement *)item;
        return [element.timelines count] > 0;
    }
    return NO;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        return [self.elements objectAtIndex:index];
    }
    if ([item isKindOfClass:[SMElement class]]) {
        SMElement *element = (SMElement *)item;
        return [element.timelines objectAtIndex:index];
//        switch (index) {
//            case 0:
//                return SMElementPropertyX;
//                break;
//            case 1:
//                return SMElementPropertyY;
//                break;
//            case 2:
//                return SMElementPropertyWidth;
//                break;
//            case 3:
//                return SMElementPropertyHeight;
//                break;
//                
//            default:
//                break;
//        }
    }
    return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    if ([item isKindOfClass:[SMElement class]]) {
        SMElement *element = item;
        return element.name;
    }
    if ([item isKindOfClass:[SMTimeline class]]) {
        SMTimeline *timeline = item;
        return timeline.propertyName;
    }
//
//    if (item == SMElementPropertyX) {
//        return @"Property X";
//    }
//    if (item == SMElementPropertyY) {
//        return @"Property Y";
//    }
//    if (item == SMElementPropertyWidth) {
//        return @"Property Width";
//    }
//    if (item == SMElementPropertyHeight) {
//        return @"Property Height";
//    }
    return nil;
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification {
    NSLog(@"Did expand: %@", notification);
//    [self.table reloadData];
    SMElement *element = [notification.userInfo objectForKey:@"NSObject"];
    NSUInteger elementIndex = [self.elements indexOfObject:element];
    NSUInteger rowIndex = [self rowForIndexPath:[NSIndexPath indexPathWithIndex:elementIndex]];
    
    [self.table beginUpdates];
    
    [self.expandedElements addIndex:elementIndex];
    
    [self.table insertRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(rowIndex + 1, 4)] withAnimation:NSTableViewAnimationSlideDown];
    [self.table endUpdates];
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification {
    NSLog(@"Did collapse: %@", notification);
//    [self.table reloadData];
    SMElement *element = [notification.userInfo objectForKey:@"NSObject"];
    NSUInteger elementIndex = [self.elements indexOfObject:element];
    NSUInteger rowIndex = [self rowForIndexPath:[NSIndexPath indexPathWithIndex:elementIndex]];
    
    [self.table beginUpdates];
    
    [self.expandedElements removeIndex:elementIndex];
    
    [self.table removeRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(rowIndex + 1, 4)] withAnimation:NSTableViewAnimationSlideUp];
    [self.table endUpdates];
}

- (void)outlineViewSelectionIsChanging:(NSNotification *)notification {
    NSLog(@"Selection Did change: %@", notification);
    NSIndexSet *selectedRowIndexes = self.outline.selectedRowIndexes;
    [self.table selectRowIndexes:selectedRowIndexes byExtendingSelection:NO];
}

#pragma mark - Table data source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self numberOfRows];
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
    
    NSIndexPath *indexPath = [self indexPathForRow:rowIndex];
    if ([indexPath length] == 1) {
        NSUInteger elementIndex = [indexPath indexAtPosition:0];
//        SMElement *element = [self.elements objectAtIndex:elementIndex];
//        return element.name;
        return nil;
    }
    if ([indexPath length] == 2) {
        NSUInteger elementIndex = [indexPath indexAtPosition:0];
        NSUInteger propertyIndex = [indexPath indexAtPosition:1];
        SMElement *element = [self.elements objectAtIndex:elementIndex];
        return [element.timelines objectAtIndex:propertyIndex];
//        switch (propertyIndex) {
//            case 0:
//                return @"X=1";
//                break;
//            case 1:
//                return @"Y=2";
//                break;
//            case 2:
//                return @"Width=3";
//                break;
//            case 3:
//                return @"Height=4";
//                break;
//                
//            default:
//                break;
//        }
    }

    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView sizeToFitWidthOfColumn:(NSInteger)column {
    NSLog(@"sizeToFitWidthOfColumn: %li", column);
    return 2000.0f;
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification {
    NSLog(@"Selection Did change: %@", notification);
    NSIndexSet *selectedRowIndexes = self.table.selectedRowIndexes;
    [self.outline selectRowIndexes:selectedRowIndexes byExtendingSelection:NO];
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
    if (!NSEqualPoints(curOffset, newOffset))
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
