//
//  SessionByRoomTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/05.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionByRoomTableViewController.h"
#import "SessionTableViewCell.h"
#import "SessionDetailedTableViewController.h"
#import "Property.h"
#import "Day.h"


@implementation SessionByRoomTableViewController

@synthesize room;
@synthesize day;

- (void)dealloc
{
    [room release];
    [day release];
    [super dealloc];
}

- (void)setRoom:(Room *)aRoom
{
    [room release];
    room = [aRoom retain];
    
    self.title = room.roomDescription;
    [self reloadData];
}

- (void)setDay:(Day *)aDay
{
    [day release];
    day = [aDay retain];
    
    [self reloadData];
}

- (void)reloadData
{
    if (self.day && self.room) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day = %@", self.day];
        [self setArrayControllerWithSessionSet:[room.sessions filteredSetUsingPredicate:predicate]];
    }
    [self.tableView reloadData];
}

- (void)didChangeRegion
{
    Day *aDay = [[self.day retain] autorelease];
    Room *aRoom = [[self.room retain] autorelease];
    self.day = nil;
    self.room = nil;
    // 念の為にコードがマッチしない場合が合った時に備えて、クリアーしておく
    [self.tableView reloadData];
            
    self.day = [aDay dayForRegion:self.region];
    self.room = [aRoom roomForRegion:self.region];
}



@end
