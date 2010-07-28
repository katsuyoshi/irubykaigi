//
//  LightningTalkTableViewCell.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomColorView.h"
#import "lightningTalk.h"


@interface LightningTalkTableViewCell : UITableViewCell {

    RoomColorView *roomColorView;

    LightningTalk *lightningTalk;
}

+ (LightningTalkTableViewCell *)lightningTalkTableViewCellWithIdentifier:(NSString *)identifier;

@property (retain) LightningTalk *lightningTalk;


@end
