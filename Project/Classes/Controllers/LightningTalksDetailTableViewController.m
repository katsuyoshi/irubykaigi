//
//  LightningTalksDetailTableViewController.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalksDetailTableViewController.h"
#import "NSManagedObjectExtension.h"


@implementation LightningTalksDetailTableViewController

- (void)setTalk:(LightningTalk *)talk
{
    self.session = talk;
    self.tableView.backgroundColor = [[talk valueForKey:@"session"] sessionColor];
}

- (LightningTalk *)talk
{
    return (LightningTalk *)self.session;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

@end
