// 
//  Day.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Day.h"

#import "Region.h"
#import "Session.h"

@implementation Day 

@dynamic date;
@dynamic region;
@dynamic sessions;


- (NSString *)title
{
    return [self.region.dateFormatter stringFromDate:self.date];
}

@end
