//
//  DocumentTest.m
//  RubiKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/06/25.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "DocumentTest.h"



@implementation DocumentTest

- (void)setUp
{
    [super setUp];
    document = [Document new];
}

- (void)tearDown
{
    [document.managedObjectContext rollback];
    [document release];
    [super tearDown];
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests

/** データ取込みのテスト. */
- (void)testImportFromCsvFile
{
    // 取込み
    [document importFromCsvFile:[[NSBundle mainBundle] pathForResource:@"session_info" ofType:@"csv"]];
    
    // 数の確認
    ASSERT_EQUAL_INT(3, [[document days] count]);
    ASSERT_EQUAL_INT(3, [[document rooms] count]);
    ASSERT_EQUAL_INT(72, [[document sessions] count]);
    
    // 検証
    for (NSManagedObject *eo in [document days]) {
        ASSERT([eo validateForInsert:NULL]);
    }
    for (NSManagedObject *eo in [document rooms]) {
        ASSERT([eo validateForInsert:NULL]);
    }
    for (NSManagedObject *eo in [document sessions]) {
        ASSERT([eo validateForInsert:NULL]);
    }
    
    // 日付オーダーの確認
    ASSERT_EQUAL([Document dateFromString:@"2009-7-17"], [[[document days] objectAtIndex:0] valueForKey:@"date"]);
    ASSERT_EQUAL([Document dateFromString:@"2009-7-18"], [[[document days] objectAtIndex:1] valueForKey:@"date"]);
    ASSERT_EQUAL([Document dateFromString:@"2009-7-19"], [[[document days] objectAtIndex:2] valueForKey:@"date"]);
}

- (void)testBreakAndParty
{
    
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
