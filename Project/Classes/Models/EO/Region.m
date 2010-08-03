// 
//  Region.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Region.h"
#import "Day.h"
#import "CiderCoreData.h"
#import "Room.h"
#import "Speaker.h"


@implementation Region 

@dynamic identifier;
@dynamic days, rooms, speakers;


+ (Region *)regionWithIdentifier:(NSString *)identifier inManagedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    condition.managedObjectContext = context;
    
    Region *region = [Region find:condition error:NULL];
    if (region == nil) {
        region = [Region createWithManagedObjectContext:context];
        region.identifier = identifier;
    }
    return region;
}

+ (Region *)japaneseInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self regionWithIdentifier:@"ja_JP" inManagedObjectContext:context];
}

+ (Region *)englishInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self regionWithIdentifier:@"en_US" inManagedObjectContext:context];
}


+ (Region *)regionWithIdentifier:(NSString *)identifier
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
    return [self regionWithIdentifier:identifier inManagedObjectContext:context];
}

+ (Region *)japanese
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
    return [self japaneseInManagedObjectContext:context];
}

+ (Region *)english
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
    return [self englishInManagedObjectContext:context];
}



- (NSLocale *)locale
{
    return [[[NSLocale alloc] initWithLocaleIdentifier:self.identifier] autorelease];
}

- (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
    [formatter setLocale:self.locale];

    NSString *format = self.isJapanese ? @"M月d日" : @"MMMM d";
    [formatter setDateFormat:format];
    
    return formatter;
}

- (BOOL)isJapanese
{
    return [self.identifier isEqualToString:@"ja_JP"];
}


#pragma mark -
#pragma mark day

- (Day *)dayForDate:(NSDate *)date
{
    return [Day dayWithDate:date region:self inManagedObjectContext:self.managedObjectContext];
}


- (NSArray *)sortedDays
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"date"];
    return [[self.days allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark -
#pragma mark room

- (Room *)roomForCode:(NSString *)code
{
    return [Room roomWithCode:code region:self inManagedObjectContext:self.managedObjectContext];
}


#pragma mark -
#pragma mark speaker

- (Speaker *)speakerForCode:(NSString *)code
{
    return [Speaker speakerWithCode:code region:self inManagedObjectContext:self.managedObjectContext];
}



- (NSArray *)sessionsForDate:(NSDate *)date
{
    NSDate *today = [date beginningOfDay];
    NSSet *days = [self.days filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"date = %@", today]];
    Day *day = [days anyObject];
    
    if (day) {
        NSString *targetTime = [NSString stringWithFormat:@"%02d:%02d", [date hour], [date minute]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startAt <= %@ and endAt > %@", targetTime, targetTime];
        NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"room.position, position"];
        return [[[day.sessions filteredSetUsingPredicate:predicate] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    } else {
        return [NSArray array];
    }
}



@end
