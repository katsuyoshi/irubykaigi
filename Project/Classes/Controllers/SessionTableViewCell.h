//
//  SessionTableViewCell.h
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionTableViewCell : UITableViewCell {

    NSManagedObject *session;
// DELETEME:    NSArray *colors;

    BOOL initialized;
}

@property (retain) NSManagedObject *session;

@end
