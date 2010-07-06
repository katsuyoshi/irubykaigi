//
//  SessionTableViewCell.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"


@interface SessionTableViewCell : UITableViewCell {

    Session *session;

}

+ (SessionTableViewCell *)sessionTableViewCellWithIdentifier:(NSString *)identifier;

@property (retain) Session *session;

@end
