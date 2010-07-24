//
//  SessionBySomethingTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiderCoreData.h"


@interface SessionBySomethingTableViewController : UITableViewController {

    ISSectionedArrayController *arrayController;

}

+ (UINavigationController *)navigationController;
+ (id)sessionTableViewController;

- (void)setArrayControllerWithSessions:(NSSet *)sessions;

@end
