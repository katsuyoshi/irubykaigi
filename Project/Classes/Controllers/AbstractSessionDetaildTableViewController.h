//
//  AbstractSessionDetaildTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRKDetaildTableViewController.h"
#import "Session.h"


@interface AbstractSessionDetaildTableViewController : IRKDetaildTableViewController {

}

@property (assign, readonly) Session *session;

- (CGFloat)cellHeightForTableView:(UITableView *)tableView text:(NSString *)text indexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)cellForTableView:(UITableView *)tableView inSection:(NSInteger)section;


@end
