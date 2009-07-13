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
    controller = [[SessionDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [[Document sharedDocument] import];
    sessions = [[[Document sharedDocument] sessions] retain];
    return controller;
}


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests


- (void)testCountAndCellWithRoom
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"code = '17H01'"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:0];
    [controller.tableView reloadData];
    
    ASSERT_EQUAL_INT(5, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(2));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(3));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(4));
    
    UITableViewCell *cell;
    
    cell = CELL_FOR_ROW_IN_SECTION(0, 0);
    ASSERT_EQUAL(@"Using Git and GitHub to Develop One Million Times Faster", cell.textLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);

    CELL_FOR_ROW_IN_SECTION(0, 1);
    cell = CELL_FOR_ROW_IN_SECTION(0, 1);
    ASSERT_EQUAL(@"Scott Chacon", cell.textLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);

    cell = CELL_FOR_ROW_IN_SECTION(0, 2);
    ASSERT_EQUAL(@"一橋記念講堂", cell.textLabel.text);
    ASSERT_EQUAL(@"2F", cell.detailTextLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);

    cell = CELL(0, 3);
    ASSERT_EQUAL(@"Git is the distributed version control system that is taking the software development world by storm.  GitHub is the Git social hosting website that is helping people share and collaborate on their code quickly and easily.  This talk will quickly introduce you to the Git tool and then demonstrate why it's features and structure can change your development life if you're still using Subversion or Perforce.  We will also cover how to use GitHub to take advantage of these features and new workflows that become available to collaborate on your open source projects.", cell.textLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);

    cell = CELL_FOR_ROW_IN_SECTION(0, 4);
    ASSERT_EQUAL(@"Scott Chacon is a Git evangelist and Ruby developer employed at Logical Awesome working on GitHub.com. He is the author of the upcoming Pro Git book from Apress publishing, the Git Internals Peepcode PDF as well as the maintainer of the Git homepage (git-scm.com) and the Git Community Book. Scott has presented at RailsConf, RubyConf, Scotland on Rails, a number of local groups and has done corporate training on Git across the country.", cell.textLabel.text);
    ASSERT_EQUAL_INT(UITableViewCellAccessoryNone, cell.accessoryType);
    ASSERT_EQUAL_INT(UITableViewCellSelectionStyleNone, cell.selectionStyle);


    ASSERT_EQUAL(@"タイトル", TITLE_FOR_SECTION(0));
    ASSERT_EQUAL(@"スピーカー", TITLE_FOR_SECTION(1));
    ASSERT_EQUAL(@"部屋", TITLE_FOR_SECTION(2));
    ASSERT_EQUAL(@"概要", TITLE_FOR_SECTION(3));
    ASSERT_EQUAL(@"スピーカープロフィール", TITLE_FOR_SECTION(4));
}

- (void)testTitle
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"code = '17H01'"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:0];
    [controller viewWillAppear:NO];

    ASSERT_EQUAL(@"13:30 - 14:30", controller.title);
}

- (void)testMultiSpeaker
{
    NSPredicate *predecate = [NSPredicate predicateWithFormat:@"code = '17S04'"];
    controller.session = [[sessions filteredArrayUsingPredicate:predecate] objectAtIndex:0];
    [controller.tableView reloadData];
    
    ASSERT_EQUAL_INT(5, NUMBER_OF_SECTIONS());
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(0));
    // スピーカーの人数になる
    ASSERT_EQUAL_INT(2, NUMBER_OF_ROWS_IN_SECTION(1));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(2));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(3));
    ASSERT_EQUAL_INT(1, NUMBER_OF_ROWS_IN_SECTION(4));
    

    UITableViewCell *cell;

    cell = CELL(0, 1);
    ASSERT_EQUAL(@"橋本和典", cell.textLabel.text);
    ASSERT_EQUAL(@"熊本大学", cell.detailTextLabel.text);
    cell = CELL(1, 1);
    ASSERT_EQUAL(@"木山真人", cell.textLabel.text);
    ASSERT_EQUAL(@"熊本大学", cell.detailTextLabel.text);
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
