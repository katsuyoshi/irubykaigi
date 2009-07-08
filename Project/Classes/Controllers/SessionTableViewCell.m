//
//  SessionTableViewCell.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionTableViewCell.h"
#import "NSManagedObjectExtension.h"
#import "Document.h"


@implementation SessionTableViewCell

@synthesize session;

+ (UIImage *)favoriteOffImage
{
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageNamed:@"favorite_off.png"] retain];
    }
    return image;
}

+ (UIImage *)favoriteOnImage
{
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageNamed:@"favorite_on_blue.png"] retain];
    }
    return image;
}


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
            self.imageView.image = nil;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            self.backgroundView.backgroundColor = [session sessionColor];
            self.textLabel.textColor = [UIColor blackColor];
            
            if ([session valueForKey:@"attention"]) {
                self.imageView.image = nil;
                self.selectionStyle = UITableViewCellSelectionStyleNone;
            } else {
                if ([[Document sharedDocument] isFavoriteSession:self.session]) {
                    self.imageView.image = [[self class] favoriteOnImage];
                } else {
                    self.imageView.image = [[self class] favoriteOffImage];
                }
                self.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
        }
    
        NSMutableArray *subTitles = [NSMutableArray array];
        NSString *attention = [session valueForKeyPath:@"attention"];
        if (attention) {
            self.detailTextLabel.text = attention;
        } else {
            NSString *room = [session valueForKeyPath:@"room.name"];
            if (room) {
                [subTitles addObject:room];
            }
            [subTitles addObjectsFromArray:[[session mutableSetValueForKey:@"speakers"] valueForKey:@"name"]];
            self.detailTextLabel.text = [subTitles componentsJoinedByString:@" "];
        }
        
    }
}


@end
