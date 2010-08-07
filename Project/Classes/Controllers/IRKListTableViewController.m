//
//  IRKListTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "IRKListTableViewController.h"
#import "Property.h"
#import "Importer.h"


@implementation IRKListTableViewController

#pragma mark -
#pragma mark NSKeyValueObserving

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    Property *property = [Property sharedProperty];
    [property addObserver:self forKeyPath:@"japanese" options:NSKeyValueObservingOptionNew context:property];
    Importer *importer = [Importer defaultImporter];
    [importer addObserver:self forKeyPath:@"isUpdated" options:NSKeyValueObservingOptionNew context:importer];
}

- (void)dealloc
{
    [[Importer defaultImporter] removeObserver:self forKeyPath:@"isUpdated"];

    [[Property sharedProperty] removeObserver:self forKeyPath:@"japanese"];
    [super dealloc];
}


#pragma mark -
#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == [Property sharedProperty]) {
        if (keyPath == @"japanese") {
            [self didChangeRegion];
        }
    }
    if (context == [Importer defaultImporter]) {
        [self reloadData];
    }
}

#pragma mark -
#pragma mark reloadData

- (void)reloadData
{
    [self resetFetchedResultController];
    [super reloadData];
}


#pragma mark -
#pragma mark properties

- (Region *)region
{
    return [Property sharedProperty].japanese ? [Region japanese] : [Region english];
}

- (void)didChangeRegion
{
    @try {
        [self reloadData];
    }
    @catch (NSException * e) {
        NSLog(@"%@", e);
    }
}



@end
