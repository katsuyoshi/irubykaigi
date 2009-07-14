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

    NSNumber *updating;
}

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain) NSNumber *updating;

@property (readonly) BOOL useSubSite;


+ (Document *)sharedDocument;

+ (NSOperationQueue *)sharedOperationQueue;

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

#pragma mark -
#pragma mark update

- (void)beginUpdate;
- (void)update;

#pragma mark -
#pragma mark alert

- (void)showErrorAlert:(NSString *)reason;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
