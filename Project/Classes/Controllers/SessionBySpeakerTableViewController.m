//
//  SessionBySpeakerTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionBySpeakerTableViewController.h"
#import "Session.h"
#import "SessionDetailedTableViewController.h"
#import "SessionTableViewCell.h"
#import "LightningTalkTableViewCell.h"
#import "LightningTalkDetailedTableViewController.h"


@implementation SessionBySpeakerTableViewController

@synthesize speaker;

- (void)dealloc
{
    [speaker release];
    [super dealloc];
}

- (void)setSpeaker:(Speaker *)aSpeaker
{
    [speaker release];
    speaker = [aSpeaker retain];
    
    self.title = speaker.name;
    [self reloadData];
}

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



- (void)reloadData
{
    NSMutableSet *sessions = [speaker.sessions mutableCopy];
    [sessions addObjectsFromArray:[speaker.lightningTalks allObjects]];
    
    [self setArrayControllerWithSessionSet:sessions];
}

@end
