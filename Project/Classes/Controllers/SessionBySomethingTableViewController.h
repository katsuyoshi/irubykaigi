//
//  SessionBySomethingTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiderCoreData.h"
#import "Region.h"
#import "IRKTableViewController.h"


@interface SessionBySomethingTableViewController : IRKTableViewController {

    ISSectionedArrayController *arrayController;

}


+ (UINavigationController *)navigationController;
+ (id)sessionTableViewController;

- (void)setArrayControllerWithSessionArray:(NSArray *)sessions;
- (void)setArrayControllerWithSessionSet:(NSSet *)sessions;

- (void)setArrayControllerWithSessionSet:(NSSet *)sessions sortDescriptors:(NSArray *)sortDescriptors;


@end
