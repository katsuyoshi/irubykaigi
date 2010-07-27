//
//  SessionByRoomTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/05.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "SessionBySomethingTableViewController.h"


@interface SessionByRoomTableViewController : SessionBySomethingTableViewController {

    Room *room;
    Day *day;

}

@property (retain) Room *room;
@property (retain) Day *day;


@end
