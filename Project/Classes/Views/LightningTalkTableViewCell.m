//
//  LightningTalkTableViewCell.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalkTableViewCell.h"
#import "Session.h"
#import "Room.h"
#import "UIColorIRK.h"


@implementation LightningTalkTableViewCell

@synthesize lightningTalk;


+ (LightningTalkTableViewCell *)lightningTalkTableViewCellWithIdentifier:(NSString *)identifier
{
    return [[[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Initialization code
       
        roomColorView = [[RoomColorView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:roomColorView];
        
        self.backgroundView = [[UIView new] autorelease];
        self.backgroundView.backgroundColor = [UIColor normalSessionColor];
                
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.contentView.frame;
    frame.size.width = 10;
    frame = CGRectInset(frame, 1, 1);
    roomColorView.frame = frame;
    
    frame = self.textLabel.frame;
    frame.origin.x = 30;
    frame.size.width = self.contentView.frame.size.width - 30;
    self.textLabel.frame = frame;

    frame = self.detailTextLabel.frame;
    frame.origin.x = 30;
    frame.size.width = self.contentView.frame.size.width - 30;
    self.detailTextLabel.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLightningTalk:(LightningTalk *)talk
{
    if (lightningTalk != talk) {
        [lightningTalk release];
        lightningTalk = [talk retain];
     
        self.textLabel.text = [lightningTalk valueForKey:@"title"];
        self.detailTextLabel.text = [[[lightningTalk.speakers allObjects] valueForKey:@"name"] componentsJoinedByString:@","];

        roomColorView.color = self.lightningTalk.session.room.roomColor;
    }
}



- (void)dealloc {
    [lightningTalk release];
    [super dealloc];
}


@end
