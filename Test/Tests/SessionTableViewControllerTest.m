//
//  SessionTableViewControllerTest.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/03.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewControllerTest.h"
#import "Document.h"
#import "UITableViewControllerTestHelper.h"


@implementation SessionTableViewControllerTest

@synthesize controller;


- (void)setUp
{
    document = [[Document sharedDocument] retain];
    [document importFromCsvFile:[[NSBundle mainBundle] pathForResource:@"session_info" ofType:@"csv"]];
    [super setUp];
}

- (void)tearDown
{
    [document.managedObjectContext rollback];
    [document release];
    [controller release];
    controller = nil;
    [super tearDown];
}

- (void)dealloc
{
    [controller release];
    [super dealloc];
}

- (UITableViewController *)tableViewController
{
    // this controller will be tested.
    // TODO: replace your view controller
    controller = [[SessionTableViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.day = [[document days] objectAtIndex:0];
    return controller;
}


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests


- (void)testCountAndCell
{
    ASSERT_EQUAL_INT(8, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(7, NUMBER_OF_ROWS_IN_SECTION(2));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(3));
    ASSERT_EQUAL_INT(3, NUMBER_OF_ROWS_IN_SECTION(4));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(5));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(6));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(7));
    
    UITableViewCell *cell;
    
    cell = CELL(0, 0);
    ASSERT_EQUAL(@"Using Git and GitHub to Develop One Million Times Faster", cell.textLabel.text);
    ASSERT_EQUAL(@"一橋記念講堂 Scott Chacon (GitHub)", cell.detailTextLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryDetailDisclosureButton, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);

    cell = CELL(0, 1);
    ASSERT_EQUAL(@"break", cell.textLabel.text);
    ASSERT_NIL(cell.detailTextLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);
}

- (void)testTitle
{
    ASSERT_EQUAL(@"7月17日", self.controller.title);
}


- (void)testRightItemButton
{
    ASSERT_NIL(controller.navigationItem.rightBarButtonItem);
}

#pragma mark -
#pragma mark Option

// Uncomment it, if you want to test this class except other passed test classes.
//#define TESTS_ALWAYS
#ifdef TESTS_ALWAYS
- (void)testThisClassAlways { ASSERT_FAIL(@"fail always"); }
+ (BOOL)forceTestsAnyway { return YES; }
#endif

@end
