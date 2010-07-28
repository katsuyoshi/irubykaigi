//
//  LightningTalksTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/25.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalkTableViewController.h"
#import "LightningTalkTableViewCell.h"


@implementation LightningTalkTableViewController

+ (LightningTalkTableViewController *)lightningTalksTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

#pragma mark -
#pragma mark ISCDListTableViewController

- (void)setUpEntityAndAttributeIfNeeds
{
    self.entityName = @"LightningTalk";
    self.displayKey = @"title";
    self.detailedTableViewControllerClassName = @"LightningTalkDetailedTableViewController";
}

- (NSString *)title
{
    return [self.masterObject valueForKey:@"title"];
}


- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    return [LightningTalkTableViewCell lightningTalkTableViewCellWithIdentifier:cellIdentifier];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LightningTalkTableViewCell *aCell = (LightningTalkTableViewCell *)cell;
    
    aCell.lightningTalk = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

@end
