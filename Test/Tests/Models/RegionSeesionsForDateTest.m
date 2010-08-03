//
//  RegionSeesionsForDateTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/08/03.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "RegionSeesionsForDateTest.h"
#import "Region.h"



@implementation RegionSeesionsForDateTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
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

- (void)testSessionsForDate
{
    Region *region = [Region japanese];
    
    NSDate *date = [NSDate dateWithYear:2010 month:8 day:27 hour:13 minute:00 second:00];
    ASSERT_EQUAL_INT(2, [[region sessionsForDate:date] count]);
    date = [NSDate dateWithYear:2010 month:8 day:27 hour:13 minute:59 second:59];
    ASSERT_EQUAL_INT(2, [[region sessionsForDate:date] count]);

    date = [NSDate dateWithYear:2010 month:8 day:27 hour:14 minute:00 second:00];
    ASSERT_EQUAL_INT(5, [[region sessionsForDate:date] count]);
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
