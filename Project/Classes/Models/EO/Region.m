// 
//  Region.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
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

#import "Region.h"
#import "Day.h"
#import "CiderCoreData.h"
#import "Room.h"
#import "Speaker.h"


@implementation Region 

@dynamic identifier;
@dynamic days, rooms, speakers;


+ (Region *)regionWithIdentifier:(NSString *)identifier inManagedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    condition.managedObjectContext = context;
    
    Region *region = [Region find:condition error:NULL];
    if (region == nil) {
        region = [Region createWithManagedObjectContext:context];
        region.identifier = identifier;
    }
    return region;
}

+ (Region *)japaneseInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self regionWithIdentifier:@"ja_JP" inManagedObjectContext:context];
}

+ (Region *)englishInManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self regionWithIdentifier:@"en_US" inManagedObjectContext:context];
}


+ (Region *)regionWithIdentifier:(NSString *)identifier
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
    return [self regionWithIdentifier:identifier inManagedObjectContext:context];
}

+ (Region *)japanese
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
    return [self japaneseInManagedObjectContext:context];
}

+ (Region *)english
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
    return [self englishInManagedObjectContext:context];
}



- (NSLocale *)locale
{
    return [[[NSLocale alloc] initWithLocaleIdentifier:self.identifier] autorelease];
}

- (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter new] autorelease];
    [formatter setLocale:self.locale];

    NSString *format = self.isJapanese ? @"M月d日" : @"MMMM d";
    [formatter setDateFormat:format];
    
    return formatter;
}

- (BOOL)isJapanese
{
    return [self.identifier isEqualToString:@"ja_JP"];
}


#pragma mark -
#pragma mark day

- (Day *)dayForDate:(NSDate *)date
{
    return [Day dayWithDate:date region:self inManagedObjectContext:self.managedObjectContext];
}


- (NSArray *)sortedDays
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"date"];
    return [[self.days allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark -
#pragma mark room

- (Room *)roomForCode:(NSString *)code
{
    return [Room roomWithCode:code region:self inManagedObjectContext:self.managedObjectContext];
}


#pragma mark -
#pragma mark speaker

- (Speaker *)speakerForCode:(NSString *)code
{
    return [Speaker speakerWithCode:code region:self inManagedObjectContext:self.managedObjectContext];
}



- (NSArray *)sessionsForDate:(NSDate *)date
{
    NSDate *today = [date beginningOfDay];
    NSSet *days = [self.days filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"date = %@", today]];
    Day *day = [days anyObject];
    
    if (day) {
        NSString *targetTime = [NSString stringWithFormat:@"%02d:%02d", [date hour], [date minute]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startAt <= %@ and endAt > %@", targetTime, targetTime];
        NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"room.position, position"];
        return [[[day.sessions filteredSetUsingPredicate:predicate] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    } else {
        return [NSArray array];
    }
}



@end
