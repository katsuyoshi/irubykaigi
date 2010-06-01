//
//  Importer.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/27.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Importer.h"
#import "CiderCoreData.h"
#import "Region.h"
#import "SessionType.h"


@implementation Importer

- (void)clearAllData
{
    [NSManagedObjectContext clearDefaultManagedObjectContextAndDeleteStoreFile];
}

- (void)import
{
}



- (void)prepareDaysWithManagedObjectContext:(NSManagedObjectContext *)context
{
    Region *jaRegion = [Region japaneseInManagedObjectContext:context];
    Region *enRegion = [Region englishInManagedObjectContext:context];
    
    int i;
    for (i = 27; i <= 29; i++) {
        [jaRegion dayForDate:[NSDate dateWithYear:2010 month:8 day:i hour:0 minute:0 second:0]];
        [enRegion dayForDate:[NSDate dateWithYear:2010 month:8 day:i hour:0 minute:0 second:0]];
    }
}



- (void)prepareSissionTypesWithManagedObjectContext:(NSManagedObjectContext *)context
{
    SessionTypeCode codes[] = { SessionTypeCodeNormal, SessionTypeCodeKeynote, SessionTypeCodeOpening, SessionTypeCodeClosing, SessionTypeCodeLightningTalks,
                    SessionTypeCodeOpenAndAdmission, SessionTypeCodeBreak, SessionTypeCodeLunch, SessionTypeCodeParty,
                    SessionTypeCodeAnnouncement };
/*                    
    NSArray *sessionTypesInJapanese = [NSArray arrayWithObjects:
                                @"セッション", @"基調講演", @"オープニング", @"クロージング", @"ライトニングトークス",
                                @"会場・受付", @"休憩", @"昼休み", @"懇親会",
                                @"アナウンス",
                                nil];

    NSArray *sessionTypesInEnglish = [NSArray arrayWithObjects:
                                @"Session", @"Keynote", @"Opening", @"Closing", @"Lightning Talks",
                                @"Open & Addmission", @"Break", @"Lunch Break", @"Party",
                                @"Announcement",
                                nil];
*/

    NSArray *regions = [NSArray arrayWithObjects:[Region japaneseInManagedObjectContext:context], [Region englishInManagedObjectContext:context], nil];
    
    for (Region *region in regions) {
        int i;
        int count = sizeof(codes) / sizeof(codes[0]);
        for (i = 0; i < count; i++) {
            [SessionType sessionTypeWithCode:codes[i] region:region];
        }
    }
        
}


- (void)save:(NSManagedObjectContext *)context
{
    if ([context hasChanges]) {
        @try {
            [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
            [context.persistentStoreCoordinator lock];
            NSError *error = nil;
            [context save:&error];
#if DEBUG
            if (error) [error showErrorForUserDomains];
#endif
        } @finally {
            [context.persistentStoreCoordinator unlock];
        }
    }
}


@end
