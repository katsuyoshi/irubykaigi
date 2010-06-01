//
//  SpeakerTest.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/06/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SpeakerTest.h"
#import "Region.h"
#import "Speaker.h"



@implementation SpeakerTest

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

- (void)testSpeakerWithCode
{
    Region *region = [Region japanese];
    Speaker *speaker = [Speaker speakerWithCode:@"201" region:region];
    
    ASSERT_NOT_NIL(speaker);
    ASSERT_EQUAL_INT(@"201", speaker.code);
    ASSERT_EQUAL(region, speaker.region);
    ASSERT_NOT_NIL(speaker.position);
    
    ASSERT_SAME(speaker, [Speaker speakerWithCode:@"201" region:region]);
}

- (void)testValidateForInsert
{
    Region *region = [Region japanese];
    Speaker *speaker = [Speaker speakerWithCode:@"201" region:region];

    speaker.name = nil;
    ASSERT(![speaker validateForInsert:NULL]);

    speaker.name = @"Katsuyoshi Ito";
    ASSERT([speaker validateForInsert:NULL]);
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
