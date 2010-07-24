//
//  RoomTableViewCell.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/07.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "RoomColorView.h"


@interface RoomTableViewCell : UITableViewCell {

    Room *room;
    RoomColorView *roomColorView;

}

+ (RoomTableViewCell *)roomTableViewCellWithIdentifier:(NSString *)identifier;

@property (retain) Room *room;


@end
