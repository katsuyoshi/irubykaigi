//
//  SessionDetailedTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionDetailedTableViewController.h"
#import "Room.h"


#define TITLE_SECTION           0
#define SPEAKERS_SECTION        1
#define ROOM_SECTION            2
#define ABSTRACT_SECTION        3
#define SPEAKER_PROFILE_SECTION 4


@implementation SessionDetailedTableViewController

+ (SessionDetailedTableViewController *)sessionDetailedTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithTitle:self.navigationItem.backBarButtonItem.title style:UIBarButtonItemStylePlain target:self action:@selector(backAction)] autorelease];
    self.navigationItem.leftBarButtonItem = backButton;

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if (self.session) {
        if (self.session.room) {
            if (self.session.room.roomColor) {
                self.tableView.backgroundColor = self.session.room.roomColor;
            }
        }
    }
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


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (section == ABSTRACT_SECTION || section == SPEAKER_PROFILE_SECTION) {
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


- (CGFloat)cellHeightForTableView:(UITableView *)tableView text:(NSString *)text indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cellForTableView:tableView inSection:indexPath.section];
    UIFont *fount = [UIFont fontWithName:cell.textLabel.font.fontName size:17];
    CGSize size = [text sizeWithFont:fount constrainedToSize:CGSizeMake(cell.bounds.size.width, 44.0 * 300)];
    float height = size.height + 44.0;

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
    case TITLE_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"title"] indexPath:indexPath];
    case ABSTRACT_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"summary"] indexPath:indexPath];
    case SPEAKER_PROFILE_SECTION:
        return [self cellHeightForTableView:tableView text:[self.detailedObject valueForKey:@"profile"] indexPath:indexPath];
    default:
        return 44.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *referenceCell = [self cellForTableView:tableView inSection:indexPath.section];
    UITableViewCell *cell = [super tableView:tableView  cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = referenceCell.textLabel.font;
    cell.textLabel.numberOfLines = 0;
    return cell;
}


@end
