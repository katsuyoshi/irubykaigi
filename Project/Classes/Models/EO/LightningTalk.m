//
//  LightningTalk.m
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//

/* 

  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.

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

#import "LightningTalk.h"
#import "Session.h"
#import "CiderCoreData.h"


@implementation LightningTalk

@dynamic position;
@dynamic summary;
@dynamic title;

@dynamic session;
@dynamic speakers;
@dynamic archives;


+ (NSString *)listScopeName
{
    return @"session";
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
    if ([[self sortedArchives] count]) {
        [array addObject:@"archives.title"];
    }
    return array;
}

- (Day *)day
{
    return self.session.day;
}

- (NSString *)time
{
    return self.session.time;
}

- (NSString *)code
{
    return [NSString stringWithFormat:@"%@:%@", self.session.code, self.position];
}

- (NSString *)dayTimeTitle
{
    return self.session.dayTimeTitle;
}

- (Room *)room
{
    return self.session.room;
}


- (LightningTalk *)lightningTalkForRegion:(Region *)region
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"session.day.region = %@ and code = %@", region, self.code];
    NSArray *talks = [LightningTalk findAll:nil error:NULL];
    return [[talks filteredArrayUsingPredicate:predicate] lastObject];
    
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
