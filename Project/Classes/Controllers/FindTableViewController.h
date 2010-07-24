//
//  FindTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/23.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISCDListTableViewController.h"
#import "Region.h"
#import "HistoryTableViewController.h"


@interface FindTableViewController : ISCDListTableViewController <UISearchDisplayDelegate, UISearchBarDelegate, HistoryTableViewControllerDelegate>  {

    IBOutlet UISegmentedControl *dateSecmentedController;
    
    NSPredicate *datePredicate;
    NSPredicate *roomPredicate;
    NSPredicate *searchPredicate;
    NSString *searchString;
    NSArray *searchScopes;
    
    Region *region;
}

+ (UINavigationController *)navigationController;
+ (FindTableViewController *)sessionViewController;

@property (retain) NSPredicate *datePredicate;
@property (retain) NSPredicate *roomPredicate;
@property (retain) NSPredicate *searchPredicate;

@property (copy) NSString *searchString;
@property (retain) NSArray *searchScopes;


// FIXME: @property (assign, readonly) NSPredicate *sessionPredicate;

- (IBAction)selectDayAction:(id)sender;


@end
