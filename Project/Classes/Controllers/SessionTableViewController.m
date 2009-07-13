//
//  SessionTableViewController.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/02.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewController.h"
#import "Document.h"
#import "SessionDetailTableViewController.h"
#import "SessionTableViewCell.h"
#import "LightningTalksTableViewController.h"


@interface SessionTableViewController(_private)
- (NSString *)titleForDate:(NSDate *)date;
@end


@implementation SessionTableViewController

@synthesize day, nextDay, parent, fetchedResultsController;


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor clearColor];

    if (self.parent) {
        UIBarButtonItem *buttonItem = [[[UIBarButtonItem alloc] initWithTitle:[self titleForDate:parent.day] style:UIBarButtonItemStyleBordered target:self action:@selector(previousDayAction:)] autorelease];
        self.navigationItem.leftBarButtonItem = buttonItem;
    }

    if (self.nextDay) {
        UIBarButtonItem *buttonItem = [[[UIBarButtonItem alloc] initWithTitle:[self titleForDate:self.nextDay] style:UIBarButtonItemStyleBordered target:self action:@selector(nextDayAction:)] autorelease];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    
    UIBarButtonItem *updateButtonItems = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(beginUpdate:)] autorelease];
    NSArray *items = [NSArray arrayWithObject:updateButtonItems];
    [self setToolbarItems:items animated:NO];
    
    [[Document sharedDocument] addObserver:self forKeyPath:@"managedObjectContext" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (NSString *)titleForDate:(NSDate *)aDay
{
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:NSLocalizedString(@"LOCALE", nil)] autorelease]];
    [formatter setDateFormat:NSLocalizedString(@"DATE_FORMATTER_FOR_TITLE", nil)];
    return [formatter stringFromDate:aDay];
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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
	NSManagedObject *eo = [self.fetchedResultsController objectAtIndexPath:indexPath];
	return [eo valueForKey:@"time"];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionTableViewCell *cell;
	NSManagedObject *eo = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if ([[eo valueForKey:@"break"] boolValue]) {
        cell = (SessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BreakCell"];
        if (cell == nil) {
            cell = [[[SessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BreakCell"] autorelease];
        }
    } else {
        cell = (SessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
        if (cell == nil) {
            cell = [[[SessionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SessionCell"] autorelease];
        }
        cell.accessoryType = [eo valueForKey:@"attention"] ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    cell.session = eo;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *session = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[Document sharedDocument] changeFavoriteOfSession:session];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{    
    NSManagedObject *session = [self.fetchedResultsController objectAtIndexPath:indexPath];

    if ([[session mutableSetValueForKey:@"lightningTalks"] count]) {
        LightningTalksTableViewController *controller = [[[LightningTalksTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        controller.session = session;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        SessionDetailTableViewController *controller = [[[SessionDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        controller.session = session;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}



- (void)dealloc {
    [day release];
    [nextDay release];
    [parent release];
    [nextDaysSessionController release];
    [fetchedResultsController release];
    [super dealloc];
}


#pragma mark -
#pragma mark accessor

- (void)setDay:(NSDate *)aDay
{
    if (day != aDay) {
        [day release];
        day = [aDay retain];
        
        self.title = [self titleForDate:day];
    }
}

- (SessionTableViewController *)nextDaysSessionController
{
    if (nextDaysSessionController == nil) {
        nextDaysSessionController = [[SessionTableViewController alloc] initWithStyle:UITableViewStylePlain];
        nextDaysSessionController.day = self.nextDay;
        nextDaysSessionController.parent = self;
    }
    return nextDaysSessionController;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController == nil) {
        Document *document = [Document sharedDocument];
        NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:document.managedObjectContext];
        [fetchRequest setEntity:entity];
	
        NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                      [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES] autorelease]
                                    , [[[NSSortDescriptor alloc] initWithKey:@"room.position" ascending:YES] autorelease]
                                    , [[[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES] autorelease]
                                    , nil];
	
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"day.date = %@", day]];
	
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:document.managedObjectContext sectionNameKeyPath:@"time" cacheName:[day description]];
	
        [self.fetchedResultsController performFetch:NULL];
	}
	return fetchedResultsController;
}    


#pragma mark -
#pragma mark actions

- (void)previousDayAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextDayAction:(id)sender
{
    [self.navigationController pushViewController:self.nextDaysSessionController animated:YES];
}


- (void)beginUpdate:(id)sender
{
    if (updateOperation == nil) {
        updateOperation = [[NSInvocationOperation alloc] initWithTarget:[Document sharedDocument] selector:@selector(update) object:(id)nil];
        [updateOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        [updateOperation start];
    }
}

#pragma mark -
#pragma mark KVO notification

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isFinished"]) {
        [self.tableView reloadData];
        [updateOperation release];
        updateOperation = nil;
    } else
    if ([keyPath isEqualToString:@"managedObjectContext"]) {
        [fetchedResultsController release];
        fetchedResultsController = nil;
        self.fetchedResultsController;
        [self.tableView reloadData];
    }

}

@end

