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


@interface SessionTableViewController : ISCDListTableViewController {

    IBOutlet UISegmentedControl *dateSecmentedController;
    
    NSPredicate *datePredicate;
    
    Region *region;
}

+ (UINavigationController *)navigationController;
+ (SessionTableViewController *)sessionViewController;

@property (retain) NSPredicate *datePredicate;
@property (retain) NSPredicate *roomPredicate;


- (IBAction)selectDayAction:(id)sender;

@end
