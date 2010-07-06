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
        room.code = code;
        room.region = region;
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
            [room setListNumber];
            room.code = [room.position stringValue];
            room.region = region;
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


- (NSString *)roomDescription
{
    return [NSString stringWithFormat:@"%@(%@)", self.name, self.floor];
}


- (NSArray *)sortedSession
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"day.date, time"];
    return [self.sessions sortedArrayUsingDescriptors:sortDescriptors];
}


@end
