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
    return UICOLOR_MAKE(208, 187, 142, 1.0);    // brown
}

+ (UIColor *)normalSessionColor
{
    return [UIColor whiteColor];
//    return [UIColor colorWithWhite:0.95 alpha:1.0];
}

+ (UIColor *)attentionSessionColor
{
    return UICOLOR_MAKE(255, 255, 150, 1.0);    // yellow
//    return [UIColor colorWithRed:239./255.0 green:241.0/255.0 blue:2.0/255.0 alpha:1.0];
}



@end
