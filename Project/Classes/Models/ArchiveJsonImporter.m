//
//  ArchiveJsonImporter.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/09/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "ArchiveJsonImporter.h"
#import "Property.h"
#import "Region.h"
#import "Session.h"
#import "Archive.h"
#import "JSON.h"
#import "LightningTalk.h"


@interface ArchiveJsonImporter(IRKPrivate)
- (void)parseArchivesWithObject:(id)object region:(Region *)region;
@end


@implementation ArchiveJsonImporter

+ (ArchiveJsonImporter *)sharedArchiveJsonImporter
{
    static id importer = nil;
    @synchronized(self) {
        if (importer == nil) {
            importer = [self new];
        }
    }
    return importer;
}

- (NSURL *)mainSiteURL
{
    if (mainSiteURL == nil) {
#ifdef DEBUG
        NSString *path = [[NSBundle mainBundle] pathForResource:@"archives" ofType:@"json"];
        mainSiteURL = [[NSURL alloc] initFileURLWithPath:path];
#else
        NSString *urlString = @"http://iphone.itosoft.com/irubykaigi/2010/archives.json";
        mainSiteURL = [[NSURL alloc] initWithString:urlString];
#endif
    }
    return mainSiteURL;
}

- (void)import
{
    updating = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"archives" ofType:@"json"];
    [self importWithURL:[NSURL fileURLWithPath:path]];
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
    NSDate *updatedAt = property.archiveUpdatedAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *newUpdatedAt = [dateFormatter dateFromString:[object valueForKey:@"updated_at"]];

#ifdef DEBUG
    if (YES) {
#else
    if (force || updatedAt == nil || newUpdatedAt == nil || [updatedAt laterDate:newUpdatedAt] != updatedAt) { 
#endif
      
        NSManagedObjectContext *context = [[NSManagedObjectContext defaultManagedObjectContext] newManagedObjectContext];        
        [self parseArchivesWithObject:[object valueForKey:@"ja"] region:[Region japaneseInManagedObjectContext:context]];
        [self parseArchivesWithObject:[object valueForKey:@"en"] region:[Region englishInManagedObjectContext:context]];
        
        if ([self save:context]) {
            [Property sharedProperty].archiveUpdatedAt = newUpdatedAt;
        }

        [context release];
    }
    return YES;
}

- (void)replaceArchivesWithObject:(NSManagedObject *)object archives:(NSArray *)archives
{
    NSManagedObjectContext *context = [object managedObjectContext];
    [(id)object removeArchives:[(id)object archives]];
    for (id archiveDict in archives) {
        Archive *archive = [Archive createWithManagedObjectContext:context];
        archive.title = [archiveDict valueForKey:@"title"];
        archive.url = [archiveDict valueForKey:@"url"];
        [(id)object addArchivesObject:archive];
        [archive setListNumber];
    }
}

- (void)parseArchivesWithObject:(id)object region:(Region *)region
{
    NSManagedObjectContext *context = region.managedObjectContext;
    for (id dict in object) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day.region = %@ and code = %@", region, [dict valueForKey:@"code"]];
        Session *session = [Session findWithPredicate:predicate sortDescriptors:nil managedObjectContext:context error:NULL];
        if (session) {
            [self replaceArchivesWithObject:session archives:[dict valueForKey:@"archives"]];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"session.day.region = %@ and session.code = %@ and position = %@", region, [dict valueForKey:@"parent"], [dict valueForKey:@"position"]];
            LightningTalk *lightningTalk = [LightningTalk findWithPredicate:predicate sortDescriptors:nil managedObjectContext:context error:NULL];
            if (lightningTalk) {
                [self replaceArchivesWithObject:lightningTalk archives:[dict valueForKey:@"archives"]];
            } else {
                NSLog(@"undefined %@", dict);
            }
        }
    }
}

@end
