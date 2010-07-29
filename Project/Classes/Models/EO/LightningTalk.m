//
//  LightningTalk.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalk.h"
#import "Session.h"
#import "CiderCoreData.h"


@implementation LightningTalk

@dynamic position;
@dynamic summary;
@dynamic title;

@dynamic session;
@dynamic speakers;

+ (NSString *)listScopeName
{
    return @"session";
}

- (NSArray *)displayAttributesForTableViewController:(UITableViewController *)controller editing:(BOOL)editing
{
    NSMutableArray *array = [NSMutableArray arrayWithObject:@"title"];
    if ([self.speakers count]) {
        [array addObject:@"speakers.name"];
    }
    if (self.room) {
        [array addObject:@"room.roomDescription"];
    }
    if ([self.summary length]) {
        [array addObject:@"summary"];
    }

    return array;
}

- (Day *)day
{
    return self.session.day;
}

- (NSString *)time
{
    return self.session.time;
}

- (NSString *)code
{
    return [NSString stringWithFormat:@"%@:%@", self.session.code, self.position];
}

- (NSString *)dayTimeTitle
{
    return self.session.dayTimeTitle;
}

- (Room *)room
{
    return self.session.room;
}


- (LightningTalk *)lightningTalkForRegion:(Region *)region
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"session.day.region = %@ and code = %@", region, self.code];
    NSArray *talks = [LightningTalk findAll:nil error:NULL];
    return [[talks filteredArrayUsingPredicate:predicate] lastObject];
    
}

@end
