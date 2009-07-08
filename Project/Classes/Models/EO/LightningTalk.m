//
//  LightningTalk.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "LightningTalk.h"


@implementation LightningTalk

- (void)setRoom:(NSManagedObject *)aRoom
{
    [self setValue:aRoom forKeyPath:@"session.room"];
}

- (NSManagedObject *)room
{
    return [self valueForKeyPath:@"session.room"];
}

- (NSString *)time
{
    return [self valueForKeyPath:@"session.time"];
}


@end
