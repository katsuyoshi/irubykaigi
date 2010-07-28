//
//  LightningTalksDetailTableViewController.h
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightningTalk.h"
#import "AbstractSessionDetaildTableViewController.h"


@interface LightningTalkDetailedTableViewController : AbstractSessionDetaildTableViewController {

}

+ (LightningTalkDetailedTableViewController *)lightningTalkDetailedTableViewController;

@property (assign, readonly) Session *session;
@property (assign, readonly) LightningTalk *lightningTalk;

@end
