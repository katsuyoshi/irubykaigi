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



@interface SessionTableViewController(IRKPrivate)
- (void)buildSearchDisplayController;
- (void)buildDateSecmentedController;
@end


@implementation SessionTableViewController

@synthesize datePredicate, roomPredicate, searchPredicate;
@dynamic sessionPredicate;



+ (UINavigationController *)navigationController
{
    return [[[UINavigationController alloc] initWithRootViewController:[self sessionViewController]] autorelease];
}

+ (SessionTableViewController *)sessionViewController
{
    return [[[SessionTableViewController alloc] initWithNibName:@"SessionTableViewController" bundle:nil] autorelease];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    region = [Property sharedProperty].japanese ? [Region japanese] : [Region english];
    [region retain];

    self.navigationItem.titleView = dateSecmentedController;

    [self buildSearchDisplayController];
    [self buildDateSecmentedController];
}

- (void)buildSearchDisplayController
{
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    
    self.tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height);
    
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:
                        NSLocalizedString(@"All", nil),
                        NSLocalizedString(@"Advanced", nil), nil];
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
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [datePredicate release];
    [roomPredicate release];
    [searchPredicate release];
    
    [dateSecmentedController release];
    [super dealloc];
}


#pragma mark -
#pragma mark properties

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

#pragma mark -

- (void)resetFetchedResultController
{
    _fetchedResultsController.delegate = nil;
    [_fetchedResultsController release];
    _fetchedResultsController = nil;
}

- (void)reloadData
{
    [self resetFetchedResultController];
    [super reloadData];
}



#pragma mark -
#pragma mark ISCDListTableViewController

- (void)setUpEntityAndAttributeIfNeeds
{
    self.entityName = @"Session";
    self.displayKey = @"title";
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Return YES to cause the search result table view to be reloaded.
    return NO;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}

@end

