//
//  LightningTalksTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/25.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalkTableViewController.h"


@implementation LightningTalkTableViewController

+ (LightningTalkTableViewController *)lightningTalksTableViewController
{
    return [[[self alloc] initWithStyle:UITableViewStylePlain] autorelease];
}

#pragma mark -
#pragma mark ISCDListTableViewController

- (void)setUpEntityAndAttributeIfNeeds
{
    self.entityName = @"LightningTalks";
    self.displayKey = @"title";

//    self.detailedTableViewControllerClassName = @"SessionDetailedTableViewController";
//    self.hasDetailView = YES;
    
}



@end
