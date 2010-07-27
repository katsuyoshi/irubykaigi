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
    dateSecmentedController = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    dateSecmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
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

- (Region *)region
{
    return [Property sharedProperty].japanese ? [Region japanese] : [Region english];
}

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
    self.sectionNameKeyPath = @"floor";

    self.detailedTableViewControllerClassName = @"SessionDetailedTableViewController";
    self.hasDetailView = YES;
    
    self.sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"floor, name"];
    
    self.predicate = [NSPredicate predicateWithFormat:@"region = %@", self.region];
    self.hasEditButtonItem = NO;
}

- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    return [RoomTableViewCell roomTableViewCellWithIdentifier:cellIdentifier];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RoomTableViewCell *aCell = (RoomTableViewCell *)cell;
    
    aCell.room = (Room *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionByRoomTableViewController *controller = [SessionByRoomTableViewController sessionTableViewController];
    controller.room = [self.fetchedResultsController objectAtIndexPath:indexPath];
    controller.day = [self selectedDay];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
