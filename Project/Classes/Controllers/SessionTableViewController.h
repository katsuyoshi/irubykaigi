//
//  SessionTableViewController.h
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/02.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionTableViewController : UITableViewController<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> {

    NSDate *day;
    NSDate *nextDay;
    SessionTableViewController *parent;
    SessionTableViewController *nextDaysSessionController;
    
	NSFetchedResultsController *fetchedResultsController;
    
    NSInvocationOperation *updateOperation;
}

@property (retain) NSDate *day;
@property (retain) NSDate *nextDay;
@property (retain) SessionTableViewController *parent;
@property (retain, readonly) SessionTableViewController *nextDaysSessionController;

@property (retain, readonly) NSFetchedResultsController *fetchedResultsController;


- (void)previousDayAction:(id)sender;
- (void)nextDayAction:(id)sender;

- (void)beginUpdate:(id)sender;


@end
