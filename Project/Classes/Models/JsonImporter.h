//
//  JsonCrudeImporter.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/30.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Importer.h"


@interface JsonImporter : Importer {

    NSURL *mainSiteURL;
    NSURL *backupSiteURL;

}

@property (retain) NSURL *mainSiteURL;
@property (retain) NSURL *backupSiteURL;


- (BOOL)importWithURL:(NSURL *)url;


@end
