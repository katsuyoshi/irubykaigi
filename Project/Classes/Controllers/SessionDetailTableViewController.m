//
//  SessionDetailTableViewController.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionDetailTableViewController.h"


@implementation SessionDetailTableViewController

@synthesize session;

+ (id)sharedController
{
    static id controller = nil;
    if (controller == nil) {
        controller = [[self alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return controller;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    self.title = [self.session valueForKey:@"time"];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

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

- (void)viewDidDisappear:(BOOL)animated {
    self.session = nil;
    [self.tableView reloadData];
	[super viewDidDisappear:animated];
}


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
    return ([[session valueForKey:@"break"] boolValue]) ? 1 : 3;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
    case 0:
        return 1;
    case 1:
        return [sperkers count];
    case 2:
        return 2;
    default:
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
    case 0:
        return NSLocalizedString(@"Title", nil);
    case 1:
        if ([sperkers count]) {
            return NSLocalizedString(@"Speaker", nil);
        }
        break;
    case 2:
        return NSLocalizedString(@"Room", nil);
    }
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCell"] autorelease];
            cell.textLabel.font = [UIFont fontWithName:cell.textLabel.font.fontName size:20.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.bounds = CGRectMake(0, 0, cell.textLabel.bounds.size.width, cell.textLabel.bounds.size.height * 3.0);
            cell.textLabel.numberOfLines = 4;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    switch (indexPath.section) {
    case 0:
        cell.textLabel.text = [session valueForKey:@"title"];
        break;
    case 1:
        cell.textLabel.text = [sperkers objectAtIndex:indexPath.row];
        break;
    case 2:
        if (indexPath.row == 0) {
            cell.textLabel.text = [session valueForKeyPath:@"room.name"];
        } else {
            cell.textLabel.text = [session valueForKeyPath:@"room.floor"];
        }
        break;
    }
	
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44.0 * 3;
    } else {
        return 44.0;
    }
}

- (void)dealloc {
    [session release];
    [sperkers release];
    [super dealloc];
}


#pragma mark -
#pragma mark accessor

- (void)setSession:(NSManagedObject *)aSession
{
    if (session != aSession) {
        [session release];
        session = [aSession retain];
        
        if ([[session valueForKey:@"speaker"] length]) {
            sperkers = [[[session valueForKey:@"speaker"] componentsSeparatedByString:@"、"] retain];
        } else {
            sperkers = [[NSArray array] retain];
        }
    }
}

@end

