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
#import "Region.h"
#import "Session.h"
#import "Speaker.h"
#import "Room.h"
#import "LightningTalk.h"


@interface TestDataImporter(IRKPrivate)

- (void)importSessionsFromCsvFile:(NSString *)fileName region:(Region *)region managedObjectContext:(NSManagedObjectContext *)context;
- (void)importLightningTalksFromCsvFile:(NSString *)fileName region:(Region *)region managedObjectContext:(NSManagedObjectContext *)context;

@end


@implementation TestDataImporter

- (void)import
{
    NSManagedObjectContext *context = nil;
    @try {
        [self clearAllData];
        
        context = [[NSManagedObjectContext defaultManagedObjectContext] newManagedObjectContext];
//        context = [NSManagedObjectContext defaultManagedObjectContext];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"session_info" ofType:@"csv"];
        [self importSessionsFromCsvFile:path region:[Region japaneseInManagedObjectContext:context] managedObjectContext:context];

//        [self save:context];
//        [context reset];

        path = [[NSBundle mainBundle] pathForResource:@"lightning_talks_info" ofType:@"csv"];
        [self importLightningTalksFromCsvFile:path region:[Region japaneseInManagedObjectContext:context] managedObjectContext:context];

        [self save:context];
    } @finally {
        [context release];
    }
}


- (void)importSessionsFromCsvFile:(NSString *)fileName region:(Region *)region managedObjectContext:(NSManagedObjectContext *)context
{
    NSString *contents = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:NULL];
    BOOL isFirst = YES;
    NSArray *keys;
    for (NSString *line in [contents componentsSeparatedByString:@"\n"]) {
        if ([line length]) {
            if (isFirst) {
                isFirst = NO;
                keys = [line componentsSeparatedByString:@"\t"];
            } else {
                int index = 0;
                Session *session = [Session createWithManagedObjectContext:context];

                NSArray *attributeKeys = [NSArray arrayWithObjects:@"date", @"room", @"floor", @"speaker", @"break", @"abstract", @"attention", @"title", nil];
                
                Day *day;
                NSString *roomName = nil;
                NSString *floorName = nil;
                for (NSString *element in [line componentsSeparatedByString:@"\t"]) {
                    NSString *key = [keys objectAtIndex:index];
                    switch ([attributeKeys indexOfObject:key]) {
                    case 0: /* date */
                        {
                            NSArray *e = [element componentsSeparatedByString:@"-"];
                            int year = [[e objectAtIndex:0] intValue];
                            int month = [[e objectAtIndex:1] intValue];
                            int dayOfMonth = [[e objectAtIndex:2] intValue];
                            NSDate *date = [NSDate dateWithYear:year month:month day:dayOfMonth hour:0 minute:0 second:0];
                            day = [region dayForDate:date];
                            session.day = day;
                            
                            // dayが決まらないと順番を付けられない
                            [session setListNumber];
                        }
                        break;
                    case 1: /* room */
                        roomName = element;
                        session.room = [Room roomByName:roomName floor:floorName region:region inManagedObjectContext:context];
                        break;
                    case 2: /* floor */
                        floorName = element;
                        session.room = [Room roomByName:roomName floor:floorName region:region inManagedObjectContext:context];
                        break;
                    case 3: /* speaker */
                        {
                            session.speakerRawData = element;

                            // '、'か' and 'を区切りとしている
                            NSArray *speakerInfos = [element componentsSeparatedByString:@"、"];
                            if ([speakerInfos count] == 1) {
                                speakerInfos = [element componentsSeparatedByString:@" and "];
                            }
                            for (NSString *speakerInfo in speakerInfos) {
                                NSArray *infos = [speakerInfo componentsSeparatedByString:@"("];
                                NSString *name = [infos objectAtIndex:0];
                                name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                NSString *belonging = nil;
                                if ([infos count] == 2) {
                                    belonging = [infos objectAtIndex:1];
                                    belonging = [belonging stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@")"]];
                                }
                                if ([name length]) {
                                    Speaker *speaker = [Speaker findByName:name region:region inManagedObjectContext:context];
                                    if (speaker == nil) {
                                        speaker = [Speaker createWithManagedObjectContext:context];
                                        speaker.name = name;
                                        speaker.belonging = belonging;
                                        speaker.region = region;
                                        [speaker setListNumber];
                                        // codeの代わり
                                        speaker.code = [speaker.position stringValue];
                                    }
                                    [speaker addSessionsObject:session];
                                }
                            }
                        }
                        break;
                    case 4: /* break */
                        if ([element isEqualToString:@"true"]) {
                            session.sessionType = [NSNumber numberWithInt:SessionTypeCodeBreak];
                        }
                        break;
                    case 5: /* abstract */
                        session.summary = element;
                        break;
                    case 6: /* attention */
                        if ([element isEqualToString:@"true"]) {
                            session.sessionType = [NSNumber numberWithInt:SessionTypeCodeAnnouncement];
                        }
                        break;
                    case 7: /* title */
                        if ([element rangeOfString:@"Lightning Talks"].location != NSNotFound) {
                            session.sessionType = [NSNumber numberWithInt:SessionTypeCodeLightningTalks];
                        }
                        [session setValue:element forKey:key];
                    default:
                        [session setValue:element forKey:key];
                        break;
                    }
                    index++;
                }
            }
        }
    }
}


