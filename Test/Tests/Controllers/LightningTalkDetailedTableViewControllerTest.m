//
//  LightningTalkDetailedTableViewControllerTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/09/08.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalkDetailedTableViewControllerTest.h"
#import "CiderCoreData.h"
#import "UITableViewControllerTestHelper.h"
#import "LightningTalk.h"
#import "Region.h"
#import "LightningTalkDetailedTableViewController.h"


@implementation LightningTalkDetailedTableViewControllerTest


#pragma mark -
#pragma mark Helpers

- (LightningTalkDetailedTableViewController *)lightningTalkDetailedTableViewController
{
    return (LightningTalkDetailedTableViewController *)self.tableViewController;
}

- (LightningTalk *)lightningTalkWithParentCode:(NSString *)code position:(NSNumber *)position japanese:(BOOL)japanese
{
    Region *region = japanese ? [Region japanese] : [Region english];
    return [LightningTalk findWithPredicate:[NSPredicate predicateWithFormat:@"session.day.region = %@ and session.code = %@ and position = %@", region, code, position] error:NULL];
}


#pragma mark -
#pragma mark about your view controller class

- (NSString *)viewControllerName
{
    return @"LightningTalkDetailedTableViewController";
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


- (void)testARToolKit
{
    self.lightningTalkDetailedTableViewController.detailedObject = [self lightningTalkWithParentCode:@"38" position:[NSNumber numberWithInt:1] japanese:YES];
    [self .lightningTalkDetailedTableViewController reloadData];
    
    ASSERT_EQUAL_INT(5, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(2));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(3));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(4));
    
    UITableViewCell *cell;
    cell = CELL_FOR_ROW_IN_SECTION(0, 4);
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
