//
//  TableViewControllerBaseTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/09/08.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "TableViewControllerBaseTest.h"
#import "CiderCoreData.h"
#import "UITableViewControllerTestHelper.h"
#import "JsonImporter.h"
#import "ArchiveJsonImporter.h"


@implementation TableViewControllerBaseTest


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark about your view controller class

/*
- (NSString *)viewControllerName
{
    // TODO: replace your table view controller's name
    return nil;
}
*/
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

 // prepare datas
 - (NSNumber *)willSetUp
{
    NSString *path;
    NSURL *url;

    path = [[NSBundle mainBundle] pathForResource:@"JsonImporterVer3Test" ofType:@"json"];
    url = [NSURL fileURLWithPath:path];
    [[[JsonImporter new] autorelease] importWithURL:url forceUpdate:YES];

    path = [[NSBundle mainBundle] pathForResource:@"ArchiveJsonImporter" ofType:@"json"];
    url = [NSURL fileURLWithPath:path];
    [[ArchiveJsonImporter sharedArchiveJsonImporter] importWithURL:url forceUpdate:YES];
    return [super willSetUp];
}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

 // release datas
 - (NSNumber *)didTearDown
{
    [NSManagedObjectContext clearDefaultManagedObjectContextAndDeleteStoreFile];
    return [super didTearDown];
}

#pragma mark -
#pragma mark Tests


#pragma mark -
#pragma mark Option

// Uncomment it, if you want to test this class except other passed test classes.
//#define TESTS_ALWAYS
#ifdef TESTS_ALWAYS
- (void)testThisClassAlways { ASSERT_FAIL(@"fail always"); }
+ (BOOL)forceTestsAnyway { return YES; }
#endif

@end
