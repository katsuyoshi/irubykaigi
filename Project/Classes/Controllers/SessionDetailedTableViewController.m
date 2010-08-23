//
//  SessionDetailedTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//

/* 

  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:
  
      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
 
      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.
 
      * Neither the name of ITO SOFT DESIGN Inc. nor the names of its
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#import "SessionDetailedTableViewController.h"
#import "Room.h"
#import "Speaker.h"
#import "SpeakerDetaildTableViewController.h"
#import "CiderCoreData.h"
#import "SummaryViewController.h"



#define TIME_SECTON             0
#define TITLE_SECTION           1
#define SPEAKERS_SECTION        2
#define ROOM_SECTION            3
#define ABSTRACT_SECTION        4


@implementation SessionDetailedTableViewController

+ (SessionDetailedTableViewController *)sessionDetailedTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
}

/*
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.window.backgroundColor = self.originalWindowBackbroundColor;
}
*/

- (Session *)session
{
    return (Session *)self.detailedObject;
}

- (NSInteger)sectionTypeForSection:(NSInteger)section
{
    NSString *title = [self tableView:nil titleForHeaderInSection:section];
    if ([title isEqualToString:NSLocalizedString(@"Session:title", nil)]) {
        return TITLE_SECTION;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Session:dayTimeTitle", nil)]) {
        return TIME_SECTON;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Session:speakers", nil)]) {
        return SPEAKERS_SECTION;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Session:room", nil)]) {
        return ROOM_SECTION;
    } else
    if ([title isEqualToString:NSLocalizedString(@"Session:summary", nil)]) {
        return ABSTRACT_SECTION;
    }
    return 0;
}


- (UITableViewCell *)cellForTableView:(UITableView *)tableView inSection:(NSInteger)section
{
    UITableViewCell *cell = nil;
    section = [self sectionTypeForSection:section];
    if (section == TITLE_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:20.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines = 0;
        }
    } else
    if (section == SPEAKERS_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SpeakerCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SpeakerCell"] autorelease];
        }
    } else
    if (section == ROOM_SECTION || section == TIME_SECTON) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoomCell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else
    if (section == ABSTRACT_SECTION) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AbstractCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AbstractCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:16.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.numberOfLines = 0;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
    case SPEAKERS_SECTION:
        {
                NSArray *speakers = self.session.sortedSpeakers;
            if ([speakers count]) {
                Speaker *speaker = [speakers objectAtIndex:indexPath.row];
                cell.textLabel.text = speaker.name;
                BOOL hasDisclosure = [speaker.profile length] || [speaker.belongings count];
                cell.accessoryType = hasDisclosure ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
                cell.selectionStyle = hasDisclosure ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
            } else {
                // セルの高さを計算する為にダミーのセルを返すのでnilの場合がある
            }
        }
        break;
    case ABSTRACT_SECTION:
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionTypeForSection:indexPath.section];
    switch (section) {
    case SPEAKERS_SECTION:
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell.accessoryType != UITableViewCellAccessoryNone) {
                SpeakerDetaildTableViewController *controller = [SpeakerDetaildTableViewController speakerDetailedTableViewController];
                Speaker *speaker = [self.session.sortedSpeakers objectAtIndex:indexPath.row];
                controller.detailedObject = speaker;
                controller.tableView.backgroundColor = self.tableView.backgroundColor;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        break;
    case ABSTRACT_SECTION:
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self sectionTypeForSection:indexPath.section];
    switch (section) {
    case TITLE_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"title"] indexPath:indexPath];
    case ABSTRACT_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"summary"] indexPath:indexPath];
    default:
        return 44.0;
    }
}

- (void)didChangeRegion
{
    self.detailedObject = [self.session sessionForRegion:self.region];
    [self reloadData];
}


@end
