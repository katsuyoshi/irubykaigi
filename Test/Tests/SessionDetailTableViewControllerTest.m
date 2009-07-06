//
//  SessionDetailTableViewControllerTest.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionDetailTableViewControllerTest.h"
#import "UITableViewControllerTestHelper.h"


@implementation SessionDetailTableViewControllerTest

@synthesize controller;

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [sessions release];
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
    controller = [[SessionDetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [[Document sharedDocument] importFromCsvFile:[[NSBundle mainBundle] pathForResource:@"session_info" ofType:@"csv"]];
    sessions = [[[Document sharedDocument] sessions] retain];
    return controller;
}


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests


- (void)testCountAndCellWithRoom
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"position = 0"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:0];
    [controller viewWillAppear:NO];
    
    ASSERT_EQUAL_INT(3, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(2, NUMBER_OF_ROWS_IN_SECTION(2));
    
    UITableViewCell *cell;
    
    cell = CELL(0, 0);
    ASSERT_EQUAL(@"Using Git and GitHub to Develop One Million Times Faster", cell.textLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);

    cell = CELL(0, 1);
    ASSERT_EQUAL(@"Scott Chacon (GitHub)", cell.textLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);

    cell = CELL(0, 2);
    ASSERT_EQUAL(@"一橋記念講堂", cell.textLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);
    cell = CELL(1, 2);
    ASSERT_EQUAL(@"2F", cell.textLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);


    ASSERT_EQUAL(@"タイトル", TITLE_FOR_SECTION(0));
    ASSERT_EQUAL(@"スピーカー", TITLE_FOR_SECTION(1));
    ASSERT_EQUAL(@"部屋", TITLE_FOR_SECTION(2));
}

- (void)testTitle
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"position = 0"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:0];
    [controller viewWillAppear:NO];

    ASSERT_EQUAL(@"13:30 - 14:30", controller.title);
}

- (void)testMultiSpeaker
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"position = 11"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:0];
    [controller viewWillAppear:NO];
    
    ASSERT_EQUAL_INT(3, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    // スピーカーの人数になる
    ASSERT_EQUAL_INT(2, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(2, NUMBER_OF_ROWS_IN_SECTION(2));
    

    UITableViewCell *cell;

    cell = CELL(0, 1);
    ASSERT_EQUAL(@"橋本和典（熊本大学）", cell.textLabel.text);
    cell = CELL(1, 1);
    ASSERT_EQUAL(@"木山真人（熊本大学）", cell.textLabel.text);
}    

- (void)testWithoutRoom
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"break = YES"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:0];
    [controller viewWillAppear:NO];
    
    ASSERT_EQUAL_INT(1, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
}

- (void)testWithoutSpeaker
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"break = YES"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:14];
    [controller viewWillAppear:NO];
    
    ASSERT_EQUAL_INT(0, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_NIL(TITLE_FOR_SECTION(1));
}

- (void)testBreak
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"break = YES"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:0];
    [controller viewWillAppear:NO];
    
    ASSERT_EQUAL_INT(1, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
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
