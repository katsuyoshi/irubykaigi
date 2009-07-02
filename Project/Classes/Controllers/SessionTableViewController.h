//
//  SessionTableViewController.h
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/02.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionTableViewController : UITableViewController<NSFetchedResultsControllerDelegate> {

    NSManagedObject *day;
    NSManagedObject *nextDay;
    SessionTableViewController *nextDaysSessionController;
    
	NSFetchedResultsController *fetchedResultsController;
}

@property (retain) NSManagedObject *day;
@property (retain) NSManagedObject *nextDay;
@property (retain, readonly) SessionTableViewController *nextDaysSessionController;

@property (retain, readonly) NSFetchedResultsController *fetchedResultsController;

@end
