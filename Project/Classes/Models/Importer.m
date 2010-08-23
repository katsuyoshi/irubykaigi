//
//  Importer.m
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

#import "Importer.h"
#import "CiderCoreData.h"
#import "Region.h"
#import "Session.h"
#import "LightningTalk.h"
#import "JsonImporter.h"


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
        defaultImporter = [[JsonImporter sharedImporter] retain];
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


- (void)cleanUpWithManagedObject:(NSManagedObjectContext *)context
{
    for (Session *session in [Session findAllWithPredicate:[NSPredicate predicateWithFormat:@"day = nil"] error:NULL]) {
        [context deleteObject:session];
    }
    for (LightningTalk *talk in [LightningTalk findAllWithPredicate:[NSPredicate predicateWithFormat:@"session = nil"] error:NULL]) {
        [context deleteObject:talk];
    }
    [self save:context];
}

- (void)cleanUp
{
    [self cleanUpWithManagedObject:DEFAULT_MANAGED_OBJECT_CONTEXT];
}


@end
