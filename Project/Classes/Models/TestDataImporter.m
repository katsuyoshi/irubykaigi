//
//  TestDataImporter.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/27.
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

- (void)importWithLocation:(NSString *)location;

@end


@implementation TestDataImporter

- (void)import
{
    [self clearAllData];

    [self importWithLocation:@"ja"];
    [self importWithLocation:@"en"];

}

- (void)importWithLocation:(NSString *)location
{
    NSManagedObjectContext *context = nil;
    NSAutoreleasePool *pool = nil;
    @try {
        pool = [NSAutoreleasePool new];
        
        context = [[NSManagedObjectContext defaultManagedObjectContext] newManagedObjectContext];
//        context = [NSManagedObjectContext defaultManagedObjectContext];
        
        Region *region = nil;
        if ([location isEqualToString:@"ja"]) {
            region = [Region japaneseInManagedObjectContext:context];
        } else {
            region = [Region englishInManagedObjectContext:context];
        }
        
        NSString *path = [NSString stringWithFormat:@"session_info_%@", location];
        path = [[NSBundle mainBundle] pathForResource:path ofType:@"csv"];
        [self importSessionsFromCsvFile:path region:region managedObjectContext:context];

        path = [NSString stringWithFormat:@"lightning_talks_info_%@", location];
        path = [[NSBundle mainBundle] pathForResource:path ofType:@"csv"];
        [self importLightningTalksFromCsvFile:path region:region managedObjectContext:context];

        [self save:context];
    } @finally {
        [pool drain];
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
    NSArray *sessions = [Session findAll:condition error:NULL];

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
