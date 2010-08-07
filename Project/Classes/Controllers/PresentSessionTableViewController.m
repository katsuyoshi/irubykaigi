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

@synthesize date;

+ (PresentSessionTableViewController *)presentSessionTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

- (void)dealloc
{
    [date release];
    [super dealloc];
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

- (void)setDateNow
{
#ifdef DEBUG
    self.date = [NSDate dateWithYear:2010 month:8 day:27 hour:13 minute:30 second:00];
#else
    self.date = [NSDate date];
#endif
}

- (void)setDateNext
{
#ifdef DEBUG
    [self setNextDateOf:[NSDate dateWithYear:2010 month:8 day:27 hour:14 minute:00 second:00]];
#else
    [self setNextDateOf:[NSDate date]];
#endif
}

- (void)setNextDateOf:(NSDate *)aDate
{
    aDate = [NSDate dateWithTimeInterval:30 * 60 sinceDate:aDate];
    int m = [aDate minute];
    m = (m / 30) * 30;
    self.date = [NSDate dateWithYear:[aDate year] month:[aDate month] day:[aDate day] hour:[aDate hour] minute:m second:0];
}

- (void)reloadData
{
    [self setArrayControllerWithSessionArray:[self.region sessionsForDate:self.date]];
    [self.tableView reloadData];
}


@end
