//
//  RoomTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/06/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "RoomTest.h"
#import "Region.h"
#import "Room.h"
#import "CiderCoreData.h"


@implementation RoomTest

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

- (void)testRoomWithCode
{
    Region *region = [Region japanese];
    Room *room = [Room roomWithCode:@"201" region:region];
    
    ASSERT_NOT_NIL(room);
    ASSERT_EQUAL_INT(@"201", room.code);
    ASSERT_EQUAL(region, room.region);
    ASSERT_NOT_NIL(room.position);
    
    ASSERT_SAME(room, [Room roomWithCode:@"201" region:region]);
}

- (void)testValidateForInsert
{
    Region *region = [Region japanese];
    Room *room = [Room roomWithCode:@"201" region:region];

    room.floor = @"2F";
    room.name = nil;
    ASSERT(![room validateForInsert:NULL]);

    room.floor = nil;
    room.name = @"Hall";
    ASSERT(![room validateForInsert:NULL]);

    room.floor = @"2F";
    room.name = @"Hall";
    ASSERT([room validateForInsert:NULL]);
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
