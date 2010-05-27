//
//  TestDataImporter.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/27.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "TestDataImporter.h"
#import "CiderCoreData.h"
#import "Day.h"


@interface TestDataImporter(IRKPrivate)

- (void)createDays;

@end


@implementation TestDataImporter

- (void)import
{
    [self clearAllData];
}


- (void)createDays
{
    Day *day = nil;
    
    int i;
    for (i = 27; i <= 29; i++) {
        Day *day = [Day create];
        day.date = [NSDate dateWithYear:2010 month:8 day:i hour:0 minute:0 second:0];
    }
    [day.managedObjectContext save:NULL];
}

@end
