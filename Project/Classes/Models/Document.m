//
//  Document.m
//  RubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/06/25.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Document.h"
#import "NSManagedObjectContextExtension.h"
#import "IUTLog.h"


@implementation Document

@synthesize managedObjectContext;


+ (Document *)sharedDocument
{
    static Document *document = nil;
    if (document == nil) {
        document = [Document new];
    }
    return document;
}


- (id)init
{
    self = [super init];
    if (self) {
        [self loadFavorites];
    }
    return self;
}

- (void)dealloc {
    [updateError release];
    [updatingManagedObjectContext release];
    [managedObjectContext release];
    [managedObjectModel release];
    [favoriteSet release];
    [persistentStoreCoordinator release];
    [super dealloc];   
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"RubyKaigi2009.sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}



#pragma mark -
#pragma mark data access

+ (NSDate *)dateFromString:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:dateStr];
}


- (NSManagedObject *)dayForDate:(NSString *)dateStr managedObjectContext:(NSManagedObjectContext *)context
{
    NSDate *date = [[self class] dateFromString:dateStr];
    NSFetchRequest *request = [[NSFetchRequest new] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@", date];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if ([result count]) {
        return [result lastObject];
    } else {
        NSManagedObject *eo = [NSEntityDescription insertNewObjectForEntityForName:@"Day" inManagedObjectContext:context];
        [eo setValue:date forKey:@"date"];
        return eo;
    }
}

- (NSManagedObject *)roomForName:(NSString *)name floor:(NSString *)floor managedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest new] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Room" inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@ and floor = %@", name, floor];
    [request setPredicate:predicate];
    [request setEntity:entity];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if ([result count]) {
        return [result lastObject];
    } else {
        NSManagedObject *eo = [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:context];
        [eo setValue:name forKey:@"name"];
        [eo setValue:floor forKey:@"floor"];

        [request setPredicate:nil];
        int count = [context countForFetchRequest:request error:&error];
        [eo setValue:[NSNumber numberWithInt:count - 1] forKey:@"position"];
        
        return eo;
    }
}

- (NSArray *)days
{
    PredicateCondition *condition = [PredicateCondition conditionWithEntity:@"Day" format:nil argumentArray:nil];
    condition.orderings = [NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES] autorelease]];
    return [self.managedObjectContext findAll:condition];
}

- (NSArray *)sessions
{
    PredicateCondition *condition = [PredicateCondition conditionWithEntity:@"Session" format:nil argumentArray:nil];
    return [self.managedObjectContext findAll:condition];
}

- (NSArray *)rooms
{
    PredicateCondition *condition = [PredicateCondition conditionWithEntity:@"Room" format:nil argumentArray:nil];
    return [self.managedObjectContext findAll:condition];
}

- (NSArray *)lightningTalks
{
    PredicateCondition *condition = [PredicateCondition conditionWithEntity:@"LightningTalk" format:nil argumentArray:nil];
    condition.orderings = [NSArray arrayWithObjects:
                                  [[[NSSortDescriptor alloc] initWithKey:@"session.day.date" ascending:YES] autorelease]
                                , [[[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES] autorelease]
                                , nil];
    return [self.managedObjectContext findAll:condition];
}

#pragma mark -
#pragma mark favorite

- (void)changeFavoriteOfSession:(NSManagedObject *)session
{
    NSNumber *position = [session valueForKey:@"position"];
    if ([self isFavoriteSession:session]) {
        [favoriteSet removeObject:position];
    } else {
        [favoriteSet addObject:position];
    }
    [self saveFavorites];
}

- (BOOL)isFavoriteSession:(NSManagedObject *)session
{
    NSNumber *position = [session valueForKey:@"position"];
    return [favoriteSet containsObject:position];
}

- (void)loadFavorites
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults arrayForKey:@"favorite"];
    if (array) {
        [favoriteSet release];
        favoriteSet = [[NSMutableSet setWithArray:array] retain];
    } else {
        favoriteSet = [NSMutableSet new];
    }
}

- (void)saveFavorites
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[favoriteSet allObjects] forKey:@"favorite"];
}



#pragma mark -
#pragma mark import datas

- (void)import
{
    if (imported == NO) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"session_info.csv"];
        if ([manager fileExistsAtPath:filePath] == NO) {
            filePath = [[NSBundle mainBundle] pathForResource:@"session_info" ofType:@"csv"];
        }
        [self importSessionsFromCsvFile:filePath managedObjectContext:self.managedObjectContext];
        
        filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"lightning_talks_info.csv"];
        if ([manager fileExistsAtPath:filePath] == NO) {
            filePath = [[NSBundle mainBundle] pathForResource:@"lightning_talks_info" ofType:@"csv"];
        }
        [self importLightningTaklsFromCsvFile:filePath managedObjectContext:self.managedObjectContext];
    }
}

