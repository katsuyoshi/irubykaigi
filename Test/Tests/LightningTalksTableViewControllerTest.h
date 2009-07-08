//
//  LightningTalksTableViewControllerTest.h
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewBasedTest.h"
#import "LightningTalksTableViewController.h"
#import "Document.h"


@interface LightningTalksTableViewControllerTest : UITableViewBasedTest {

    LightningTalksTableViewController *controller;
    Document *document;
    
}

@property (retain, readonly) LightningTalksTableViewController *controller;

@end
