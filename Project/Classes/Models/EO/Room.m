// 
//  Room.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/06/01.
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

#import "Room.h"
#import "CiderCoreData.h"
#import "Region.h"
#import "Session.h"
#import "UIColorIRK.h"


@implementation Room 

@dynamic name;
@dynamic code;
@dynamic floor;
@dynamic position;
@dynamic region;
@dynamic sessions;


+ (Room *)roomWithCode:(NSString *)code region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.predicate = [NSPredicate predicateWithFormat:@"region = %@ and code = %@", region, code];
    condition.managedObjectContext = context;
    Room *room = [Room find:condition error:NULL];
    if (room == nil) {
        room = [Room createWithManagedObjectContext:context];
        room.region = region;
        room.code = code;
        [room setListNumber];
    }
    return room;
}


+ (Room *)roomWithCode:(NSString *)code region:(Region *)region
{
    return [self roomWithCode:code region:region inManagedObjectContext:DEFAULT_MANAGED_OBJECT_CONTEXT];
}

+ (Room *)roomByName:(NSString *)name floor:(NSString *)floor region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context
{
    if ([name length] && [floor length]) {
        ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
        condition.predicate = [NSPredicate predicateWithFormat:@"region = %@ and name = %@ and floor = %@", region, name, floor];
        condition.managedObjectContext = context;
        Room *room = [Room find:condition error:NULL];
        if (room == nil) {
            room = [Room createWithManagedObjectContext:context];
            room.region = region;
            [room setListNumber];
            room.code = [room.position stringValue];
            room.name = name;
            room.floor = floor;
        }
        return room;
    } else {
        return nil;
    }
}

+ (Room *)roomByName:(NSString *)name floor:(NSString *)floor region:(Region *)region
{
    NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
    return [self roomByName:name floor:floor region:region inManagedObjectContext:context];
}

+ (NSString *)listScopeName
{
    return @"region";
}


- (UIColor *)roomColor
{
    switch ([self.position intValue]) {
    case 1:
        return UICOLOR_MAKE(204, 255, 102, 1.0);    // green
    case 2:
        return UICOLOR_MAKE(178, 204, 255, 1.0);    // blue
    case 3:
        return UICOLOR_MAKE(255, 255, 150, 1.0);    // yellow
    case 4:
        return UICOLOR_MAKE(150, 150, 255, 1.0);    // cyan
    case 5:
        return UICOLOR_MAKE(255, 202, 174, 1.0);    // orange
    case 6:
        return UICOLOR_MAKE(255, 150, 255, 1.0);    // magenta
    case 7:
        return UICOLOR_MAKE(195, 150, 206, 1.0);    // purple
    case 8:
        return UICOLOR_MAKE(255, 102, 102, 1.0);    // red
    case 9:
        return UICOLOR_MAKE(208, 187, 142, 1.0);    // brown
    case 10:
    default:
        return UICOLOR_MAKE(227, 227, 227, 1.0);    // gray
    }
}

- (NSString *)roomDescription
{
    return self.name;
}


- (NSArray *)sortedSession
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"day.date, time"];
    return [[self.sessions allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (Room *)roomForRegion:(Region *)region
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region = %@ and code = %@", region, self.code];
    return [Room findWithPredicate:predicate sortDescriptors:nil managedObjectContext:self.managedObjectContext error:NULL];
}



@end
