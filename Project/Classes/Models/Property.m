//
//  Property.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/29.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Property.h"


@implementation Property

+ (Property *)sharedProperty
{
    return (Property *)[super sharedProperty];
}

- (void)setJapanese:(BOOL)value
{
    [self setBoolValue:value forKey:@"japanese"];
}

- (BOOL)japanese
{
    BOOL isJapanese = [[[NSLocale currentLocale] localeIdentifier] isEqualToString:@"ja_JP"];
    return [self boolValueForKey:@"japanese" defaultValue:isJapanese];
}

- (void)setSessionSearchHistories:(NSArray *)array
{
    [self setArray:array forKey:@"sessionSearchHistories"];
}


- (NSArray *)sessionSearchHistories
{
    return [self arrayForKey:@"sessionSearchHistories"];
}


- (void)setFavoriteSessons:(NSArray *)array
{
    [self setArray:array forKey:@"favoriteSessons"];
}


- (NSArray *)favoriteSessons
{
    return [self arrayForKey:@"favoriteSessons"];
}



- (void)setFavoriteLightningTalks:(NSArray *)array
{
    [self setArray:array forKey:@"favoriteLightningTalks"];
}


- (NSArray *)favoriteLightningTalks
{
    return [self arrayForKey:@"favoriteLightningTalks"];
}


- (void)setUpdatedAt:(NSDate *)date
{
    [self setDate:date forKey:@"lastUpdated"];
}

- (NSDate *)updatedAt
{
    return [self dateForKey:@"lastUpdated"];
}


- (BOOL)iOS4
{
    if (iOS4 == nil) {
        NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
        iOS4 = [NSNumber numberWithBool:[components respondsToSelector:@selector(timeZone)]];
    }
    return [iOS4 boolValue];
}

@end
