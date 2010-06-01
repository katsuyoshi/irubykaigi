// 
//  SessionType.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/31.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "SessionType.h"
#import "CiderCoreData.h"
#import "Region.h"
#import "Session.h"

@implementation SessionType 

@dynamic code;
@dynamic region;
@dynamic sessions;

+ (SessionType *)sessionTypeWithCode:(SessionTypeCode)code region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.predicate = [NSPredicate predicateWithFormat:@"region = %@ and code = %d", region, code];
    condition.managedObjectContext = context;
    SessionType *type = [SessionType find:condition error:NULL];
    if (type == nil) {
        type = [SessionType createWithManagedObjectContext:context];
        type.code = [NSNumber numberWithInt:code];
        type.region = region;
    }
    return type;
}

+ (SessionType *)sessionTypeWithCode:(SessionTypeCode)code region:(Region *)region
{
    return [self sessionTypeWithCode:code region:region inManagedObjectContext:DEFAULT_MANAGED_OBJECT_CONTEXT];
}

@end
