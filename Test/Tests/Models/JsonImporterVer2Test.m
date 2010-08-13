//
//  JsonImporterVer2Test.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/08/13.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "JsonImporterVer2Test.h"
#import "JsonImporter.h"
#import "Room.h"
#import "Region.h"
#import "Day.h"
#import "Session.h"
#import "Speaker.h"


@implementation JsonImporterVer2Test

- (void)setUp
{
    [super setUp];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JsonImporterVer2Test" ofType:@"json"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [[[JsonImporter new] autorelease] importWithURL:url forceUpdate:YES];
}

- (Speaker *)speakerForName:(NSString *)name region:(Region *)region
{
    return [[region.speakers filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", name]] anyObject];
}

- (void)testBelongingWithIncOrLtd
{
    Region *region = [Region japanese];
    Speaker *speaker;
    NSSet *belongings;
    
    // case ,Inc.
    speaker = [self speakerForName:@"SHIBATA Hiroshi" region:region];
    belongings = speaker.belongings;
    ASSERT_EQUAL_INT(3, [belongings count]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"Eiwa System Management,Inc."]);
    
    // case ,Ltd.
    speaker = [self speakerForName:@"Toshiyuki Terashita" region:region];
    belongings = speaker.belongings;
    ASSERT_EQUAL_INT(1, [belongings count]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"RICOH IT SOLUTIONS Co.,Ltd."]);
}

- (void)testCombinedBelonging
{
    Region *region = [Region japanese];
    Speaker *speaker;
    NSSet *belongings;
    
    // case ,Inc.
    speaker = [self speakerForName:@"jugyo" region:region];
    belongings = speaker.belongings;
    ASSERT_EQUAL_INT(2, [belongings count]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"Everyleaf Corporation"]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"Termtter Dev Team"]);
}

- (void)testXibbar
{
    Region *region = [Region japanese];
    Speaker *speaker;
    NSSet *belongings;
    
    // case ,Inc.
    speaker = [self speakerForName:@"Takeyuki FUJIOKA" region:region];
    belongings = speaker.belongings;
    ASSERT_EQUAL_INT(3, [belongings count]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"xibbar"]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"Rabbix corporation"]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"Nihon Ruby no kai"]);
}

- (void)testTed
{
    Region *region = [Region japanese];
    Speaker *speaker;
    NSSet *belongings;
    
    // case ,Inc.
    speaker = [self speakerForName:@"Ted Han" region:region];
    belongings = speaker.belongings;
    ASSERT_EQUAL_INT(1, [belongings count]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"%w(Videojuicer DataMapper)"]);
}

- (void)testMakoto
{
    Region *region = [Region japanese];
    Speaker *speaker;
    NSSet *belongings;
    
    // case ,Inc.
    speaker = [self speakerForName:@"Makoto Inoue" region:region];
    belongings = speaker.belongings;
    ASSERT_EQUAL_INT(1, [belongings count]);
    ASSERT([[belongings valueForKey:@"title"] containsObject:@"New Bamboo (London,UK)"]);
}

@end
