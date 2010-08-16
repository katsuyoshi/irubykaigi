//
//  SpeakerDetaildTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/08/12.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SpeakerDetaildTableViewController.h"
#import "Speaker.h"
#import "SummaryViewController.h"



#define NAME_SECTON             0
#define BELONGING_SECTION       1
#define PROFILE_SECTION         2

@implementation SpeakerDetaildTableViewController

+ (SpeakerDetaildTableViewController *)speakerDetailedTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
}

- (NSString *)title
{
    return self.speaker.name;
}

- (Speaker *)speaker
{
    return (Speaker *)self.detailedObject;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == BELONGING_SECTION) {
        return [self.speaker.belongings count];
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (NSInteger)sectionTypeForSection:(NSInteger)section
{
    NSString *title = [self tableView:nil titleForHeaderInSection:section];
    if ([title isEqualToString:NSLocalizedString(@"Speaker:name", nil)]) {
        return NAME_SECTON;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Speaker:belongings", nil)]) {
        return BELONGING_SECTION;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Speaker:profile", nil)]) {
        return PROFILE_SECTION;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionTypeForSection:indexPath.section];
    switch (section) {
    case NAME_SECTON:
        return [self cellHeightForTableView:tableView text:self.speaker.name indexPath:indexPath];
    case BELONGING_SECTION:
        return [self cellHeightForTableView:tableView text:[[self.speaker.sortedBelongings objectAtIndex:indexPath.row] valueForKey:@"title"] indexPath:indexPath];
    case PROFILE_SECTION:
        return [self cellHeightForTableView:tableView text:self.speaker.profile indexPath:indexPath];
    default:
        return 44.0;
    }
}


- (UITableViewCell *)cellForTableView:(UITableView *)tableView inSection:(NSInteger)section
{
    UITableViewCell *cell = nil;
    section = [self sectionTypeForSection:section];
    if (section == NAME_SECTON) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NameCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:20.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
        }
    } else
    if (section == BELONGING_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BelongingCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BelongingCell"] autorelease];
        }
    } else
    if (section == PROFILE_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:16.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.numberOfLines = 0;
        }
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
    case PROFILE_SECTION:
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionTypeForSection:indexPath.section];
    switch (section) {
    case PROFILE_SECTION:
        {
            SummaryViewController *controller = [SummaryViewController summaryViewController];
            controller.text = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:controller animated:YES];
        }
        break;
    default:
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


- (void)didChangeRegion
{
    self.detailedObject = [self.speaker speakerForRegion:self.region];
    [self reloadData];
}


@end
