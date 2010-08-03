//
//  JsonCrudeImporter.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/30.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "JsonCrudeImporter.h"
#import "JSON.h"
#import "CiderCoreData.h"
#import "Day.h"
#import "Region.h"
#import "Session.h"
#import "Speaker.h"
#import "Room.h"
#import "LightningTalk.h"


@interface JsonCrudeImporter(IRKPrivate)

- (void)parseTimeline:(id)object;
- (void)parseTimelineWithObject:(id)object region:(Region *)region;
- (void)parseRoomsWithObject:(id)object region:(Region *)region;
- (void)parseDaysWithObject:(id)object region:(Region *)region;
- (void)parseSessionsWithObject:(id)object region:(Region *)region;
- (void)parseSpeakersWithObject:(id)object region:(Region *)region;

- (Room *)roomForName:(NSString *)name region:(Region *)region;
- (Day *)dayForString:(NSString *)dayString region:(Region *)region;
- (SessionTypeCode)sessionTypeCodeForName:(NSString *)name;
- (Speaker *)speakerForName:(id)name region:(Region *)region;

@end


@implementation JsonCrudeImporter


- (void)import
{
    [self clearAllData];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"timetable" ofType:@"json"];
    [self importWithURL:[NSURL fileURLWithPath:path]];
}

- (void)importWithURL:(NSURL *)url
{
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
#ifdef DEBUG
    if (error) [error showErrorForUserDomains];
#endif
    SBJsonParser *parser = [[SBJsonParser new] autorelease];
    id object = [parser objectWithString:jsonString];

    NSManagedObjectContext *context = [[NSManagedObjectContext defaultManagedObjectContext] newManagedObjectContext];
    [self parseTimelineWithObject:[object valueForKey:@"ja"] region:[Region japaneseInManagedObjectContext:context]];
    [self parseTimelineWithObject:[object valueForKey:@"en"] region:[Region englishInManagedObjectContext:context]];
    
    [context save:&error];
#ifdef DEBUG
    if (error) [error showErrorForUserDomains];
#endif

    [context release];
}

- (void)parseTimelineWithObject:(id)object region:(Region *)region
{
    [self parseRoomsWithObject:[object valueForKey:@"rooms"] region:region];
    [self parseDaysWithObject:[object valueForKey:@"timetables"] region:region];
    [self parseSessionsWithObject:[object valueForKey:@"timetables"] region:region];
}

- (Room *)roomForName:(NSString *)name region:(Region *)region
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    Room *room = [[region.rooms filteredSetUsingPredicate:predicate] anyObject];
    if (room == nil) {
        room = [Room createWithManagedObjectContext:region.managedObjectContext];
        room.name = name;
        room.region = region;
        [room setListNumber];
        room.code = [room.position stringValue];
    }
    return room;
}

- (void)parseRoomsWithObject:(id)object region:(Region *)region
{
    for (NSString *name in object) {
        [self roomForName:name region:region];
    }
}

- (Day *)dayForString:(NSString *)dayString region:(Region *)region
{
    NSArray *elements = [dayString componentsSeparatedByString:@"/"];
    NSDate *date = [NSDate dateWithYear:[[elements objectAtIndex:0] intValue]
                                      month:[[elements objectAtIndex:1] intValue]
                                        day:[[elements objectAtIndex:2] intValue]
                                       hour:0 minute:0 second:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@", date];
    Day *day = [[region.days filteredSetUsingPredicate:predicate] anyObject];
    if (day == nil) {
        day = [Day createWithManagedObjectContext:region.managedObjectContext];
        day.date = date;
        day.region = region;
    }
    return day;
}

- (void)parseDaysWithObject:(id)object region:(Region *)region
{
    for (id dict in object) {
        [self dayForString:[dict valueForKey:@"day"] region:region];
    }
}

- (SessionTypeCode)sessionTypeCodeForName:(NSString *)name
{
    if ([name isEqualToString:@"break"]) {
        return SessionTypeCodeBreak;
    } else {
        return SessionTypeCodeNormal;
    }
}

- (void)parseSessionsWithObject:(id)object region:(Region *)region
{
    NSManagedObjectContext *context = region.managedObjectContext;
    for (id sessionsDict in object) {
        Day *day = [self dayForString:[sessionsDict valueForKey:@"day"] region:region];
        for (id dict in [sessionsDict valueForKey:@"sessions"]) {
            NSString *code = [NSString stringWithFormat:@"%@/%@/%@", [dict valueForKey:@"room"], [dict valueForKey:@"start_at"], [dict valueForKey:@"end_at"]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day.region = %@ and code = %@", region, code];
            Session *session = [Session findWithPredicate:predicate sortDescriptors:nil managedObjectContext:context error:NULL];
            if (session == nil) {
                session = [Session createWithManagedObjectContext:context];
                session.day = day;
                [session setListNumber];
                session.code = [NSString stringWithFormat:@"%@@%@", session.day.dayString, session.position];
                session.title = [dict valueForKey:@"title"];
                session.time = [NSString stringWithFormat:@"%@ - %@", [dict valueForKey:@"start_at"], [dict valueForKey:@"end_at"]];
                session.room = [self roomForName:[dict valueForKey:@"room"] region:region];
                session.sessionType = [NSNumber numberWithInt:[self sessionTypeCodeForName:[dict valueForKey:@"type"]]];
                for (NSString *name in [dict valueForKey:@"speakers"]) {
                    if ([name length]) {
                        [session addSpeakersObject:[self speakerForName:name region:region]];
//                    } else {
// NSLog(@"");
                    }
                }
            }
        }
    }
}

- (Speaker *)speakerForName:(id)name region:(Region *)region
{
    NSManagedObjectContext *context = region.managedObjectContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region = %@ and name = %@", region, name];
    Speaker *speaker = [Speaker findWithPredicate:predicate sortDescriptors:nil managedObjectContext:context error:NULL];
    if (speaker == nil) {
        speaker = [Speaker createWithManagedObjectContext:context];
        speaker.name = name;
        speaker.region = region;
        [speaker setListNumber];
        speaker.code = [speaker.position stringValue];
    }
    return speaker;
}



@end
