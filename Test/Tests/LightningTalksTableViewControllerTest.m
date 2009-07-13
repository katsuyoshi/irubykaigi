//
//  LightningTalksTableViewControllerTest.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalksTableViewControllerTest.h"
#import "UITableViewControllerTestHelper.h"



@implementation LightningTalksTableViewControllerTest

@synthesize controller;

- (void)setUp
{
    document = [[Document sharedDocument] retain];
    [document import];
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
    controller = [[LightningTalksTableViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.session = [[[document lightningTalks] objectAtIndex:0] valueForKey:@"session"];
    return controller;
}


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests


- (void)testCountAndCell
{
    ASSERT_EQUAL_INT(1, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(11, NUMBER_OF_ROWS_IN_SECTION(0));
    
    UITableViewCell *cell;
    
    cell = CELL(0, 0);
    ASSERT_EQUAL(@"パターン、Wiki、XP、そしてRuby ", cell.textLabel.text);
    ASSERT_EQUAL(@"一橋記念講堂 江渡 浩一郎", cell.detailTextLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryDetailDisclosureButton, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);
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
