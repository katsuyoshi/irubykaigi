//
//  SessionDetailedTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/02.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiderCoreData.h"
#import "Session.h"
#import "AbstractSessionDetaildTableViewController.h"


@interface SessionDetailedTableViewController : AbstractSessionDetaildTableViewController {

}

+ (SessionDetailedTableViewController *)sessionDetailedTableViewController;

@property (assign, readonly) Session *session;

@end
