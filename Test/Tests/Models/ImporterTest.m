//
//  ImporterTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/05/31.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "ImporterTest.h"
#import "Region.h"
#import "Importer.h"


@implementation ImporterTest

- (void)setUp
{
    [super setUp];
    importer = [Importer new];
}

- (void)tearDown
{
    [importer release];    

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




#pragma mark -
#pragma mark Option

// Uncomment it, if you want to test this class except other passed test classes.
//#define TESTS_ALWAYS
#ifdef TESTS_ALWAYS
- (void)testThisClassAlways { ASSERT_FAIL(@"fail always"); }
+ (BOOL)forceTestsAnyway { return YES; }
#endif

@end
