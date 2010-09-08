//
//  RoomTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/05.
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

#import "RoomTableViewController.h"
#import "Property.h"
#import "Region.h"
#import "SessionByRoomTableViewController.h"
#import "RoomTableViewCell.h"
#import "Room.h"
#import "Day.h"
#import "PresentSessionTableViewController.h"
#import "WebViewController.h"
#import "Importer.h"


@interface RoomTableViewController(ISPrivate)
- (void)validateControls;
@end


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
    [updateTabBarButton release];
    [dateSecmentedController release];
    [super dealloc];
}

- (void)buildDateSecmentedController
{
    int index = 0;
    
    if (dateSecmentedController == nil) {
        dateSecmentedController = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
        dateSecmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
        self.navigationItem.titleView = dateSecmentedController;
    } else {
        index = dateSecmentedController.selectedSegmentIndex;
    }
    [dateSecmentedController removeAllSegments];
    
    int i = 0;
    for (Day *day in self.region.sortedDays) {
        [dateSecmentedController insertSegmentWithTitle:day.title atIndex:i animated:NO];
        if ([day.date isEqual:[[NSDate date] beginningOfDay]]) {
            dateSecmentedController.selectedSegmentIndex = i;
        }
        i++;
    }
    
    dateSecmentedController.selectedSegmentIndex = (index < dateSecmentedController.numberOfSegments) ? index : 0;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    updateTabBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self  action:@selector(updateAction:)];
    self.navigationItem.leftBarButtonItem = updateTabBarButton;

    [self buildDateSecmentedController];
    
    [self validateControls];
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
    return 1;//3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
    case 0:
        return [super tableView:tableView numberOfRowsInSection:section];
    case 1:
        return 2;
    case 2:
        return 1;
    default:
        return 0;
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
    switch (indexPath.section) {
    case 0:
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    case 1:
        {
            if (indexPath.row == 0) {
                NSString *cellIdentifier = @"Now";
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
        
                cell.textLabel.text = NSLocalizedString(@"Present sessions", nil);
                return cell;
            } else {
                NSString *cellIdentifier = @"Next";
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
        
                cell.textLabel.text = NSLocalizedString(@"Next sessions", nil);
                return cell;
            }
        }
        break;
    case 2:
        {
            NSString *cellIdentifier = @"Floor Guid";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        
            cell.textLabel.text = NSLocalizedString(@"Floor Guid", nil);
            return cell;
        }
        break;
    }
    return nil;
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
    case 0:
        {
            SessionByRoomTableViewController *controller = [SessionByRoomTableViewController sessionTableViewController];
            controller.room = [self.fetchedResultsController objectAtIndexPath:indexPath];
            controller.day = [self selectedDay];
            [self.navigationController pushViewController:controller animated:YES];
        }
        break;
    case 1:
        {
            PresentSessionTableViewController *controller = [PresentSessionTableViewController presentSessionTableViewController];
            if (indexPath.row == 0) {
                [controller setDateNow];
            } else {
                [controller setDateNext];
            }
            controller.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:controller animated:YES];
        }
        break;
    case 2:
        {
            WebViewController *controller = [WebViewController webViewController];
            controller.url = [NSURL URLWithString:@"http://www.epochal.or.jp/floor_guide/index.html"];
            controller.domainUrl = [NSURL URLWithString:@"http://www.epochal.or.jp/"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        break;
    }
}


- (void)didChangeRegion
{
    [self reloadData];
}

- (void)updateAction:(id)sender
{
    Importer *importer = [Importer defaultImporter];
    [importer beginUpdate];
    [self validateControls];
}

- (void)validateControls
{
    Importer *importer = [Importer defaultImporter];
    updateTabBarButton.enabled = !importer.updating;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = importer.updating;
}

- (void)reloadData
{
    [self buildDateSecmentedController];
            
    self.masterObject = self.region;
    [super reloadData];
    [self validateControls];
}

@end
