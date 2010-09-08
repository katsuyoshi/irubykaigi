//
//  SessionDetailedTableViewControllerTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/09/08.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionDetailedTableViewControllerTest.h"
#import "CiderCoreData.h"
#import "UITableViewControllerTestHelper.h"
#import "Session.h"
#import "Region.h"
#import "SessionDetailedTableViewController.h"


@implementation SessionDetailedTableViewControllerTest


#pragma mark -
#pragma mark Helpers

- (SessionDetailedTableViewController *)sessionDetailedTableViewController
{
    return (SessionDetailedTableViewController *)self.tableViewController;
}

- (Session *)sessionWithCode:(NSString *)code japanese:(BOOL)japanese
{
    Region *region = japanese ? [Region japanese] : [Region english];
    return [Session findWithPredicate:[NSPredicate predicateWithFormat:@"day.region = %@ and code = %@", region, code] error:NULL];
}

#pragma mark -
#pragma mark about your view controller class

- (NSString *)viewControllerName
{
    return @"SessionDetailedTableViewController";
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


- (void)testOpening
{
    self.sessionDetailedTableViewController.detailedObject = [self sessionWithCode:@"1" japanese:YES];
    [self .sessionDetailedTableViewController reloadData];
    
    ASSERT_EQUAL_INT(4, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(2));
    ASSERT_EQUAL_INT(2, NUMBER_OF_ROWS_IN_SECTION(3));
    
    UITableViewCell *cell;
    cell = CELL_FOR_ROW_IN_SECTION(0, 3);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleBlue, cell.selectionStyle);
}

- (void)testJpmobileOnRails3
{
    self.sessionDetailedTableViewController.detailedObject = [self sessionWithCode:@"3" japanese:YES];
    [self .sessionDetailedTableViewController reloadData];
    
    ASSERT_EQUAL_INT(6, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(2));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(3));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(4));
    ASSERT_EQUAL_INT(2, NUMBER_OF_ROWS_IN_SECTION(5));

    UITableViewCell *cell;
    cell = CELL_FOR_ROW_IN_SECTION(0, 5);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleBlue, cell.selectionStyle);
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
