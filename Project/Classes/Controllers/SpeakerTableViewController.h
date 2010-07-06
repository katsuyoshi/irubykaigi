//
//  SpeakerTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/01.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiderCoreData.h"
#import "Region.h"


@interface SpeakerTableViewController : ISCDListTableViewController {

    Region *region;
    NSArray *indexTitles;
    
    NSMutableArray *fetchedResultsControllers;
}

+ (UINavigationController *)navigationController;
+ (SpeakerTableViewController *)speakerTableViewController;

@property (retain) Region *region;

@property (retain) NSArray *indexTitles;

@end
