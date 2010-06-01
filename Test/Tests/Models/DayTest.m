//
//  DayTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/05/29.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "DayTest.h"
#import "Day.h"
#import "Region.h"


@implementation DayTest

- (void)setUp
{
    [super setUp];
    date = [[NSDate dateWithYear:2010 month:5 day:29 hour:0 minute:0 second:0] retain];
}

- (void)tearDown
{
    [super tearDown];
    [date release];
    date = nil;
}

- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Helpers


#pragma mark -
#pragma mark Tests

- (void)testDayWithDate
{
    Region *region = [Region japanese];
    Day *day = [Day dayWithDate:date region:region];
    ASSERT_EQUAL(date, day.date);
    ASSERT_SAME(day, [Day dayWithDate:date region:region]);
}

- (void)testValidate
{
    Day *day = [Day dayWithDate:date region:nil];
    // region未設定なので失敗
    ASSERT(![day validateForInsert:NULL]);
    ASSERT([day validateForDelete:NULL]);
    ASSERT(![day validateForUpdate:NULL]);
    
    day.region = [Region japanese];
    // region設定でOK
    ASSERT([day validateForInsert:NULL]);
    ASSERT([day validateForDelete:NULL]);
    ASSERT([day validateForUpdate:NULL]);
}

- (void)testTitle
{
    Day *day = [[Region japanese] dayForDate:date];
    ASSERT_EQUAL(@"5月29日", day.title);
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
