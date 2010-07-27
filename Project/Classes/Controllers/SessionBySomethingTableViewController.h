//
//  SessionBySomethingTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiderCoreData.h"
#import "Region.h"


@interface SessionBySomethingTableViewController : UITableViewController {

    ISSectionedArrayController *arrayController;

}

@property (assign, readonly) Region *region;

+ (UINavigationController *)navigationController;
+ (id)sessionTableViewController;

- (void)setArrayControllerWithSessionArray:(NSArray *)sessions;
- (void)setArrayControllerWithSessionSet:(NSSet *)sessions;

- (void)reloadData;

@end
