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


@interface TestDataImporter(IRKPrivate)

- (void)importSessionsFromCsvFile:(NSString *)fileName region:(Region *)region managedObjectContext:(NSManagedObjectContext *)context;

@end


@implementation TestDataImporter

- (void)import
{
    NSManagedObjectContext *context = nil;
    @try {
        [self clearAllData];
        
        context = [[NSManagedObjectContext defaultManagedObjectContext] newManagedObjectContext];

// DELETEME:        [self prepareDaysWithManagedObjectContext:context];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"session_info" ofType:@"csv"];
        [self importSessionsFromCsvFile:path region:[Region japaneseInManagedObjectContext:context] managedObjectContext:context];

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

                NSArray *attributeKeys = [NSArray arrayWithObjects:@"date", @"room", @"floor", @"speaker", @"break", @"abstract", @"attention", nil];
                
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
                                    Speaker *speaker = [Speaker findByName:name inManagedObjectContext:context];
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
                    default:
                        [session setValue:element forKey:key];
                        break;
                    }
                    index++;
                }
/*
                    if ([key isEqualToString:@"date"]) {
                        day = [self dayForDate:element managedObjectContext:context];
                        [[day  mutableSetValueForKey:@"sessions"] addObject:eo];
                    } else
                    if ([key isEqualToString:@"room"]) {
                        roomName = element;
                    } else
                    if ([key isEqualToString:@"floor"]) {
                        floorName = element;
                    } else
                    if ([key isEqualToString:@"speaker"]) {
                        int index = 0;
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
                                NSManagedObject *speaker = [NSEntityDescription insertNewObjectForEntityForName:@"Speaker" inManagedObjectContext:context];
                                [speaker setValue:name forKey:@"name"];
                                if (belonging) {
                                    [speaker setValue:belonging forKey:@"belonging"];
                                }
                                [speaker setValue:[NSNumber numberWithInt:index++] forKey:@"position"];
                                [[eo mutableSetValueForKey:@"speakers"] addObject:speaker];
                            }
                        }
                    } else
                    if ([key isEqualToString:@"break"]) {
                        [eo setValue:[NSNumber numberWithBool:[element isEqualToString:@"true"]] forKey:key];
                    } else {
                        if ([element length]) {
                            [eo setValue:element forKey:key];
                        }
                    }

                    if ([roomName length] && [floorName length] && ![[eo valueForKey:@"break"] boolValue]) {
                        NSManagedObject *room = [self roomForName:roomName floor:floorName managedObjectContext:context];
                        [eo setValue:room forKey:@"room"];
                        roomName = floorName = nil;
                    }

                    index++;
                }
                // codeがない場合はポジションの値を用いる
                if ([eo valueForKey:@"code"] == nil) {
                    [eo setValue:[[eo valueForKey:@"position"] description] forKey:@"code"];
                }
*/
            }
        }
    }
}



@end
