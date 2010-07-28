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
#import "IRKTableViewController.h"


@interface SpeakerTableViewController : IRKTableViewController {

    NSArray *indexTitles;
    
    ISSectionedArrayController *arrayController;
}

+ (UINavigationController *)navigationController;
+ (SpeakerTableViewController *)speakerTableViewController;

@property (retain) Region *region;

@property (retain) NSArray *indexTitles;

- (void)reloadData;

@end
