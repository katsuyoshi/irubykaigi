//
//  JsonCrudeImporter.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/30.
//

/* 

  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:
  
      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
 
      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.
 
      * Neither the name of ITO SOFT DESIGN Inc. nor the names of its
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#import "JsonImporter.h"
#import "JSON.h"
#import "CiderCoreData.h"
#import "Day.h"
#import "Region.h"
#import "Session.h"
#import "Speaker.h"
#import "Room.h"
#import "LightningTalk.h"
#import "Property.h"
#import "Belonging.h"



@interface JsonImporter(IRKPrivate)

- (void)parseTimeline:(id)object;
- (void)parseTimelineWithObject:(id)object region:(Region *)region;
- (void)parseRoomsWithObject:(id)object region:(Region *)region;
- (void)parseDaysWithObject:(id)object region:(Region *)region;
- (void)parseSessionsWithObject:(id)object region:(Region *)region;
- (void)parseSpeakersWithObject:(id)object region:(Region *)region;
- (void)parseLightningTalksWithObject:(id)object inSession:(Session *)session;

- (Room *)roomForName:(NSString *)name region:(Region *)region;
- (Day *)dayForString:(NSString *)dayString region:(Region *)region;
- (SessionTypeCode)sessionTypeCodeForName:(NSString *)name;
- (Speaker *)speakerForName:(id)name info:(NSDictionary *)info region:(Region *)region;

@end


@implementation JsonImporter

@synthesize mainSiteURL;
@synthesize backupSiteURL;


- (void)dealloc
{
    [mainSiteURL release];
    [backupSiteURL release];
    [super dealloc];
}

- (NSURL *)mainSiteURL
{
    if (mainSiteURL == nil) {
#ifdef DEBUG
        NSString *path = [[NSBundle mainBundle] pathForResource:@"timetable_update" ofType:@"json"];
        mainSiteURL = [[NSURL alloc] initFileURLWithPath:path];
#else
        NSString *urlString = @"http://iphone.itosoft.com/irubykaigi/2010/timetables2.json";
        mainSiteURL = [[NSURL alloc] initWithString:urlString];
#endif
    }
    return mainSiteURL;
}

- (NSURL *)backupSiteURL
{
    if (backupSiteURL == nil) {
        NSString *urlString = @"https://files.me.com/gutskun/uh5n9i";
        backupSiteURL = [[NSURL alloc] initWithString:urlString];
    }
    return backupSiteURL;
}


- (void)import
{
    updating = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"timetable" ofType:@"json"];
    [self importWithURL:[NSURL fileURLWithPath:path]];
    updating = NO;
}

- (void)update
{
    updating = YES;    
    if ([self importWithURL:self.mainSiteURL] == NO) {
        [self importWithURL:self.backupSiteURL];
    }
    updating = NO;
}

- (BOOL)importWithURL:(NSURL *)url forceUpdate:(BOOL)force
{
    // jsonファイル読込み
    NSError *error = nil;
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
#ifdef DEBUG
    if (error) [error showErrorForUserDomains];
#endif
    if (jsonString == nil) {
        return NO;
    }

    SBJsonParser *parser = [[SBJsonParser new] autorelease];
    id object = [parser objectWithString:jsonString];

    // 更新日付が更新されたら更新する
    Property *property = [Property sharedProperty];
    NSDate *updatedAt = property.updatedAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *newUpdatedAt = [dateFormatter dateFromString:[object valueForKey:@"updated_at"]];

#ifdef DEBUG
    if (YES) {
#else
    if (force || updatedAt == nil || newUpdatedAt == nil || [updatedAt laterDate:newUpdatedAt] != updatedAt) { 
#endif
      
        NSManagedObjectContext *context = [[NSManagedObjectContext defaultManagedObjectContext] newManagedObjectContext];        
        [self parseTimelineWithObject:[object valueForKey:@"ja"] region:[Region japaneseInManagedObjectContext:context]];
        [self parseTimelineWithObject:[object valueForKey:@"en"] region:[Region englishInManagedObjectContext:context]];
        
        if ([self save:context]) {
            [Property sharedProperty].updatedAt = newUpdatedAt;
        }

        [context release];
    }
    return YES;
}

- (BOOL)importWithURL:(NSURL *)url
{
    return [self importWithURL:url forceUpdate:NO];
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
    } else
    if ([name isEqualToString:@"opening"]) {
        return SessionTypeCodeOpening;
    } else
    if ([name isEqualToString:@"closing"]) {
        return SessionTypeCodeClosing;
    } else
    if ([name isEqualToString:@"lightning_talks"]) {
        return SessionTypeCodeLightningTalks;
    } else
    if ([name isEqualToString:@"party"]) {
        return SessionTypeCodeParty;
    } else {
        return SessionTypeCodeNormal;
    }
}

- (void)parseSessionsWithObject:(id)object region:(Region *)region
{
    NSMutableArray *codes = [NSMutableArray array];
    
    NSManagedObjectContext *context = region.managedObjectContext;
    for (id sessionsDict in object) {
        Day *day = [self dayForString:[sessionsDict valueForKey:@"day"] region:region];
        for (id dict in [sessionsDict valueForKey:@"sessions"]) {
            NSString *code = [dict valueForKey:@"code"];

            [codes addObject:code]; // 削除された場合の処理
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day.region = %@ and code = %@", region, code];
            Session *session = [Session findWithPredicate:predicate sortDescriptors:nil managedObjectContext:context error:NULL];
            if (session == nil) {
                session = [Session createWithManagedObjectContext:context];
                session.code = code;
                session.day = day;
            }
            [session setListNumber];
            session.title = [dict valueForKey:@"title"];
            session.summary = [dict valueForKey:@"summary"];
            session.time = [NSString stringWithFormat:@"%@ - %@", [dict valueForKey:@"start_at"], [dict valueForKey:@"end_at"]];
            session.room = [self roomForName:[dict valueForKey:@"room"] region:region];
            session.sessionType = [NSNumber numberWithInt:[self sessionTypeCodeForName:[dict valueForKey:@"type"]]];
            [session removeSpeakers:session.speakers];
            for (NSDictionary *speakerDict in [dict valueForKey:@"speakers"]) {
                NSString *name = [speakerDict valueForKey:@"name"];
                if ([name length]) {
                    [session addSpeakersObject:[self speakerForName:name info:speakerDict region:region]];
                }
            }
            if ([session.sessionType intValue] == SessionTypeCodeLightningTalks) {
                [self parseLightningTalksWithObject:[dict valueForKey:@"lightning_talks"] inSession:session]; 
            }
        }
    }
    
    // 削除されたSessionはdayをnilにする
    // TODO: 起動時にクリーンアップ処理をする
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.predicate = [NSPredicate predicateWithFormat:@"day.region = %@ and not code in %@", region, codes];
    condition.managedObjectContext = context;
    NSArray *sessions = [Session findAll:condition error:NULL];
    for (Session *session in sessions) {
        session.day = nil;
    }
}



- (void)parseLightningTalksWithObject:(id)object inSession:(Session *)session 
{
    NSMutableArray *positions = [NSMutableArray array];

    Region *region = session.day.region;
    NSManagedObjectContext *context = session.managedObjectContext;
    if ([session.sessionType intValue] == SessionTypeCodeLightningTalks) {
        int index = 1;
        for (id lightningTalksDict in object) {
            NSNumber *position = [NSNumber numberWithInt:index++];
            [positions addObject:position];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"session = %@ and position = %@", session, position];
            LightningTalk *talk = [LightningTalk findWithPredicate:predicate sortDescriptors:nil managedObjectContext:context error:NULL];
            if (talk == nil) {
                talk = [LightningTalk createWithManagedObjectContext:context];
                talk.position = position;
                talk.session = session;
            }
            talk.title = [lightningTalksDict valueForKey:@"title"];
            [talk removeSpeakers:talk.speakers];
            for (id speakerDict in [lightningTalksDict valueForKey:@"speakers"]) {
                Speaker *speaker = [self speakerForName:[speakerDict valueForKey:@"name"] info:speakerDict region:region];
                [talk addSpeakersObject:speaker];
            }
        }
    }
    
    // 削除されたLightningTalksはdayをnilにする
    // TODO: 起動時にクリーンアップ処理をする
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"not position in %@", positions];
    for (LightningTalk *talk in [session.talks filteredSetUsingPredicate:predicate]) {
        talk.session = nil;
    }
}


- (Speaker *)speakerForName:(id)name info:(NSDictionary *)info region:(Region *)region
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
    
    NSArray *belongings = [Speaker belongingsFromString:[info valueForKey:@"belonging"]];
    if ([belongings count]) {
        for (NSString *title in belongings) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"speaker = %@ and title = %@", speaker, title];
            if ([[speaker.belongings filteredSetUsingPredicate:predicate] count] == 0) {
                Belonging *belonging = [Belonging createWithManagedObjectContext:context];
                [speaker addBelongingsObject:belonging];
                belonging.title = title;
                [belonging setListNumber];
            }
        }
    }
    NSString *profile = [info valueForKey:@"profile"];
    if (profile) {
        speaker.profile = profile;
    }

    return speaker;
}



@end
