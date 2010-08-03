//
//  PresentSessionTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionBySomethingTableViewController.h"


@interface PresentSessionTableViewController : SessionBySomethingTableViewController {

	NSDate *date;
    
}

+ (PresentSessionTableViewController *)presentSessionTableViewController;

@property (retain) NSDate *date;

- (void)setDateNow;
- (void)setDateNext;

// for test
- (void)setNextDateOf:(NSDate *)date;

@end
