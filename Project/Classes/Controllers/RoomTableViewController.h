//
//  RoomTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/05.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRKListTableViewController.h"


@interface RoomTableViewController : IRKListTableViewController {

    UISegmentedControl *dateSecmentedController;
    UIBarButtonItem *updateTabBarButton;
    
}

+ (UINavigationController *)navigationController;
+ (RoomTableViewController *)sessionByRoomTableViewController;

- (void)updateAction:(id)sender;

@end
