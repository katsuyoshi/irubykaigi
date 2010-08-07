//
//  Importer.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/27.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//


@protocol ImporteDelegate

- (void)importerDidUpdate;

@end


@interface Importer : NSObject {

    BOOL updating;
    BOOL updated;
    BOOL hasChanges;
    
    id<ImporteDelegate> delegate;

}

+ (id)sharedImporter;
+ (id)defaultImporter;
+ (void)setDefaultImporter:(Importer *)importer;


@property (readonly) BOOL updating;
@property (assign, readonly) NSNumber *isUpdated;

@property (retain) id<ImporteDelegate> delegate;


- (void)clearAllData;

- (void)beginImport;
- (void)import;

- (void)beginUpdate;
- (void)update;


- (BOOL)save:(NSManagedObjectContext *)context;
- (void)deleteAllSessionsInManagedObjectContext:(NSManagedObjectContext *)context;

- (void)cleanUp;


@end
