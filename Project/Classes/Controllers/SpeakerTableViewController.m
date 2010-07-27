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

@synthesize region;
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
    [region release];
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
#pragma mark ISCDListTableViewController


- (Region *)region
{
    return [Property sharedProperty].japanese ? [Region japanese] : [Region english];
}

/*
- (void)setRegion:(Region *)aRegion
{
    [region release];
    
    region = [aRegion retain];
    self.indexTitles = [[@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z #" componentsSeparatedByString:@" "] retain];

    fetchedResultsControllers = [NSMutableArray new];
    for (NSString *indexTitle in self.indexTitles) {

        NSPredicate *regionPredicate = [NSPredicate predicateWithFormat:@"region = %@", region];
        if ([indexTitle isEqualToString:@"#"] == NO) {
            NSPredicate *indexTitlePredicate = [NSPredicate predicateWithFormat:@"name beginswith[c] %@", indexTitle];
            self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:regionPredicate, indexTitlePredicate, nil]];
        } else {
            NSMutableArray *predicates = [NSMutableArray array];
            NSString *lastIndexTitle = [self.indexTitles lastObject];
            for (NSString *indexTitle2 in self.indexTitles) {
                if (indexTitle2 != lastIndexTitle) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name beginswith[c] %@", indexTitle2];
                    [predicates addObject:[NSCompoundPredicate notPredicateWithSubpredicate:predicate]];
                }
            }
            [predicates addObject:regionPredicate]; 
            self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        }

        [self resetFetchedResultController];
        [fetchedResultsControllers addObject:self.fetchedResultsController];
    }
}
*/

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
