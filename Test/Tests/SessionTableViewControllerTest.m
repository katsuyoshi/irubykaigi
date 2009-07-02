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


- (void)testCount
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
