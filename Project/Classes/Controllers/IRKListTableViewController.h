//
//  IRKListTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiderCoreData.h"
#import "Region.h"


@interface IRKListTableViewController : ISCDListTableViewController {

}

@property (assign, readonly) Region *region;

- (void)didChangeRegion;

@end
