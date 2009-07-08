//
//  LightningTalksTableViewController.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalksTableViewController.h"
#import "Document.h"
#import "NSManagedObjectExtension.h"
#import "LightningTalk.h"
#import "LightningTalksDetailTableViewController.h"


@implementation LightningTalksTableViewController

@synthesize session, fetchedResultsController;

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

    self.title = [self.session valueForKeyPath:@"time"];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.fetchedResultsController performFetch:NULL];
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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.session valueForKey:@"title"];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.backgroundView = [[UIView new] autorelease];
    }
    
	NSManagedObject *talk = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [talk valueForKey:@"title"];

    NSMutableArray *subTitles = [NSMutableArray array];
    NSString *room = [talk valueForKeyPath:@"room.name"];
    if (room) {
        [subTitles addObject:room];
    }
    [subTitles addObjectsFromArray:[[talk mutableSetValueForKey:@"speakers"] valueForKey:@"name"]];
    cell.detailTextLabel.text = [subTitles componentsJoinedByString:@" "];
    
    cell.backgroundView.backgroundColor = [session sessionColor]; 
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{    
    LightningTalk *talk = [fetchedResultsController objectAtIndexPath:indexPath];

    LightningTalksDetailTableViewController *controller = [[[LightningTalksDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    controller.talk = talk;
    [self.navigationController pushViewController:controller animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


- (void)dealloc {
    [session release];
    [fetchedResultsController release];
    [super dealloc];
}


#pragma mark -
#pragma mark property

- (NSFetchedResultsController *)fetchedResultsController {
    Document *document = [Document sharedDocument];
    
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LightningTalk" inManagedObjectContext:document.managedObjectContext];
        [fetchRequest setEntity:entity];
	
        NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                      [[[NSSortDescriptor alloc] initWithKey:@"session.day.date" ascending:YES] autorelease]
                                    , [[[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES] autorelease]
                                    , nil];
	
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"session = %@", session]];
	
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:document.managedObjectContext sectionNameKeyPath:nil cacheName:[session description]];
	
	}
	return fetchedResultsController;
}    



@end
