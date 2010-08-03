//
//  RoomTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/05.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "RoomTableViewController.h"
#import "Property.h"
#import "Region.h"
#import "SessionByRoomTableViewController.h"
#import "RoomTableViewCell.h"
#import "Room.h"
#import "Day.h"
#import "PresentSessionTableViewController.h"


@implementation RoomTableViewController

+ (UINavigationController *)navigationController
{
    return [[[UINavigationController alloc] initWithRootViewController:[self sessionByRoomTableViewController]] autorelease];
}

+ (RoomTableViewController *)sessionByRoomTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

- (NSString *)title
{
    return NSLocalizedString(@"Room", nil);
}

- (void)dealloc
{
    [dateSecmentedController release];
    [super dealloc];
}

- (void)buildDateSecmentedController
{
    int i = 0;
    
    if (dateSecmentedController == nil) {
        dateSecmentedController = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        dateSecmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
    }
    [dateSecmentedController removeAllSegments];
    
    for (Day *day in self.region.sortedDays) {
        [dateSecmentedController insertSegmentWithTitle:day.title atIndex:i animated:NO];
        if ([day.date isEqual:[[NSDate date] beginningOfDay]]) {
            dateSecmentedController.selectedSegmentIndex = i;
        }
        i++;
    }
    if (dateSecmentedController.selectedSegmentIndex == -1) {
        dateSecmentedController.selectedSegmentIndex = 0;
    }
    
    self.navigationItem.titleView = dateSecmentedController;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self buildDateSecmentedController];
}

#pragma mark -
#pragma mark properties

- (Day *)selectedDay
{
    return [self.region.sortedDays objectAtIndex:dateSecmentedController.selectedSegmentIndex];
}


#pragma mark -
#pragma mark ISCDListTableViewController

- (void)setUpEntityAndAttributeIfNeeds
{
    self.entityName = @"Room";
    self.displayKey = @"name";

    self.detailedTableViewControllerClassName = @"SessionDetailedTableViewController";
    self.hasDetailView = YES;
        
    self.masterObject = self.region;
    self.hasEditButtonItem = NO;
}

#pragma mark -
#pragma mark extend ISCDListTableViewController
// indexPathはsessionが0に変わっている

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RoomTableViewCell *aCell = (RoomTableViewCell *)cell;
    
    aCell.room = (Room *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark -
- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    return [RoomTableViewCell roomTableViewCellWithIdentifier:cellIdentifier];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [super tableView:tableView numberOfRowsInSection:section];
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Rooms", nil);
    } else {
        return NSLocalizedString(@" ", nil);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        NSString *cellIdentifier = @"Now";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = NSLocalizedString(@"Present sessions", nil);
        return cell;
    }
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SessionByRoomTableViewController *controller = [SessionByRoomTableViewController sessionTableViewController];
        controller.room = [self.fetchedResultsController objectAtIndexPath:indexPath];
        controller.day = [self selectedDay];
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        PresentSessionTableViewController *controller = [PresentSessionTableViewController presentSessionTableViewController];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void)didChangeRegion
{
    int index = dateSecmentedController.selectedSegmentIndex;
    [self buildDateSecmentedController];
    dateSecmentedController.selectedSegmentIndex = index;
            
    self.masterObject = self.region;
    [self reloadData];
}

@end
