//
//  RoomTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/05.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CiderCoreData.h"

@class Region;

@interface RoomTableViewController : ISCDListTableViewController {

    UISegmentedControl *dateSecmentedController;
    
}

+ (UINavigationController *)navigationController;
+ (RoomTableViewController *)sessionByRoomTableViewController;

@property (assign, readonly) Region *region;

@end
