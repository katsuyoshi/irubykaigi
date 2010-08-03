//
//  RegionTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/05/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "RegionTest.h"
#import "Region.h"
#import "Day.h"
#import "CiderCoreData.h"
#import "Room.h"
#import "Speaker.h"
#import "Session.h"


@implementation RegionTest

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

- (void)testIsJapanese
{
    Region *region = [Region create];
    
    region.identifier = @"ja_JP";
    ASSERT(region.isJapanese);
    
    region.identifier = @"en_US";
    ASSERT(!region.isJapanese);
}

- (void)testDateFormatter
{
    Region *jaRegion = [Region create];
    jaRegion.identifier = @"ja_JP";
    
    Region *enRegion = [Region create];
    enRegion.identifier = @"en_US";
    
    NSDate *date = [NSDate dateWithYear:2010 month:5 day:28 hour:0 minute:0 second:0];

    ASSERT_EQUAL(@"5月28日", [jaRegion.dateFormatter stringFromDate:date]);
    ASSERT_EQUAL(@"May 28", [enRegion.dateFormatter stringFromDate:date]);
}

- (void)testJapanese
{
    Region *region = [Region japanese];
    ASSERT_EQUAL(@"ja_JP", region.identifier);
    ASSERT_SAME([Region japanese], region);
}

- (void)testEnglish
{
    Region *region = [Region english];
    ASSERT_EQUAL(@"en_US", region.identifier);
    ASSERT_SAME([Region english], region);
}

- (void)testValidate
{
    Region *region = [Region japanese];
    ASSERT([region validateForInsert:NULL]);
    ASSERT([region validateForDelete:NULL]);
    ASSERT([region validateForUpdate:NULL]);
}


- (void)testDelete
{
    Region *region = [Region japanese];
    [Day dayWithDate:[NSDate dateWithYear:2010 month:5 day:29 hour:0 minute:0 second:0] region:region];
    [Day dayWithDate:[NSDate dateWithYear:2010 month:5 day:29 hour:1 minute:0 second:0] region:region];
    [Day dayWithDate:[NSDate dateWithYear:2010 month:5 day:29 hour:2 minute:0 second:0] region:region];
    
    ASSERT_EQUAL_INT(1, [[Region findAll:nil error:NULL] count]);
    ASSERT_EQUAL_INT(3, [[Day findAll:nil error:NULL] count]);
    
    [region.managedObjectContext deleteObject:region];
    ASSERT_EQUAL_INT(0, [[Region findAll:nil error:NULL] count]);
    ASSERT_EQUAL_INT(0, [[Day findAll:nil error:NULL] count]);
}


- (void)testDateForDate
{
    Region *region = [Region japanese];
    NSDate *date = [NSDate dateWithYear:2010 month:5 day:29 hour:0 minute:0 second:0];
    Day *day = [region dayForDate:date];
    
    ASSERT_EQUAL(date, day.date);
    ASSERT_SAME(day, [region dayForDate:date]);
}

- (void)testRoomForCode
{
    Region *region = [Region japanese];
    Room *room = [region roomForCode:@"201"];
    
    ASSERT_EQUAL(@"201", room.code);
    ASSERT_SAME(room, [region roomForCode:@"201"]);
}

- (void)testSpeakerForCode
{
    Region *region = [Region japanese];
    Speaker *speaker = [region speakerForCode:@"Katsuyoshi Ito"];
    
    ASSERT_EQUAL(@"Katsuyoshi Ito", speaker.code);
    ASSERT_SAME(speaker, [region speakerForCode:@"Katsuyoshi Ito"]);
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
