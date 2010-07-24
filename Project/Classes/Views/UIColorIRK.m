//
//  UIColorIRK.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/24.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "UIColorIRK.h"


@implementation UIColor(SessionTableViewCell)

+ (UIColor *)breakSessionColor
{
    return [UIColor colorWithRed:185.0/255.0 green:124.0/255.0 blue:63.0/255.0 alpha:0.5];
}

+ (UIColor *)normalSessionColor
{
    return [UIColor colorWithWhite:0.95 alpha:1.0];
}

+ (UIColor *)attentionSessionColor
{
    return [UIColor colorWithRed:239./255.0 green:241.0/255.0 blue:2.0/255.0 alpha:1.0];
}


@end
