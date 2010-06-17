//
//  HistoryTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/06/17.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Property.h"


@protocol HistoryTableViewControllerDelegate
- (void)didSelectHistoryItem:(NSString *)item;
@end


@interface HistoryTableViewController : UITableViewController {

    NSString *propertyKey;
    
    NSMutableArray *dataSource;
    Property *property;
    
    UIBarButtonItem *closeItemBarButton;
    
    id<HistoryTableViewControllerDelegate> delegate;
}

+ (UINavigationController *)navigationController;
+ (HistoryTableViewController *)historyTableViewController;


@property (retain) NSString *propertyKey;
@property (retain) NSMutableArray *dataSource;

@property (retain, readonly) Property *property;

@property (retain) id<HistoryTableViewControllerDelegate> delegate;

- (void)close;

@end
