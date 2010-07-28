//
//  LightningTalksDetailTableViewController.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalkDetailedTableViewController.h"
#import "Room.h"

#define TITLE_SECTION           0
#define SPEAKERS_SECTION        1
#define ROOM_SECTION            2
#define ABSTRACT_SECTION        3



@implementation LightningTalkDetailedTableViewController

+ (LightningTalkDetailedTableViewController *)lightningTalkDetailedTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
}


- (Session *)session
{
    return self.lightningTalk.session;
}

- (LightningTalk *)lightningTalk
{
    return (LightningTalk *)self.detailedObject;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView inSection:(NSInteger)section
{
    UITableViewCell *cell = nil;
    if (section == TITLE_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:20.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 10;
        }
    } else
    if (section == SPEAKERS_SECTION || section == ROOM_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HasDetailCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HasDetailCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else
    if (section == ABSTRACT_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DescriptionCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DescriptionCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:16.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 100;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
    case TITLE_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"title"] indexPath:indexPath];
    case ABSTRACT_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"summary"] indexPath:indexPath];
    default:
        return 44.0;
    }
}


@end
