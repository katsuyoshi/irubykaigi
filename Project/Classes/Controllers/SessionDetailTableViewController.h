//
//  SessionDetailTableViewController.h
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionDetailTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {

    NSManagedObject *session;
    NSArray *sperkers;

}

@property (retain) NSManagedObject *session;

@end
