//
//  SessionBySpeakerTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionBySomethingTableViewController.h"
#import "Speaker.h"


@interface SessionBySpeakerTableViewController : SessionBySomethingTableViewController {

    Speaker *speaker;
    
}

@property (retain) Speaker *speaker;

@end
