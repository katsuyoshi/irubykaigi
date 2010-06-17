// 
//  Session.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Session.h"

#import "LightningTalk.h"

@implementation Session 

@dynamic time;
@dynamic title;
@dynamic intermission;
@dynamic profile;
@dynamic attention;
@dynamic summary;
@dynamic position;
@dynamic code;
@dynamic speakers;
@dynamic day;
@dynamic room;
@dynamic lightningTalks;
@dynamic speakerRawData;

+ (NSString *)listScopeName
{
    return @"day";
}

@end
