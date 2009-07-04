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


@interface SessionTableViewController(_private)
- (NSString *)titleForDate:(NSManagedObject *)date;
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

    [self.fetchedResultsController performFetch:NULL];
}

- (NSString *)titleForDate:(NSManagedObject *)aDay
{
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
NSLog(@"%@", NSLocalizedString(@"DATE_FORMATTER_FOR_TITLE", nil));
    [formatter setDateFormat:NSLocalizedString(@"DATE_FORMATTER_FOR_TITLE", nil)];
    return [formatter stringFromDate:[aDay valueForKey:@"date"]];
}

- (NSString *)title
{
    return [self titleForDate:self.day];
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
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
	NSManagedObject *eo = [fetchedResultsController objectAtIndexPath:indexPath];
	return [[eo valueForKey:@"time"] description];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SessionTableViewCell *cell;
	NSManagedObject *eo = [fetchedResultsController objectAtIndexPath:indexPath];

    if ([[eo valueForKey:@"break"] boolValue]) {
        cell = (SessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BreakCell"];
        if (cell == nil) {
            cell = [[[SessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BreakCell"] autorelease];
/*
            cell.textLabel.backgroundColor = nil;//[UIColor redColor];
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.backgroundColor = [UIColor clearColor];
            for (UIView *view in cell.contentView.subviews) {
                view.backgroundColor = [UIColor clearColor];
            }
            cell.backgroundView = [[UIView new] autorelease];
*/
        }
    } else {
        cell = (SessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SessionCell"];
        if (cell == nil) {
            cell = [[[SessionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SessionCell"] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
/*
            cell.textLabel.opaque = NO;
//            cell.contentView.backgroundColor = [UIColor clearColor];
//            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [[UIView new] autorelease];
*/
        }
    }
    
    cell.session = eo;
/*
	cell.textLabel.text = [[eo valueForKey:@"title"] description];

    NSString *room = [eo valueForKeyPath:@"room.name"];
    NSString *speaker = [eo valueForKey:@"speaker"];
    NSMutableArray *subTitles = [NSMutableArray array];
    if (room) {
        [subTitles addObject:room];
        switch ([[eo valueForKeyPath:@"room.position"] intValue]) {
        case 1:
            cell.backgroundColor = [UIColor yellowColor];
            break;
        case 2:
            cell.backgroundColor = [UIColor greenColor];
            break;
        case 3:
            cell.backgroundColor = [UIColor cyanColor];
            break;
        }
    } else {
        cell.backgroundView.backgroundColor = [UIColor brownColor];
    }
    
    if (speaker) {
        [subTitles addObjectsFromArray:[speaker componentsSeparatedByString:@"、"]];
    }
    cell.detailTextLabel.text = [subTitles componentsJoinedByString:@" "];
*/	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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
    SessionDetailTableViewController *detailController = [SessionDetailTableViewController sharedController];
    detailController.session = [fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detailController animated:YES];
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
    Document *document = [Document sharedDocument];
    
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Session" inManagedObjectContext:document.managedObjectContext];
        [fetchRequest setEntity:entity];
	
        NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                      [[[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES] autorelease]
                                    , [[[NSSortDescriptor alloc] initWithKey:@"room.position" ascending:YES] autorelease]
                                    , [[[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES] autorelease]
                                    , nil];
	
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"day = %@", day]];
	
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:document.managedObjectContext sectionNameKeyPath:@"time" cacheName:[day description]];
	
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

@end

