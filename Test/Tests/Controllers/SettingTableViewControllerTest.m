//
//  SettingTableViewControllerTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/09/09.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SettingTableViewControllerTest.h"

#import "UITableViewControllerTestHelper.h"


@implementation SettingTableViewControllerTest


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark about your view controller class

- (NSString *)viewControllerName
{
    return @"SettingTableViewController";
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


- (void)testCell
{
    ASSERT_EQUAL_INT(6, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(2, NUMBER_OF_ROWS_IN_SECTION(2));
    ASSERT_EQUAL_INT(5, NUMBER_OF_ROWS_IN_SECTION(3));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(4));
    ASSERT_EQUAL_INT(3, NUMBER_OF_ROWS_IN_SECTION(5));
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
