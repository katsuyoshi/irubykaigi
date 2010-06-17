//
//  SessionTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISCDListTableViewController.h"
#import "Region.h"
#import "HistoryTableViewController.h"


@interface SessionTableViewController : ISCDListTableViewController <UISearchDisplayDelegate, UISearchBarDelegate, HistoryTableViewControllerDelegate> {

    IBOutlet UISegmentedControl *dateSecmentedController;
    
    NSPredicate *datePredicate;
    NSPredicate *roomPredicate;
    NSPredicate *searchPredicate;
    NSString *searchString;
    NSArray *searchScopes;
    
    Region *region;
}

+ (UINavigationController *)navigationController;
+ (SessionTableViewController *)sessionViewController;

@property (retain) NSPredicate *datePredicate;
@property (retain) NSPredicate *roomPredicate;
@property (retain) NSPredicate *searchPredicate;

@property (copy) NSString *searchString;
@property (retain) NSArray *searchScopes;


// FIXME: @property (assign, readonly) NSPredicate *sessionPredicate;

- (IBAction)selectDayAction:(id)sender;

@end
