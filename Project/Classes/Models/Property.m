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
    [self setBoolValueForKey:@"japanese" value:value];
}

- (BOOL)japanese
{
    return [self boolValueForKey:@"japanese" defaultValue:YES];
}

@end
