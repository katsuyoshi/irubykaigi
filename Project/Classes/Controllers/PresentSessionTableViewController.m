//
//  PresentSessionTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "PresentSessionTableViewController.h"
#import "CiderCoreData.h"
#import "Day.h"


@implementation PresentSessionTableViewController

+ (PresentSessionTableViewController *)presentSessionTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

- (NSString *)title
{
    return NSLocalizedString(@"Present sessions", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadData];
}

- (void)reloadData
{
//    NSDate *today = [[NSDate date] beginningOfDay];
    NSDate *today = [NSDate dateWithYear:2010 month:8 day:27 hour:0 minute:0 second:0];
    NSSet *days = [self.region.days filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"date = %@", today]];
    Day *day = [days anyObject];
    
    if (day) {
//        NSDate *now = [NSDate date];
        NSDate *now = [NSDate dateWithYear:2010 month:8 day:27 hour:15 minute:10 second:0];
        NSString *nowTime = [NSString stringWithFormat:@"%02d:%02d", [now hour], [now minute]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startAt <= %@ and endAt > %@", nowTime, nowTime];
        NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"room.position, position"];
        [self setArrayControllerWithSessionSet:[day.sessions filteredSetUsingPredicate:predicate] sortDescriptors:sortDescriptors];
    } else {
        [self setArrayControllerWithSessionSet:[NSSet set]];
    }
    [self.tableView reloadData];
}


@end
