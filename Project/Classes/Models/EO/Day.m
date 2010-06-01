// 
//  Day.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Day.h"

#import "Region.h"
#import "Session.h"
#import "CiderCoreData.h"


@implementation Day 

@dynamic date;
@dynamic region;
@dynamic sessions;


+ (Day *)dayWithDate:(NSDate *)date region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.predicate = [NSPredicate predicateWithFormat:@"region = %@ and date = %@", region, date];
    condition.managedObjectContext = context;
    Day *day = [Day find:condition error:NULL];
    if (day == nil) {
        day = [Day createWithManagedObjectContext:context];
        day.date = date;
        day.region = region;
    }
    return day;
}

+ (Day *)dayWithDate:(NSDate *)date region:(Region *)region
{
    return [self dayWithDate:date region:region inManagedObjectContext:DEFAULT_MANAGED_OBJECT_CONTEXT];
}


- (NSString *)title
{
    return [self.region.dateFormatter stringFromDate:self.date];
}

@end
