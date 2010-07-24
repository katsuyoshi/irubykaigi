//
//  RoomTableViewCell.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/07.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "RoomTableViewCell.h"


@implementation RoomTableViewCell

@synthesize room;


+ (RoomTableViewCell *)roomTableViewCellWithIdentifier:(NSString *)identifier
{
    return [[[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        roomColorView = [[RoomColorView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:roomColorView];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [room release];
    [roomColorView release];
    [super dealloc];
}


- (void)setRoom:(Room *)aRoom
{
    [room release];
    room = [aRoom retain];
    
    self.textLabel.text = room.name;
    roomColorView.color = room.roomColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.contentView.frame;
    frame.size.width = self.textLabel.frame.origin.x;
    frame = CGRectInset(frame, 1, 1);
    roomColorView.frame = frame;
}

@end
