//
//  SessionAndLightningTalkBySomethingTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionAndLightningTalkBySomethingTableViewController.h"
#import "SessionTableViewCell.h"
#import "LightningTalkTableViewCell.h"
#import "LightningTalkDetailedTableViewController.h"


@implementation SessionAndLightningTalkBySomethingTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [arrayController objectAtIndexPath:indexPath];
    if ([object isKindOfClass:[Session class]]) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    NSString *cellIdentifier = @"LightningTalkCell";
    LightningTalkTableViewCell *cell = (LightningTalkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [LightningTalkTableViewCell lightningTalkTableViewCellWithIdentifier:cellIdentifier];
    }
    cell.lightningTalk = (LightningTalk *)object;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SessionTableViewCell class]]) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        LightningTalkDetailedTableViewController *controller = [LightningTalkDetailedTableViewController lightningTalkDetailedTableViewController];
        controller.detailedObject = ((LightningTalkTableViewCell *)cell).lightningTalk;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
