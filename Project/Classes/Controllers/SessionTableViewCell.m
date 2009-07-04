//
//  SessionTableViewCell.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewCell.h"


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
    [colors release];
    [session release];
    [super dealloc];
}


- (void)setUp
{
    initialized = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundView = [[UIView new] autorelease];
    
    self.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    colors = [[NSArray alloc] initWithObjects:
                  [UIColor yellowColor]
                , [UIColor greenColor]
                , [UIColor colorWithRed:0.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0]
/*
                      [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] // はちみつ
                    , [UIColor colorWithRed:204.0 / 255.0 green:255.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] // はちみつ
                    , [UIColor colorWithRed:255.0 / 255.0 green:204.0 / 255.0 blue:102.0 / 255.0 alpha:1.0] // スピンドリフト
                    , [UIColor colorWithRed:102.0 / 255.0 green:255.0 / 255.0 blue:102.0 / 204.0 alpha:1.0] // マスクメロン
*/
                    , nil];
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

        NSString *room = [session valueForKeyPath:@"room.name"];
        NSString *speaker = [session valueForKey:@"speaker"];
        NSMutableArray *subTitles = [NSMutableArray array];
        if (room) {
            [subTitles addObject:room];
            int position = [[session valueForKeyPath:@"room.position"] intValue];
            if (position < [colors count]) {
                self.backgroundView.backgroundColor = [colors objectAtIndex:position];
            }
        } else {
            self.backgroundView.backgroundColor = [UIColor brownColor];
        }
    
        if (speaker) {
            [subTitles addObjectsFromArray:[speaker componentsSeparatedByString:@"、"]];
        }
        self.detailTextLabel.text = [subTitles componentsJoinedByString:@" "];
        
        [self setNeedsLayout];
	
    }
}


@end
