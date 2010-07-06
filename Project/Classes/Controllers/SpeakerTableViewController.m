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
    [fetchedResultsControllers release];
    [super dealloc];
}

- (NSString *)title
{
    return NSLocalizedString(@"Speaker", nil);
}

#pragma mark -
#pragma mark ISCDListTableViewController

- (void)setUpEntityAndAttributeIfNeeds
{
    self.entityName = @"Speaker";
    self.displayKey = @"name";
    self.sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"name"];

    self.region = [Property sharedProperty].japanese ? [Region japanese] : [Region english];
    
    self.hasEditButtonItem = NO;
}

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

#pragma mark -
#pragma mark get a speaker

- (NSFetchedResultsController *)fetchedResultsControllerForSection:(NSInteger)section
{
    return [fetchedResultsControllers objectAtIndex:section];
}

- (Speaker *)speakerAtIndexPath:(NSIndexPath *)indexPath
{
    NSFetchedResultsController *controller = [self fetchedResultsControllerForSection:indexPath.section];
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    return (Speaker *)[controller objectAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark UITableViewDataSource/UITableViewDelegate

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


- (void)refetch
{
    for (NSFetchedResultsController *controller in fetchedResultsControllers) {
        NSError *error = nil;
        [controller performFetch:&error];
#ifdef DEBUG
        if (error) [error showErrorForUserDomains];
#endif
    }
}





@end
