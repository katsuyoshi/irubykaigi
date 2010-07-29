//
//  SettingTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRKTableViewController.h"


@interface SettingTableViewController : UITableViewController {

}

+ (UINavigationController *)navigationController;
+ (SettingTableViewController *)settingTableViewController;


- (void)didChangeRegion:(id)sender;


@end
