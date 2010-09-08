//
//  RoomTableViewControllerTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/09/09.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "RoomTableViewControllerTest.h"

#import "UITableViewControllerTestHelper.h"


@implementation RoomTableViewControllerTest


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark about your view controller class

- (NSString *)viewControllerName
{
    return @"RoomTableViewController";
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


- (void)testNumberOfSection
{
    // 現在のセッションは終了して不要になったので1になる
    ASSERT_EQUAL_INT(1, NUMBER_OF_SECTIONS());
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
