//
//  SessionTableViewControllerWithNextDayTest.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewControllerWithNextDayTest.h"



@implementation SessionTableViewControllerWithNextDayTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)dealloc
{
    [super dealloc];
}

- (UITableViewController *)tableViewController
{
    // this controller will be tested.
    // TODO: replace your view controller
    controller = [[SessionTableViewController alloc] initWithStyle:UITableViewStylePlain];
    NSArray *days = [document days];
    controller.day = [[days objectAtIndex:0] valueForKey:@"date"];
    controller.nextDay = [[days objectAtIndex:1] valueForKey:@"date"];
    return controller;
}

#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests

- (void)testRightItemButton
{
    [controller viewDidLoad];
    UIBarButtonItem *buttonItem = controller.navigationItem.rightBarButtonItem;
    ASSERT_EQUAL(@"7月18日", buttonItem.title);
    ASSERT_EQUAL_INT(UIBarButtonItemStyleBordered, buttonItem.style);
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
