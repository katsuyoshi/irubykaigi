//
//  JsonImporterVer3Test.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/08/19.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "JsonImporterVer3Test.h"
#import "JsonImporter.h"
#import "Room.h"
#import "Region.h"
#import "Day.h"
#import "Session.h"
#import "Speaker.h"



@implementation JsonImporterVer3Test

- (void)setUp
{
    [super setUp];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JsonImporterVer3Test" ofType:@"json"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [[[JsonImporter new] autorelease] importWithURL:url forceUpdate:YES];
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

- (void)testHiroyukiSimura
{
    Region *region = [Region japanese];
    Speaker *speaker;
    
    // case ,Inc.
    speaker = [self speakerForName:@"Hiroyuki Shimura" region:region];
    ASSERT_EQUAL_INT(2, [speaker.sessions count]);
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
