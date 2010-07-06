//
//  SessionTableViewCell.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewCell.h"
#import "Room.h"


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
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [session release];
    [super dealloc];
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
        
    }
}


@end
