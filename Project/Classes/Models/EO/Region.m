// 
//  Region.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "Region.h"

#import "Day.h"

@implementation Region 

@dynamic identifier;
@dynamic days;


- (NSLocale *)locale
{
    return [[[NSLocale alloc] initWithLocaleIdentifier:self.identifier] autorelease];
}

- (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
    [formatter setLocale:self.locale];

    NSString *format = [self.identifier isEqualToString:@"ja-jp"] ? @"M月d日" : @"MMMM d";
    [formatter setDateFormat:format];
    
    return formatter;
}

@end