- (void)importLightningTalksFromCsvFile:(NSString *)fileName region:(Region *)region managedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.managedObjectContext = context;
    condition.predicate = [NSPredicate predicateWithFormat:@"day.region = %@ and sessionType = %@", region, [NSNumber numberWithInt:SessionTypeCodeLightningTalks]];
//    condition.predicate = [NSPredicate predicateWithFormat:@"sessionType = %@", [NSNumber numberWithInt:SessionTypeCodeLightningTalks]];
    NSArray *sessions = [Session findAll:condition error:NULL];
Session *aSession = [sessions lastObject];
NSLog(@"%@", aSession.title);
NSLog(@"%@", [aSession valueForKey:@"intermission"]);
NSLog(@"%@", [aSession valueForKey:@"profile"]);
NSLog(@"%@", [aSession valueForKey:@"attention"]);
NSLog(@"%@", [aSession valueForKey:@"summary"]);
NSLog(@"%@", [aSession valueForKey:@"position"]);
NSLog(@"%@", [aSession valueForKey:@"code"]);
NSLog(@"%@", [aSession valueForKey:@"speakers"]);
NSLog(@"%@", [aSession valueForKey:@"day"]);
NSLog(@"%@", [aSession valueForKey:@"sessionType"]);
NSLog(@"%@", NSStringFromClass([[aSession valueForKey:@"talks"] class]));
NSLog(@"%@", [aSession valueForKey:@"time"]);
NSLog(@"%@", aSession);

    NSString *contents = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:NULL];
    BOOL isFirst = YES;
    NSArray *keys;
    for (NSString *line in [contents componentsSeparatedByString:@"\n"]) {
        if ([line length]) {
            if (isFirst) {
                isFirst = NO;
                keys = [line componentsSeparatedByString:@"\t"];
            } else {
                int index = 0;
                LightningTalk *lightningTalk = [LightningTalk createWithManagedObjectContext:context];

                NSArray *attributeKeys = [NSArray arrayWithObjects:@"date", @"title", @"speaker", @"belonging", nil];
                
                Day *day;
                for (NSString *element in [line componentsSeparatedByString:@"\t"]) {
                    NSString *key = [keys objectAtIndex:index];
                    switch ([attributeKeys indexOfObject:key]) {
                    case 0: /* date */
                        {
                            NSArray *e = [element componentsSeparatedByString:@"-"];
                            int year = [[e objectAtIndex:0] intValue];
                            int month = [[e objectAtIndex:1] intValue];
                            int dayOfMonth = [[e objectAtIndex:2] intValue];
                            NSDate *date = [NSDate dateWithYear:year month:month day:dayOfMonth hour:0 minute:0 second:0];
                            day = [region dayForDate:date];
                            
                            for (Session *session in sessions) {
                                if (session.day == day) {
                                    [lightningTalk setSession:session];
//                                    lightningTalk.session = session;
                                    break;
                                }
                            }
                            // sessionが決まらないと順番を付けられない
                            [lightningTalk setListNumber];
                        }
                        break;
                    case 1: /* title */
                        lightningTalk.title = element;
                        break;
                    case 2: /* speaker */
                        {
                            Speaker *speaker = [Speaker findByName:element region:region inManagedObjectContext:context];
                            if (speaker == nil) {
                                speaker = [Speaker createWithManagedObjectContext:context];
                                speaker.name = element;
                                speaker.region = region;
                                [speaker setListNumber];
                                // codeの代わり
                                speaker.code = [speaker.position stringValue];
                            }
                            [lightningTalk addSpeakersObject:speaker];
                        }
                        break;
                    case 4: /* belonging */
                        if ([lightningTalk.speakers count]) {
                            Speaker *speaker = [lightningTalk.speakers anyObject];
                            speaker.belonging = element;
                        }
                        break;
                    }
                    index++;
                }
            }
        }
    }
}


@end
