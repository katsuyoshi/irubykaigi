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

- (void)dealloc
{
    [room release];
    [super dealloc];
}

- (void)setRoom:(Room *)aRoom
{
    [room release];
    room = [aRoom retain];
    
    [super setArrayControllerWithSessions:room.sessions];
}



@end
