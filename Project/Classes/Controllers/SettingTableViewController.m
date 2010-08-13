//
//  SettingTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Property.h"


#define REGION_SECTION              0
#define INFORMATION_SECTION         1
#define LINK_SECTION                2
#define ACKNOWLEDGEMENT_SECTION     3
#define FRAMEWORK_SECTION           4

#define COUNT_OF_SECTIONS           5

@implementation SettingTableViewController

@synthesize clickedURL;


+ (UINavigationController *)navigationController
{
    return [[[UINavigationController alloc] initWithRootViewController:[self settingTableViewController]] autorelease];
}

+ (SettingTableViewController *)settingTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
}


#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    links = [[NSArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:@"RubyKaigi 2010", @"title", @"http://rubykaigi.org/2010/", @"url", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"日本 Ruby 会議 2010 直前特集号", @"title", @"http://jp.rubyist.net/magazine/?preRubyKaigi2010", @"url", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Tsukuba International Congress Center", @"title", @"http://www.epochal.or.jp/", @"url", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"ITO SOFT DESIGN Inc.", @"title", @"http://iphone.itosoft.com/", @"url", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"myPhotoViewer", @"title", @"http://itunes.apple.com/jp/app/myphotoviewer/id354874588?mt=8", @"url", nil],
                nil];
                
                
    acknowledgements = [[NSArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:@"The RubyKaigi 2010 Team", @"title",
                                                           @"icon, opening image", @"subtitle",
                                                           @"http://rubykaigi.org/2010/", @"url", nil],
                        nil];
                        
    frameworks = [[NSArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:@"JSON Framework", @"title",
                                                           @"Stig Brautaset", @"subtitle",
                                                           @"http://github.com/stig/json-framework", @"url", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"Cider", @"title",
                                                           @"ITO SOFT DESIGN Inc. ", @"subtitle",
                                                           @"http://github.com/katsuyoshi/cider", @"url", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:@"iUnitTest", @"title",
                                                           @"ITO SOFT DESIGN Inc. ", @"subtitle",
                                                           @"http://github.com/katsuyoshi/iunittest", @"url", nil],
                        nil];
                        
    property = [[Property sharedProperty] retain];
    [property addObserver:self forKeyPath:@"updatedAt" options:NSKeyValueObservingOptionNew context:property];
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

- (NSArray *)dataSourceForSection:(int)section
{
    NSArray *dataSource = nil;

    switch (section) {
    case LINK_SECTION:
        dataSource = links;
        break;
    case ACKNOWLEDGEMENT_SECTION:
        dataSource = acknowledgements;
        break;
    case FRAMEWORK_SECTION:
        dataSource = frameworks;
        break;
    }
    return dataSource;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return COUNT_OF_SECTIONS;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
    case REGION_SECTION:
        return 1;
    case INFORMATION_SECTION:
        return 1;
    case LINK_SECTION:
        return [links count];
    case ACKNOWLEDGEMENT_SECTION:
        return [acknowledgements count];
    case FRAMEWORK_SECTION:
        return [frameworks count];
    }
    return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
    case REGION_SECTION:
        return NSLocalizedString(@"Language", nil);
    case INFORMATION_SECTION:
        return NSLocalizedString(@"Information", nil);
    case LINK_SECTION:
        return NSLocalizedString(@"Links", nil);
    case ACKNOWLEDGEMENT_SECTION:
        return NSLocalizedString(@"Acknowledgement", nil);
    case FRAMEWORK_SECTION:
        return NSLocalizedString(@"Copyright", nil);
    }
    return nil;
}


- (UITableViewCell *)regionCellInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Region";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UISwitch *aSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
        cell.textLabel.text = NSLocalizedString(@"English", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = aSwitch;
        aSwitch.on = ![Property sharedProperty].japanese;
        [aSwitch addTarget:self action:@selector(didChangeRegion:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
}

- (UITableViewCell *)informationCellInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Information";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = NSLocalizedString(@"Last updated at", nil);
    NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:[Property sharedProperty].updatedAt];
    return cell;
}

- (UITableViewCell *)linkCellInTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Link";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    NSDictionary *dict = [[self dataSourceForSection:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = NSLocalizedString([dict valueForKey:@"title"], nil);
    cell.detailTextLabel.text = NSLocalizedString([dict valueForKey:@"subtitle"], nil);
    return cell;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
    case REGION_SECTION:
        return [self regionCellInTableView:tableView indexPath:indexPath];
    case INFORMATION_SECTION:
        return [self informationCellInTableView:tableView indexPath:indexPath];
    case LINK_SECTION:
    case ACKNOWLEDGEMENT_SECTION:
    case FRAMEWORK_SECTION:
        return [self linkCellInTableView:tableView indexPath:indexPath];
    }
    return nil;
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

    NSArray *dataSource = [self dataSourceForSection:indexPath.section];
    if (dataSource) {
        self.clickedURL = [NSURL URLWithString:[[dataSource objectAtIndex:indexPath.row] valueForKey:@"url"]];
        if ([Property sharedProperty].isIOS4) {
            [self openClickedURL];
        } else {
            NSString *title = NSLocalizedString(@"", nil);
            NSString *message = NSLocalizedString(@"This action will close iRubyKaigi2010 and open Safari. Are you sure to go on?", nil);
            NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
            NSString *otherButtonTitles = NSLocalizedString(@"OK", nil);
            UIAlertView *alartView = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil] autorelease];
            [alartView show];
        }
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    [property removeObserver:self forKeyPath:@"updatedAt"];

    [property release];
    [clickedURL release];
    [links release];
    [acknowledgements release];
    [frameworks release];
    [super dealloc];
}


- (NSString *)title
{
    return NSLocalizedString(@"Settings", nil);
}

- (void)didChangeRegion:(id)sender
{
    UISwitch *aSwitch = (UISwitch *)sender;
    [Property sharedProperty].japanese = !aSwitch.on;
}



- (void)openClickedURL
{
    if (self.clickedURL) {
        UIApplication *application = [UIApplication sharedApplication];
        if ([application canOpenURL:self.clickedURL]) {
            [application openURL:self.clickedURL];
        }
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        [self openClickedURL];
    }
}

#pragma mark -
#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.tableView reloadData];
}

@end

