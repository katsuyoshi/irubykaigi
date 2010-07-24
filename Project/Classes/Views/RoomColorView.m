//
//  RoomColorView.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/07/06.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "RoomColorView.h"


@implementation RoomColorView

@synthesize color;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.color) {
        [self.color setFill];
    } else {
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(rect);
}

- (void)dealloc {
    [color release];
    [super dealloc];
}

- (void)setColor:(UIColor *)aColor
{
    [color release];
    color = [aColor retain];
    
    [self setNeedsDisplay];
}


@end
