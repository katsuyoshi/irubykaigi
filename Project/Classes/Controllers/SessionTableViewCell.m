//
//  SessionTableViewCell.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewCell.h"
#import "NSManagedObjectExtension.h"


@implementation SessionTableViewCell

@synthesize session;


/* CHECKME: 何でここ通らないんだ！
- (id)initWithStyle:(UITableViewCellStyle)stylereuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:stylereuseIdentifier reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
*/


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [session release];
    [super dealloc];
}


- (void)setUp
{
    initialized = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView = [[UIView new] autorelease];
    
    self.detailTextLabel.textColor = [UIColor darkGrayColor];

}

- (void)setSession:(NSManagedObject *)aSession
{
    if (initialized == NO) {
        [self setUp];
    }

    if (session != aSession) {
        [session release];
        session = [aSession retain];
     
        self.textLabel.text = [session valueForKey:@"title"];

        if ([[session valueForKey:@"break"] boolValue]) {
            self.backgroundView.backgroundColor = [UIColor brownColor];
            self.textLabel.textColor = [UIColor whiteColor];
        } else {
            self.backgroundView.backgroundColor = [session sessionColor];
            self.textLabel.textColor = [UIColor blackColor];
        }
    
        NSString *room = [session valueForKeyPath:@"room.name"];
        NSString *speaker = [session valueForKey:@"speaker"];
        NSMutableArray *subTitles = [NSMutableArray array];
        if (room) {
            [subTitles addObject:room];
        }
        if (speaker) {
            [subTitles addObjectsFromArray:[speaker componentsSeparatedByString:@"、"]];
        }
        self.detailTextLabel.text = [subTitles componentsJoinedByString:@" "];	
    }
}


@end
