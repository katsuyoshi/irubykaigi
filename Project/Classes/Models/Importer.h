//
//  Importer.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/27.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//



@interface Importer : NSObject {

}

- (void)clearAllData;

- (void)import;

// DELETEME: - (void)prepareDaysWithManagedObjectContext:(NSManagedObjectContext *)context;
// DELETEME: - (void)prepareSissionTypesWithManagedObjectContext:(NSManagedObjectContext *)context;


- (void)save:(NSManagedObjectContext *)context;

@end
