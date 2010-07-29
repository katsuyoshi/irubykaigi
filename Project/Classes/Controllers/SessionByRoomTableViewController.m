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

/* DELETEME:
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == [Property sharedProperty]) {
        if (keyPath == @"japanese") {
            Day *aDay = [[self.day retain] autorelease];
            Room *aRoom = [[self.room retain] autorelease];
            self.day = nil;
            self.room = nil;
            // 念の為にコードがマッチしない場合が合った時に備えて、クリアーしておく
            [self.tableView reloadData];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@", aDay.date];
            NSSet *set = [self.region.days filteredSetUsingPredicate:predicate];
            self.day = [set anyObject];
            
            predicate = [NSPredicate predicateWithFormat:@"code = %@", aRoom.code];
            set = [self.region.rooms filteredSetUsingPredicate:predicate];
            self.room = [set anyObject];
            
        }
    }
}
*/

- (void)didChangeRegion
{
    Day *aDay = [[self.day retain] autorelease];
    Room *aRoom = [[self.room retain] autorelease];
    self.day = nil;
    self.room = nil;
    // 念の為にコードがマッチしない場合が合った時に備えて、クリアーしておく
    [self.tableView reloadData];
            
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@", aDay.date];
    NSSet *set = [self.region.days filteredSetUsingPredicate:predicate];
    self.day = [set anyObject];
            
    predicate = [NSPredicate predicateWithFormat:@"code = %@", aRoom.code];
    set = [self.region.rooms filteredSetUsingPredicate:predicate];
    self.room = [set anyObject];
}



@end
