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
}


@end
