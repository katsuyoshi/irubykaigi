//
//  JsonCrudeImporterTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/07/31.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "JsonCrudeImporterTest.h"
#import "JsonCrudeImporter.h"
#import "Room.h"
#import "Region.h"
#import "Day.h"
#import "Session.h"



@implementation JsonCrudeImporterTest

- (void)setUp
{
    [super setUp];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JsonCrudeImporterTest" ofType:@"json"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [[[JsonCrudeImporter new] autorelease] importWithURL:url];
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

- (NSSet *)sessionsWithDay:(Day *)day roomName:(NSString *)roomName
{
    NSSet *sessions = day.sessions;
    Room *room = [[day.region.rooms filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", roomName]] anyObject];
    return [sessions filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"room = %@", room]];
}


#pragma mark -
#pragma mark Tests

- (void)testJaRooms
{
    Region *region = [Region japanese];
    ASSERT_EQUAL_INT(7, [region.rooms count]);
}

- (void)testJaSessions
{
    Region *region = [Region japanese];
    NSArray *days = region.sortedDays;
    
    Day *day = [days objectAtIndex:0];
    
    ASSERT_EQUAL_INT(10, [[self sessionsWithDay:day roomName:@"大ホール"] count]);
    ASSERT_EQUAL_INT(10, [[self sessionsWithDay:day roomName:@"中ホール200"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"202-B"] count]);
    ASSERT_EQUAL_INT(3, [[self sessionsWithDay:day roomName:@"202-A"] count]);
    ASSERT_EQUAL_INT(0, [[self sessionsWithDay:day roomName:@"201-B"] count]);
    ASSERT_EQUAL_INT(2, [[self sessionsWithDay:day roomName:@"201-A"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"ホワイエ"] count]);

    day = [days objectAtIndex:1];
    
    ASSERT_EQUAL_INT(10, [[self sessionsWithDay:day roomName:@"大ホール"] count]);
    ASSERT_EQUAL_INT(9, [[self sessionsWithDay:day roomName:@"中ホール200"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"202-B"] count]);
    ASSERT_EQUAL_INT(3, [[self sessionsWithDay:day roomName:@"202-A"] count]);
    ASSERT_EQUAL_INT(4, [[self sessionsWithDay:day roomName:@"201-B"] count]);
    ASSERT_EQUAL_INT(2, [[self sessionsWithDay:day roomName:@"201-A"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"ホワイエ"] count]);

    day = [days objectAtIndex:2];
    
    ASSERT_EQUAL_INT(12, [[self sessionsWithDay:day roomName:@"大ホール"] count]);
    ASSERT_EQUAL_INT(12, [[self sessionsWithDay:day roomName:@"中ホール200"] count]);
    ASSERT_EQUAL_INT(2, [[self sessionsWithDay:day roomName:@"202-B"] count]);
    ASSERT_EQUAL_INT(3, [[self sessionsWithDay:day roomName:@"202-A"] count]);
    ASSERT_EQUAL_INT(3, [[self sessionsWithDay:day roomName:@"201-B"] count]);
    ASSERT_EQUAL_INT(0, [[self sessionsWithDay:day roomName:@"201-A"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"ホワイエ"] count]);

}




- (void)testEnRooms
{
    Region *region = [Region english];
    ASSERT_EQUAL_INT(7, [region.rooms count]);
}

- (void)testEnSessions
{
    Region *region = [Region english];
    NSArray *days = region.sortedDays;
    
    Day *day = [days objectAtIndex:0];
    
    ASSERT_EQUAL_INT(10, [[self sessionsWithDay:day roomName:@"Main Convention Hall"] count]);
    ASSERT_EQUAL_INT(10, [[self sessionsWithDay:day roomName:@"Convention Hall 200"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"202-B"] count]);
    ASSERT_EQUAL_INT(3, [[self sessionsWithDay:day roomName:@"202-A"] count]);
    ASSERT_EQUAL_INT(0, [[self sessionsWithDay:day roomName:@"201-B"] count]);
    ASSERT_EQUAL_INT(2, [[self sessionsWithDay:day roomName:@"201-A"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"Foyer"] count]);

    day = [days objectAtIndex:1];
    
    ASSERT_EQUAL_INT(10, [[self sessionsWithDay:day roomName:@"Main Convention Hall"] count]);
    ASSERT_EQUAL_INT(9, [[self sessionsWithDay:day roomName:@"Convention Hall 200"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"202-B"] count]);
    ASSERT_EQUAL_INT(3, [[self sessionsWithDay:day roomName:@"202-A"] count]);
    ASSERT_EQUAL_INT(4, [[self sessionsWithDay:day roomName:@"201-B"] count]);
    ASSERT_EQUAL_INT(2, [[self sessionsWithDay:day roomName:@"201-A"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"Foyer"] count]);

    day = [days objectAtIndex:2];
    
    ASSERT_EQUAL_INT(12, [[self sessionsWithDay:day roomName:@"Main Convention Hall"] count]);
    ASSERT_EQUAL_INT(12, [[self sessionsWithDay:day roomName:@"Convention Hall 200"] count]);
    ASSERT_EQUAL_INT(2, [[self sessionsWithDay:day roomName:@"202-B"] count]);
    ASSERT_EQUAL_INT(3, [[self sessionsWithDay:day roomName:@"202-A"] count]);
    ASSERT_EQUAL_INT(3, [[self sessionsWithDay:day roomName:@"201-B"] count]);
    ASSERT_EQUAL_INT(0, [[self sessionsWithDay:day roomName:@"201-A"] count]);
    ASSERT_EQUAL_INT(1, [[self sessionsWithDay:day roomName:@"Foyer"] count]);

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
