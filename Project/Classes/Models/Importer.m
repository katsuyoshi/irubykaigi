//
//  Importer.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/27.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Importer.h"
#import "CiderCoreData.h"


@implementation Importer

- (void)clearAllData
{
    [NSManagedObjectContext clearDefaultManagedObjectContextAndDeleteStoreFile];
}

- (void)import
{
}

@end
