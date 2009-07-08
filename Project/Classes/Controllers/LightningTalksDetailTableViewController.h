//
//  LightningTalksDetailTableViewController.h
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionDetailTableViewController.h"
#import "LightningTalk.h"


@interface LightningTalksDetailTableViewController : SessionDetailTableViewController {

}

@property (assign) LightningTalk *talk;

@end
