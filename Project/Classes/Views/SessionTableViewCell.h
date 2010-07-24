//
//  SessionTableViewCell.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "RoomColorView.h";


@interface SessionTableViewCell : UITableViewCell {

    Session *session;

    RoomColorView *roomColorView;
    UIButton *favoritButton;
    
}

+ (SessionTableViewCell *)sessionTableViewCellWithIdentifier:(NSString *)identifier;

+ (UIImage *)favolitImage;
+ (UIImage *)notFavolitImage;
+ (UIImage *)blankImage;

- (UIImage *)favolitImage;
- (UIImage *)notFavolitImage;
- (UIImage *)blankImage;

@property (retain) Session *session;

@end

