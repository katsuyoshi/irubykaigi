//
//  IRKDetaildTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "IRKDetaildTableViewController.h"
#import "Property.h"


@implementation IRKDetaildTableViewController

#pragma mark -
#pragma mark NSKeyValueObserving

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    Property *property = [Property sharedProperty];
    [property addObserver:self forKeyPath:@"japanese" options:NSKeyValueObservingOptionNew context:property];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // タブ切替で戻らない様に
    pushingToNextViewController = YES;
}

- (void)dealloc
{
    [[Property sharedProperty] removeObserver:self forKeyPath:@"japanese"];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == [Property sharedProperty]) {
        if (keyPath == @"japanese") {
            [self didChangeRegion];
        }
    }
}

- (void)reloadData
{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark properties

- (Region *)region
{
    return [Property sharedProperty].japanese ? [Region japanese] : [Region english];
}

- (void)didChangeRegion
{
    [self reloadData];
}


@end
