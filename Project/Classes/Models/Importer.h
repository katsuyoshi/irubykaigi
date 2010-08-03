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


- (void)save:(NSManagedObjectContext *)context;

@end
