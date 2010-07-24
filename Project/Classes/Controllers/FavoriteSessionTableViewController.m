//
//  FavoriteSessionTableViewController.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "FavoriteSessionTableViewController.h"
#import "Property.h"
#import "Region.h"
#import "Session.h"


@implementation FavoriteSessionTableViewController

- (NSString *)title
{
    return NSLocalizedString(@"Favorite", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    Property *property = [Property sharedProperty];
    Region *region = property.japanese ? [Region japanese] : [Region english];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day.region = %@ and code in %@", region, property.favoriteSessons];
    NSArray *sessions = [Session findAllWithPredicate:predicate error:NULL];
    
    [self setArrayControllerWithSessions:[NSSet setWithArray:sessions]];
    
    [self.tableView reloadData];
}


@end