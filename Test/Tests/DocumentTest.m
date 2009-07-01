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

- (void)testImportFromCsvFile
{
    [document importFromCsvFile:[[NSBundle mainBundle] pathForResource:@"session_info" ofType:@"csv"]];
    ASSERT_EQUAL_INT(3, [[document days] count]);
    ASSERT_EQUAL_INT(72, [[document sessions] count]);
    
    for (NSManagedObject *eo in [document days]) {
        ASSERT([eo validateForInsert:NULL]);
    }
    for (NSManagedObject *eo in [document sessions]) {
        ASSERT([eo validateForInsert:NULL]);
    }
    
    ASSERT_EQUAL([Document dateFromString:@"2009-7-17"], [[[document days] objectAtIndex:0] valueForKey:@"date"]);
    ASSERT_EQUAL([Document dateFromString:@"2009-7-18"], [[[document days] objectAtIndex:1] valueForKey:@"date"]);
    ASSERT_EQUAL([Document dateFromString:@"2009-7-19"], [[[document days] objectAtIndex:2] valueForKey:@"date"]);
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
