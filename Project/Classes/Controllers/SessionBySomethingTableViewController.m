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

- (void)setArrayControllerWithSessions:(NSSet *)sessions
{
    [arrayController release];
    arrayController = [[ISSectionedArrayController alloc] initWithSet:sessions sectionName:@"dayTimeTitle" sortDescriptors:[NSSortDescriptor sortDescriptorsWithString:@"day.date, time, position"]];
    arrayController.sectionTitleName = @"self";
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

    SessionDetailedTableViewController *controller = [SessionDetailedTableViewController sessionDetailedTableViewController];

    controller.editingMode = NO;

    controller.detailedObject = [arrayController objectAtIndexPath:indexPath];

    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


@end
