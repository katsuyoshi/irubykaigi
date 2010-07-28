//
//  FindTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/23.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionAndLightningTalkBySomethingTableViewController.h"
#import "Region.h"
#import "HistoryTableViewController.h"

typedef enum {
    SearchScopeAll,
    SearchScopeSession,
    SearchScopeSpeaker
} SearchScopeType;

@interface FindTableViewController : SessionAndLightningTalkBySomethingTableViewController <UISearchDisplayDelegate, UISearchBarDelegate, HistoryTableViewControllerDelegate>  {
    
    NSString *searchString;
    SearchScopeType scopeType;
    
    IBOutlet UISearchBar *searchBar;
}

+ (UINavigationController *)navigationController;
+ (FindTableViewController *)findViewController;


@property (copy) NSString *searchString;



@end
