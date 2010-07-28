//
//  SessionBySpeakerTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionBySpeakerTableViewController.h"
#import "Session.h"
#import "SessionDetailedTableViewController.h"


@implementation SessionBySpeakerTableViewController

@synthesize speaker;

- (void)dealloc
{
    [speaker release];
    [super dealloc];
}

- (void)setSpeaker:(Speaker *)aSpeaker
{
    [speaker release];
    speaker = [aSpeaker retain];
    
    self.title = speaker.name;
    [self reloadData];
}

- (void)reloadData
{
    NSMutableSet *sessions = [speaker.sessions mutableCopy];
    [sessions addObjectsFromArray:[speaker.lightningTalks allObjects]];
    
    [self setArrayControllerWithSessionSet:sessions];
}

@end
