// 
//  Room.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/06/01.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

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

/*
+ blackColor
+ darkGrayColor
+ clearColor
+ grayColor
*/

- (NSString *)roomDescription
{
    return self.name;
}


- (NSArray *)sortedSession
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"day.date, time"];
    return [self.sessions sortedArrayUsingDescriptors:sortDescriptors];
}

- (Room *)roomForRegion:(Region *)region
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region = %@ and code = %@", region, self.code];
    return [Room findWithPredicate:predicate sortDescriptors:nil managedObjectContext:self.managedObjectContext error:NULL];
}



@end
