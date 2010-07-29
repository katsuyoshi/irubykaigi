//
//  SpeakerTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/01.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SpeakerTableViewController.h"
#import "Property.h"
#import "SessionBySpeakerTableViewController.h"


@implementation SpeakerTableViewController

@synthesize indexTitles;


+ (UINavigationController *)navigationController
{
    return [[[UINavigationController alloc] initWithRootViewController:[self speakerTableViewController]] autorelease];
}

+ (SpeakerTableViewController *)speakerTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

- (void)dealloc
{
    [indexTitles release];
    [super dealloc];
}

- (NSString *)title
{
    return NSLocalizedString(@"Speaker", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    Speaker *speaker = (Speaker *)[arrayController objectAtIndexPath:indexPath];
    cell.textLabel.text = speaker.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionBySpeakerTableViewController *controller = [SessionBySpeakerTableViewController sessionTableViewController];
    controller.speaker = [arrayController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [arrayController sectionIndexTitlesForTableView:tableView];
}


/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [fetchedResultsControllers count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    NSFetchedResultsController *controller = [self fetchedResultsControllerForSection:section];
    return [[controller fetchedObjects] count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.indexTitles objectAtIndex:section];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    Speaker *speaker = [self speakerAtIndexPath:indexPath];
    cell.textLabel.text = speaker.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionBySpeakerTableViewController *controller = [SessionBySpeakerTableViewController sessionTableViewController];
    controller.speaker = [self speakerAtIndexPath:indexPath];
    [self.navigationController pushViewController:controller animated:YES];
}
*/


- (void)reloadData
{
    [arrayController release];
    arrayController = [[ISSectionedArrayController alloc] initWithSet:self.region.speakers sectionName:@"firstLetterOfName" sortDescriptors:[NSSortDescriptor sortDescriptorsWithString:@"upperCaseName, position"]];
//    arrayController.sectionTitleName = @"SELF";
    
    [self.tableView reloadData];
}





@end
