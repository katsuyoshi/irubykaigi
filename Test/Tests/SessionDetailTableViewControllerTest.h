//
//  SessionDetailTableViewControllerTest.h
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewBasedTest.h"
#import "SessionDetailTableViewController.h"
#import "Document.h"


@interface SessionDetailTableViewControllerTest : UITableViewBasedTest {

    // TODO: replace your view controller
    SessionDetailTableViewController *controller;
    NSArray *sessions;
}

@property (retain, readonly) SessionDetailTableViewController *controller;

@end