- (void)importSessionsFromCsvFile:(NSString *)fileName managedObjectContext:(NSManagedObjectContext *)context
{
    NSString *contents = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:NULL];
    BOOL isFirst = YES;
    NSArray *keys;
    int position = 0;
    for (NSString *line in [contents componentsSeparatedByString:@"\n"]) {
        if ([line length]) {
            if (isFirst) {
                isFirst = NO;
                keys = [line componentsSeparatedByString:@"\t"];
            } else {
                int index = 0;
                NSManagedObject *eo = [NSEntityDescription insertNewObjectForEntityForName:@"Session" inManagedObjectContext:context];
                [eo setValue:[NSNumber numberWithInt:position++] forKey:@"position"];
                
                NSManagedObject *day;
                NSString *roomName = nil;
                NSString *floorName = nil;
                for (NSString *element in [line componentsSeparatedByString:@"\t"]) {
                    NSString *key = [keys objectAtIndex:index];
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
            }
        }
    }
}

- (void)importLightningTaklsFromCsvFile:(NSString *)fileName managedObjectContext:(NSManagedObjectContext *)context
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
                NSManagedObject *eo = [NSEntityDescription insertNewObjectForEntityForName:@"LightningTalk" inManagedObjectContext:context];
                
                NSManagedObject *session = nil;
                NSString *name = nil;
                NSString *belonging = nil;
                int index = 0;
                
                for (NSString *element in [line componentsSeparatedByString:@"\t"]) {
                    NSString *key = [keys objectAtIndex:index];
                    if ([key isEqualToString:@"date"]) {
                        PredicateCondition *condition = [PredicateCondition conditionWithEntity:@"Session" format:@"day = %@ and title like %@" argumentArray:[NSArray arrayWithObjects:[self dayForDate:element managedObjectContext:context], @"Lightning Talks*", nil]];
                        session = [context find:condition];
                        NSMutableSet *talks = [session mutableSetValueForKey:@"lightningTalks"];
                        [eo setValue:[NSNumber numberWithInt:[talks count]] forKey:@"position"];
                        [talks addObject:eo];
                    } else
                    if ([key isEqualToString:@"speaker"]) {
                        name = element;
                    } else
                    if ([key isEqualToString:@"belonging"]) {
                        belonging = element;
                        if ([name length]) {
                            NSManagedObject *speaker = [NSEntityDescription insertNewObjectForEntityForName:@"Speaker" inManagedObjectContext:context];
                            [speaker setValue:name forKey:@"name"];
                            [speaker setValue:belonging forKey:@"belonging"];
                            [[eo mutableSetValueForKey:@"speakers"] addObject:speaker];
                            name = belonging = nil;
                        }
                    } else {
                        if ([element length]) {
                            [eo setValue:element forKey:key];
                        }
                    }

                    index++;
                    
                }
            }
        }
    }
}


#pragma mark -
#pragma mark update


- (void)loadFileAndStore:(NSString *)loadFileUri storeFileName:(NSString *)storeFileName
{
    NSURL *uri = [NSURL URLWithString:loadFileUri];
    NSString *fileContents = [[NSString alloc] initWithContentsOfURL:uri encoding:NSUTF8StringEncoding error:&updateError];
    if (updateError) {
        [updateError retain];
        return;
    }
    
    NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:storeFileName];
    [fileContents writeToFile:storePath atomically:YES encoding:NSUTF8StringEncoding error:&updateError];
    if (updateError) {
        [updateError retain];
        return;
    }
}

- (void)updateSessionInfos
{
    updatingManagedObjectContext = [NSManagedObjectContext new];
    [updatingManagedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    NSString *filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"session_info.csv"];
    [self importSessionsFromCsvFile:filePath managedObjectContext:updatingManagedObjectContext];
    filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"lightning_talks_info.csv"];
    [self importLightningTaklsFromCsvFile:filePath managedObjectContext:updatingManagedObjectContext];
    
    
}

- (void)update
{
    [updateError release];
    updateError = nil;
    
    [self loadFileAndStore:NSLocalizedString(@"SESSION_INFO_URL", nil) storeFileName:@"session_info.csv"];
    [self loadFileAndStore:NSLocalizedString(@"LIGHTNING_TALKS_INFO_URL", nil) storeFileName:@"lightning_talks_info.csv"];
    
    [self updateSessionInfos];
    
    self.managedObjectContext = updatingManagedObjectContext;
    [updatingManagedObjectContext release];
    updatingManagedObjectContext = nil;
}


@end
