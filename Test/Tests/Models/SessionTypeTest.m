//
//  SessionTypeTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/05/31.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTypeTest.h"
#import "SessionType.h"
#import "Region.h"


@implementation SessionTypeTest

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

- (void)testSessionTypeWithCode
{
    Region *region = [Region japanese];
    SessionType *type = [SessionType sessionTypeWithCode:SessionTypeCodeNormal region:region];
    
    ASSERT_NOT_NIL(type);
    ASSERT_EQUAL_INT(SessionTypeCodeNormal, [type.code intValue]);
    ASSERT_EQUAL(region, type.region);
    
    ASSERT_SAME(type, [SessionType sessionTypeWithCode:SessionTypeCodeNormal region:region]);
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
