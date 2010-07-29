//
//  SessionBySomethingTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionBySomethingTableViewController.h"
#import "SessionTableViewCell.h"
#import "SessionDetailedTableViewController.h"
#import "Property.h"
#import "LightningTalkTableViewController.h"


@implementation SessionBySomethingTableViewController

+ (UINavigationController *)navigationController
{
    return [[[UINavigationController alloc] initWithRootViewController:[self sessionTableViewController]] autorelease];
}

+ (id)sessionTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

- (void)dealloc
{
    [arrayController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)setArrayControllerWithSessionArray:(NSArray *)sessions
{
    [self setArrayControllerWithSessionSet:[NSSet setWithArray:sessions]];
}

- (void)setArrayControllerWithSessionSet:(NSSet *)sessions
{
    [self setArrayControllerWithSessionSet:sessions sortDescriptors:nil];
}

- (void)setArrayControllerWithSessionSet:(NSSet *)sessions sortDescriptors:(NSArray *)sortDescriptors
{
    if (sortDescriptors == nil) {
        sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"day.date, time, position"];
    }
    [arrayController release];
    arrayController = [[ISSectionedArrayController alloc] initWithSet:sessions sectionName:@"dayTimeTitle" sortDescriptors:sortDescriptors];
    arrayController.sectionTitleName = @"self";
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayController numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayController tableView:tableView numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [arrayController tableView:tableView titleForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    SessionTableViewCell *cell = (SessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [SessionTableViewCell sessionTableViewCellWithIdentifier:cellIdentifier];
    }
    cell.session = [arrayController objectAtIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SessionTableViewCell *cell = (SessionTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.session.isLightningTalks == NO) {
        SessionDetailedTableViewController *controller = [SessionDetailedTableViewController sessionDetailedTableViewController];
        controller.editingMode = NO;
        controller.detailedObject = [arrayController objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        LightningTalkTableViewController *controller = [LightningTalkTableViewController lightningTalksTableViewController];
        controller.masterObject = cell.session;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}



@end
