//
//  SessionTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISCDListTableViewController.h"


@interface SessionTableViewController : ISCDListTableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {

    IBOutlet UISegmentedControl *dateSecmentedController;
    
    NSPredicate *datePredicate;
    NSPredicate *roomPredicate;
    NSPredicate *searchPredicate;
    
}

+ (UINavigationController *)navigationController;
+ (SessionTableViewController *)sessionViewController;

@property (retain) NSPredicate *datePredicate;
@property (retain) NSPredicate *roomPredicate;
@property (retain) NSPredicate *searchPredicate;

@property (assign, readonly) NSPredicate *sessionPredicate;


@end
