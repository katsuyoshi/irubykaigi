//
//  PresentSessionTableViewControllerTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/08/03.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "PresentSessionTableViewControllerTest.h"
#import "CiderCoreData.h"
#import "UITableViewControllerTestHelper.h"
#import "PresentSessionTableViewController.h"


@implementation PresentSessionTableViewControllerTest


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark about your view controller class

- (NSString *)viewControllerName
{
    return @"PresentSessionTableViewController";
}

/*
- (NSString *)viewControllerNibName
{
    // TODO: replace your nib file name.
    return nil;
}
*/

/*
- (UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}
*/
/*
- (BOOL)hasNavigationController
{
    return YES;
}
*/
/*
- (BOOL)hasTabBarController
{
    return YES;
}
*/

#pragma mark -
#pragma mark setUp/tearDown

/*
 // prepare datas
 - (NSNumber *)willSetUp
 {
 return [super willSetUp];
 }
 */

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

/*
 // release datas
 - (NSNumber *)didTearDown
 {
 return [super didTearDown];
 }
 */

#pragma mark -
#pragma mark Tests


- (void)testSetDateText
{
    NSDate *date = [NSDate dateWithYear:2010 month:8 day:3 hour:10 minute:45 second:0];
    PresentSessionTableViewController *controller = (PresentSessionTableViewController *)self.tableViewController;
    [controller setNextDateOf:date];
    ASSERT_EQUAL([NSDate dateWithYear:2010 month:8 day:3 hour:11 minute:0 second:0], controller.date);

    date = [NSDate dateWithYear:2010 month:8 day:3 hour:10 minute:00 second:0];
    [controller setNextDateOf:date];
    ASSERT_EQUAL([NSDate dateWithYear:2010 month:8 day:3 hour:10 minute:30 second:0], [controller date]);

    date = [NSDate dateWithYear:2010 month:8 day:3 hour:10 minute:29 second:59];
    [controller setNextDateOf:date];
    ASSERT_EQUAL([NSDate dateWithYear:2010 month:8 day:3 hour:10 minute:30 second:0], [controller date]);
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
