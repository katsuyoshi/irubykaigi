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
}

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (Document *)sharedDocument;

+ (NSDate *)dateFromString:(NSString *)dateStr;


- (NSArray *)days;
- (NSArray *)sessions;
- (NSArray *)rooms;


- (NSManagedObject *)dayForDate:(NSString *)dateStr;

- (void)importFromCsvFile:(NSString *)fileName;


@end
