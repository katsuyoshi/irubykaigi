// 
//  Session.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//

/* 

  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:
  
      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
 
      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.
 
      * Neither the name of ITO SOFT DESIGN Inc. nor the names of its
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#import "Session.h"
#import "Day.h"
#import "LightningTalk.h"
#import "CiderCoreData.h"
#import "CiderCoreData.h"


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
@dynamic talks;
@dynamic speakerRawData;
@dynamic sessionType;
@dynamic archives;


- (void)awakeFromInsert
{
    self.sessionType = [NSNumber numberWithInt:SessionTypeCodeNormal];
}

+ (NSString *)listScopeName
{
    return @"day";
}

- (NSArray *)displayAttributesForTableViewController:(UITableViewController *)controller editing:(BOOL)editing
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"dayTimeTitle", @"title", nil];
    if ([self.speakers count]) {
        [array addObject:@"speakers.name"];
    }
    if (self.room) {
        [array addObject:@"room.roomDescription"];
    }
    if ([self.summary length]) {
        [array addObject:@"summary"];
    }
    if ([self.archives count]) {
        [array addObject:@"archives.title"];
    }
    return array;
}

- (NSString *)dayTimeTitle
{
    return [NSString stringWithFormat:@"%@ %@", self.day.title, self.time];
}

- (BOOL)isSession
{
    return ([self.sessionType intValue] / 100) == 0;
}

- (BOOL)isBreak
{
    return ([self.sessionType intValue] / 100) == 1;
}

- (BOOL)isAnnouncement
{
    return ([self.sessionType intValue] / 100) == 2;
}

- (BOOL)isLightningTalks
{
    return [self.sessionType intValue] == SessionTypeCodeLightningTalks;
}


- (NSString *)startAt
{
    if ([self.time length]) {
        NSArray *array = [self.time componentsSeparatedByString:@" - "];
        if ([array count]) {
            return [array objectAtIndex:0];
        }
    }
    return nil;
}

- (NSString *)endAt
{
    if ([self.time length]) {
        NSArray *array = [self.time componentsSeparatedByString:@" - "];
        if ([array count] >= 2) {
            return [array objectAtIndex:1];
        }
    }
    return nil;
}

- (Session *)sessionForRegion:(Region *)region
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day.region = %@ and code = %@", region, self.code];
    return [Session findWithPredicate:predicate sortDescriptors:nil managedObjectContext:self.managedObjectContext error:NULL];
}

- (NSArray *)sortedSpeakers
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"position"];
    return [[self.speakers allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray *)sortedArchives
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"position"];
    return [[self.archives allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}


@end
