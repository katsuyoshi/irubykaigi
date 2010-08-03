//
//  SessionTableViewCell.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewCell.h"
#import "Room.h"
#import "Property.h"
#import "RoomColorView.h"
#import "UIColorIRK.h"


@implementation SessionTableViewCell

@synthesize session;


+ (SessionTableViewCell *)sessionTableViewCellWithIdentifier:(NSString *)identifier
{
    return [[[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Initialization code
       
        roomColorView = [[RoomColorView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:roomColorView];
        
        favoritButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [favoritButton addTarget:self action:@selector(didTouchUpFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:favoritButton];
        
        self.backgroundView = [[UIView new] autorelease];
        self.backgroundView.backgroundColor = [UIColor lightGrayColor];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    favoritButton.frame = self.imageView.frame;
    
    CGRect frame = self.contentView.frame;
    frame.size.width = self.imageView.frame.origin.x;
    frame = CGRectInset(frame, 1, 1);
    roomColorView.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [session release];
    [super dealloc];
}


+ (UIImage *)favolitImage
{
    return [UIImage imageNamed:@"favorite_on_30x30.png"];
}

+ (UIImage *)notFavolitImage
{
    return [UIImage imageNamed:@"favorite_off_30x30.png"];
}

+ (UIImage *)blankImage
{
    return [UIImage imageNamed:@"blank_30x30.png"];
}


- (UIImage *)favolitImage
{
    return [[self class] favolitImage];
}

- (UIImage *)notFavolitImage
{
    return [[self class] notFavolitImage];
}

- (UIImage *)blankImage
{
    return [[self class] blankImage];
}



- (void)setSession:(Session *)aSession
{
    if (session != aSession) {
        [session release];
        session = [aSession retain];
     
        self.textLabel.text = [session valueForKey:@"title"];

        NSMutableArray *subTitles = [NSMutableArray array];
        NSString *room = session.room.name;
        if (room) {
            [subTitles addObject:room];
        }
        [subTitles addObjectsFromArray:[session.speakers valueForKey:@"name"]];
        self.detailTextLabel.text = [subTitles componentsJoinedByString:@" "];
        
        NSArray *array = [Property sharedProperty].favoriteSessons;
        
        if (session.isSession) {
            self.imageView.image = [array containsObject:session.code] ? [self favolitImage] : [self notFavolitImage];
            favoritButton.userInteractionEnabled = YES;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else {
            self.imageView.image = nil;
            favoritButton.userInteractionEnabled = NO;
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        roomColorView.color = self.session.room.roomColor;
        roomColorView.hidden = session.isBreak;
        
        UIColor *textColor = session.isBreak ? [UIColor whiteColor] : [UIColor blackColor];
        UIColor *bgColor = session.isBreak ? [UIColor breakSessionColor] : [UIColor normalSessionColor];
        
        self.backgroundView.backgroundColor = bgColor;
        self.textLabel.textColor = textColor;
        self.detailTextLabel.textColor = textColor;
//        self.textLabel.backgroundColor = bgColor;
//        self.detailTextLabel.backgroundColor = bgColor;

    }
}


- (void)didTouchUpFavorite:(id)sender
{
    if ([session.code length]) {
        Property *property = [Property sharedProperty];
        NSMutableArray *array = [[property.favoriteSessons mutableCopy] autorelease];
        if ([array containsObject:session.code]) {
            [array removeObject:session.code];
            self.imageView.image = [self notFavolitImage];
        } else {
            [array addObject:session.code];
            self.imageView.image = [self favolitImage];
        }
        [property setFavoriteSessons:array];
    }
}

@end



