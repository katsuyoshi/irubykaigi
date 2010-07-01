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
// FIXM: @dynamic sessionPredicate;

@synthesize searchString, searchScopes;


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

    self.title = NSLocalizedString(@"Date", nil);
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


- (void)dealloc {
    [searchString release];
    [searchScopes release];
    
    [region release];
    
    [datePredicate release];
    [roomPredicate release];
    [searchPredicate release];
    
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

- (NSPredicate *)predicate
{
    return self.searchPredicate;
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

- (BOOL)buildSearchPredicateAndRefetchIfNeeds
{
    if (self.searchScopes && [self.searchString length]) {
        NSMutableArray *predicates = [NSMutableArray array];
        for (NSString *scope in self.searchScopes) {
            [predicates addObject:[self likePredicateForKey:scope string:self.searchString]];
        }
        self.searchPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    } else {
        self.searchPredicate = nil;
    }

    BOOL needsRefetch = self.searchPredicate ? YES : NO;
    if (needsRefetch) {
        // table viewのreloadDataはUISearchDisplayDelegateが行うのでfetchだけにする
        // table viewもやってしまうとScopeを切替えた時に、セクションタイトルが二重に表示されたりする
        [self refetch];
        // が行が多い状態から検索で少なくなり、フリックで下を表示しようとすると
        // ストックされてるセルを再表示しようとしてデータがなくてExceptionが発生するので
        // reloadDataに戻す
        // がSerchBarをfirstResponderにしてなかった為だったので再度refetchのみ
        // [self reloadData];
    }
    return needsRefetch;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)aSearchString
{
    self.searchString = aSearchString;
    return [self buildSearchPredicateAndRefetchIfNeeds];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    switch (searchOption) {
    case 0: // ALL
        self.searchScopes = nil;
        break;
    case 1: // Session
        self.searchScopes = [NSArray arrayWithObjects:@"title", @"summary", nil];
        break;
    case 2: // Speaker
        self.searchScopes = [NSArray arrayWithObjects:@"profile", @"speakerRawData", nil];
        break;
    }
    return [self buildSearchPredicateAndRefetchIfNeeds];
}

- (NSArray *)searchScopes
{
    if (searchScopes == nil || [searchScopes count] == 0) {
        self.searchScopes = [NSArray arrayWithObjects:@"title", @"profile", @"summary", @"speakerRawData", nil];
    }
    return searchScopes;
}

#pragma mark -
#pragma mark UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchPredicate = nil;
    [self reloadData];
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    [self.searchDisplayController.searchBar becomeFirstResponder];

    UINavigationController *navigationController = [HistoryTableViewController navigationController];
    HistoryTableViewController *controller = (HistoryTableViewController *)navigationController.visibleViewController;
    controller.propertyKey = @"sessionSearchHistories";
    controller.delegate = self;
    
    [self presentModalViewController:navigationController animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    if ([key length]) {
        Property *property = [Property sharedProperty];
        NSMutableArray *array = [[[property sessionSearchHistories] mutableCopy] autorelease];
        if ([array containsObject:key]) {
            [array removeObject:key];
        }
        [array insertObject:key atIndex:0];
        property.sessionSearchHistories = array;
    }
}

#pragma mark -
#pragma mark HistoryTableViewControllerDelegate

- (void)didSelectHistoryItem:(NSString *)item
{
    self.searchDisplayController.searchBar.text = item;
}


@end

