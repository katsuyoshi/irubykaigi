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
    [document setValue:[NSNumber numberWithBool:NO] forKey:@"imported"];
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
    [document import];
    
    // 数の確認
    ASSERT_EQUAL_INT(3, [[document days] count]);
    ASSERT_EQUAL_INT(3, [[document rooms] count]);
    ASSERT_EQUAL_INT(75, [[document sessions] count]);
    
    // 検証
    for (NSManagedObject *eo in [document days]) {
        ASSERT([eo validateForInsert:NULL]);
    }
    for (NSManagedObject *eo in [document rooms]) {
        ASSERT([eo validateForInsert:NULL]);
    }
    for (NSManagedObject *eo in [document sessions]) {
        ASSERT([eo validateForInsert:NULL]);
        if (![[eo valueForKey:@"break"] boolValue]) {
            ASSERT_NOT_NIL([eo valueForKeyPath:@"room.name"]);
            ASSERT_NOT_NIL([eo valueForKeyPath:@"room.floor"]);
        }
    }
    
    // 日付オーダーの確認
    ASSERT_EQUAL([Document dateFromString:@"2009-7-17"], [[[document days] objectAtIndex:0] valueForKey:@"date"]);
    ASSERT_EQUAL([Document dateFromString:@"2009-7-18"], [[[document days] objectAtIndex:1] valueForKey:@"date"]);
    ASSERT_EQUAL([Document dateFromString:@"2009-7-19"], [[[document days] objectAtIndex:2] valueForKey:@"date"]);
}

- (void)testImportLightningTalks
{
    [document import];    
    NSArray *lightningTalks = [document lightningTalks];
    ASSERT_EQUAL_INT(22, [lightningTalks count]);
    ASSERT_EQUAL(@"一橋記念講堂", [[lightningTalks objectAtIndex:0] valueForKeyPath:@"room.name"]);
}

- (void)testSelectedDay
{
    document.selectedDay = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDate *day = [NSDate dateWithTimeIntervalSince1970:0];
    document.selectedDay = day;
    ASSERT_EQUAL(day, document.selectedDay);
}

#pragma mark 設定毎のURLのテスト

#if 0   // 日本語環境にしてテスト

- (void)testDefaultUrl
{
    [document setValue:[NSNumber numberWithBool:NO] forKey:@"japaneseContents"];
    ASSERT_EQUAL(@"http://iphone.itosoft.com/irubykaigi2009/Japanese.lproj/session_info.csv", [document sessionInfoUrl]);
    ASSERT_EQUAL(@"http://iphone.itosoft.com/irubykaigi2009/Japanese.lproj/lightning_talks_info.csv", [document lightningTalksInfoUrl]);
    ASSERT_EQUAL(@"http://files.me.com/gutskun/crfxcr", [document subSessionInfoUrl]);
    ASSERT_EQUAL(@"http://files.me.com/gutskun/y3njc7", [document subLightningTalksInfoUrl]);
}

- (void)testJapaneseUrl
{
    [document setValue:[NSNumber numberWithBool:YES] forKey:@"japaneseContents"];
    ASSERT_EQUAL(@"http://iphone.itosoft.com/irubykaigi2009/Japanese.lproj/session_info.csv", [document sessionInfoUrl]);
    ASSERT_EQUAL(@"http://iphone.itosoft.com/irubykaigi2009/Japanese.lproj/lightning_talks_info.csv", [document lightningTalksInfoUrl]);
    ASSERT_EQUAL(@"http://files.me.com/gutskun/crfxcr", [document subSessionInfoUrl]);
    ASSERT_EQUAL(@"http://files.me.com/gutskun/y3njc7", [document subLightningTalksInfoUrl]);
}


#else   // 英語環境でテスト

- (void)testDefaultUrl
{
    [document setValue:[NSNumber numberWithBool:NO] forKey:@"japaneseContents"];
    ASSERT_EQUAL(@"http://iphone.itosoft.com/irubykaigi2009/English.lproj/session_info.csv", [document sessionInfoUrl]);
    ASSERT_EQUAL(@"http://iphone.itosoft.com/irubykaigi2009/English.lproj/lightning_talks_info.csv", [document lightningTalksInfoUrl]);
    ASSERT_EQUAL(@"http://files.me.com/gutskun/abbuj1", [document subSessionInfoUrl]);
    ASSERT_EQUAL(@"http://files.me.com/gutskun/fespqk", [document subLightningTalksInfoUrl]);
}

- (void)testJapaneseUrl
{
    [document setValue:[NSNumber numberWithBool:YES] forKey:@"japaneseContents"];
    ASSERT_EQUAL(@"http://iphone.itosoft.com/irubykaigi2009/Japanese.lproj/session_info.csv", [document sessionInfoUrl]);
    ASSERT_EQUAL(@"http://iphone.itosoft.com/irubykaigi2009/Japanese.lproj/lightning_talks_info.csv", [document lightningTalksInfoUrl]);
    ASSERT_EQUAL(@"http://files.me.com/gutskun/crfxcr", [document subSessionInfoUrl]);
    ASSERT_EQUAL(@"http://files.me.com/gutskun/y3njc7", [document subLightningTalksInfoUrl]);
}

#endif

#pragma mark -
#pragma mark Option

// Uncomment it, if you want to test this class except other passed test classes.
//#define TESTS_ALWAYS
#ifdef TESTS_ALWAYS
- (void)testThisClassAlways { ASSERT_FAIL(@"fail always"); }
+ (BOOL)forceTestsAnyway { return YES; }
#endif

@end
