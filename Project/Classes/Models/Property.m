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
    return [self boolValueForKey:@"japanese" defaultValue:YES];
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


@end
