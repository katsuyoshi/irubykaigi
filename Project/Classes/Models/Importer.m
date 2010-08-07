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
#import "Session.h"
#import "LightningTalk.h"
#import "JsonCrudeImporter.h"


@implementation Importer

@synthesize updating;
@synthesize delegate;


+ (id)sharedImporter
{
    static id importer = nil;
    if (importer == nil) {
        importer = [self new];
    }
    return importer;
}

static id defaultImporter = nil;

+ (id)defaultImporter
{
    if (defaultImporter == nil) {
        defaultImporter = [[JsonCrudeImporter sharedImporter] retain];
    }
    return defaultImporter;
}

+ (void)setDefaultImporter:(Importer *)importer
{
    [defaultImporter release];
    defaultImporter = [importer retain];
}

- (void)dealloc
{
    [(id)delegate release];
    [super dealloc];
}

- (void)setUpdated:(BOOL)flag
{
    [self willChangeValueForKey:@"isUpdated"];
    updated = flag;
    [self didChangeValueForKey:@"isUpdated"];
}

- (NSNumber *)isUpdated
{
    return [NSNumber numberWithBool:updated];
}



- (void)clearAllData
{
    [NSManagedObjectContext clearDefaultManagedObjectContextAndDeleteStoreFile];
}

- (void)beginImport
{
    if (updating == NO) {
        updating = YES;
        hasChanges = NO;
        [self setUpdated:NO];
        NSOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(import) object:nil] autorelease];
        [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:operation];
        [[NSOperationQueue defaultQueue] addOperation:operation];
    }
}

- (void)import
{
}

- (void)beginUpdate
{
    if (updating == NO) {
        updating = YES;
        hasChanges = NO;
        NSOperation *operation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(update) object:nil] autorelease];
        [operation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:operation];
        [[NSOperationQueue defaultQueue] addOperation:operation];
    }
}

- (void)update
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


- (BOOL)save:(NSManagedObjectContext *)context
{
    if ([context hasChanges]) {
        hasChanges = YES;
        @try {
            [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
            [context.persistentStoreCoordinator lock];
            NSError *error = nil;
            [context save:&error];
#if DEBUG
            if (error) [error showErrorForUserDomains];
#endif
            return error ? NO : YES;
        } @finally {
            [context.persistentStoreCoordinator unlock];
        }
    }
    return NO;
}

- (void)importerDidUpdate
{
    NSManagedObjectContext *context = DEFAULT_MANAGED_OBJECT_CONTEXT;
    for (NSManagedObject *eo in [context registeredObjects]) {
        [context refreshObject:eo mergeChanges:NO];
    }
    if ([(id)delegate respondsToSelector:@selector(importerDidUpdate)]) {
        [delegate importerDidUpdate];
    }
    updating = NO;
    [self setUpdated:hasChanges];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSOperation *operation = (NSOperation *)context;
    [operation removeObserver:self forKeyPath:@"isFinished"];
    
    if ([NSThread isMainThread]) {
        [self importerDidUpdate];
    } else {
        [self performSelectorOnMainThread:@selector(importerDidUpdate) withObject:nil waitUntilDone:YES];
    }
}

- (void)deleteAllSessionsInManagedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.managedObjectContext = context;
    NSArray *sessions = [Session findAll:condition error:NULL];
    for (Session *session in sessions) {
        [context deleteObject:session];
    }
}


- (void)cleanUp
{
    NSManagedObjectContext *context = DEFAULT_MANAGED_OBJECT_CONTEXT;
    for (Session *session in [Session findAllWithPredicate:[NSPredicate predicateWithFormat:@"day = nil"] error:NULL]) {
        [context deleteObject:session];
    }
    for (LightningTalk *talk in [LightningTalk findAllWithPredicate:[NSPredicate predicateWithFormat:@"session = nil"] error:NULL]) {
        [context deleteObject:talk];
    }
    [self save:context];
}



@end
