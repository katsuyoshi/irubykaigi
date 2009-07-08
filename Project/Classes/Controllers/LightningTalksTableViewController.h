//
//  LightningTalksTableViewController.h
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LightningTalksTableViewController : UITableViewController {

    NSManagedObject *session;
    
	NSFetchedResultsController *fetchedResultsController;
}

@property (retain) NSManagedObject *session;

@property (retain, readonly) NSFetchedResultsController *fetchedResultsController;

@end
