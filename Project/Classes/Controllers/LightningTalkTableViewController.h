//
//  LightningTalksTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/25.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRKListTableViewController.h"
#import "Session.h"


@interface LightningTalkTableViewController : IRKListTableViewController {

}

+ (LightningTalkTableViewController *)lightningTalksTableViewController;

@property (assign, readonly) Session *session;

@end
