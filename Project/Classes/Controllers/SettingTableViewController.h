//
//  SettingTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRKTableViewController.h"
#import "Property.h"


@interface SettingTableViewController : UITableViewController {

    NSArray *links;
    NSArray *acknowledgements;
    NSArray *frameworks;
    
    NSURL *clickedURL;
    
    Property *property;
}

+ (UINavigationController *)navigationController;
+ (SettingTableViewController *)settingTableViewController;

@property (retain) NSURL *clickedURL;


- (void)didChangeRegion:(id)sender;

- (void)openClickedURL;


@end
