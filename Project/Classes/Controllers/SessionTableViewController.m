//
//  SessionTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewController.h"
#import "Property.h"
#import "Region.h"
#import "Day.h"
#import "SessionTableViewCell.h"



@interface SessionTableViewController(IRKPrivate)
- (void)buildSearchDisplayController;
- (void)buildDateSecmentedController;
@end


@implementation SessionTableViewController

@synthesize datePredicate, roomPredicate;
// FIXM: @dynamic sessionPredicate;



+ (UINavigationController *)navigationController
{
    return [[[UINavigationController alloc] initWithRootViewController:[self sessionViewController]] autorelease];
}

+ (SessionTableViewController *)sessionViewController
{
    return [[[SessionTableViewController alloc] initWithNibName:@"SessionTableViewController" bundle:nil] autorelease];
}

- (NSString *)title
{
    return NSLocalizedString(@"Date", nil);
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
}

- (void)buildSearchDisplayController
{
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    
    self.tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height);
    
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                        NSLocalizedString(@"All", nil),
                        NSLocalizedString(@"Session", nil),
                        NSLocalizedString(@"Speaker", nil),
                        nil];
}

- (void)buildDateSecmentedController
{
    int i = 0;    
    [dateSecmentedController removeAllSegments];
    for (Day *day in region.sortedDays) {
        [dateSecmentedController insertSegmentWithTitle:day.title atIndex:i++ animated:NO];
    }
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Memory management


- (void)dealloc {    
    [region release];
    
    [datePredicate release];
    [roomPredicate release];
    
    [dateSecmentedController release];
    [super dealloc];
}

#pragma mark -
#pragma mark properties

- (void)setMasterObject:(NSManagedObject *)object
{
    [super setMasterObject:object];
    
    Day *day = (Day *)object;
    int index = [day.region.sortedDays indexOfObject:day];
    dateSecmentedController.selectedSegmentIndex = index;
    [self reloadData];
}


/* FIXME:
- (NSPredicate *)sessionPredicate
{
    NSMutableArray *predicates = [NSMutableArray array];
    if (self.datePredicate) {
        [predicates addObject:self.datePredicate];
    }
    if (self.roomPredicate) {
        [predicates addObject:self.roomPredicate];
    }
    if (self.searchPredicate) {
        [predicates addObject:self.searchPredicate];
    }
    NSPredicate *predicate = nil;
    for (NSPredicate *aPredicate in predicates) {
        if (predicate == nil) {
            predicate = aPredicate;
        } else {
            predicate = [NSPredicate predicateWithFormat:@"%@ and %@", predicate, aPredicate];
        }
    }
    return predicate;
}
*/

#pragma mark -

- (void)reloadData
{
    [self resetFetchedResultController];
    [super reloadData];
}


- (void)refetch
{
    [self resetFetchedResultController];
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
#ifdef DEBUG
    if (error) [error showErrorForUserDomains];
#endif
}

#pragma mark -
#pragma mark ISCDListTableViewController

- (void)setUpEntityAndAttributeIfNeeds
{
    self.entityName = @"Session";
    self.displayKey = @"title";
    self.sectionNameKeyPath = @"time";

    self.detailedTableViewControllerClassName = @"SessionDetailedTableViewController";
    self.hasDetailView = YES;
    

    region = [Property sharedProperty].japanese ? [Region japanese] : [Region english];
    [region retain];

    self.navigationItem.titleView = dateSecmentedController;
    [self buildSearchDisplayController];
    [self buildDateSecmentedController];

    if ([region.sortedDays count]) {
        self.masterObject = [region.sortedDays objectAtIndex:0];
    }
    
}


#pragma mark -
#pragma mark actions

- (void)selectDayAction:(id)sender
{
    self.masterObject = [region.sortedDays objectAtIndex:dateSecmentedController.selectedSegmentIndex];
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (NSPredicate *)likePredicateForKey:(NSString *)key string:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"*%@*", string];
    return [NSPredicate predicateWithFormat:@"%K LIKE[c] %@", key, str];
}



#pragma mark -

- (UITableViewCell *)createCellWithIdentifier:(NSString *)cellIdentifier
{
    return [SessionTableViewCell sessionTableViewCellWithIdentifier:cellIdentifier];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    SessionTableViewCell *cell = (SessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = (SessionTableViewCell *)[self createCellWithIdentifier:cellIdentifier];
    }
    cell.session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}





@end

