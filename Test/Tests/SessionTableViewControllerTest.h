//
//  SessionTableViewControllerTest.h
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/03.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewBasedTest.h"
#import "SessionTableViewController.h"
#import "Document.h"


@interface SessionTableViewControllerTest : UITableViewBasedTest {

    // TODO: replace your view controller
    SessionTableViewController *controller;
    Document *document;
    
}

@property (retain, readonly) SessionTableViewController *controller;

@end
