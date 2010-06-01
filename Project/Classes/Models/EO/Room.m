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


@end
