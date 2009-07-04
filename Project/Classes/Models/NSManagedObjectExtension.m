//
//  NSManagedObjectExtension.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/04.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "NSManagedObjectExtension.h"


@implementation NSManagedObject(Session)

- (UIColor *)sessionColor
{
    static NSArray *colors = nil;
    if (colors == nil) {
        colors = [[NSArray alloc] initWithObjects:
                      [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:190.0 / 255.0 alpha:1.0]
                    , [UIColor colorWithRed:210.0 / 255.0 green:255.0 / 255.0 blue:210.0 / 255.0 alpha:1.0]
                    , [UIColor colorWithRed:240.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0]
                    , nil];
    }

    if ([[[self entity] name] isEqualToString:@"Session"]) {
        int position = [[self valueForKeyPath:@"room.position"] intValue];
        if (position < [colors count]) {
            return [colors objectAtIndex:position];
        } else {
            return [UIColor redColor];
        }
    } else {
        return nil;
    }
}


@end
