//
//  Document.h
//  RubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/06/25.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Document : NSObject {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    NSManagedObjectContext *updatingManagedObjectContext;	    

    NSMutableSet *favoriteSet;
    
    BOOL imported;
    NSError *updateError;
}

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (Document *)sharedDocument;

+ (NSDate *)dateFromString:(NSString *)dateStr;


- (NSArray *)days;
- (NSArray *)sessions;
- (NSArray *)rooms;
- (NSArray *)lightningTalks;


- (NSManagedObject *)dayForDate:(NSString *)dateStr managedObjectContext:(NSManagedObjectContext *)context;

- (void)import;
- (void)importSessionsFromCsvFile:(NSString *)fileName managedObjectContext:(NSManagedObjectContext *)context;
- (void)importLightningTaklsFromCsvFile:(NSString *)fileName managedObjectContext:(NSManagedObjectContext *)context;

#pragma mark -
#pragma mark favorite

- (void)changeFavoriteOfSession:(NSManagedObject *)session;
- (BOOL)isFavoriteSession:(NSManagedObject *)session;
- (void)loadFavorites;
- (void)saveFavorites;


- (void)update;


@end
