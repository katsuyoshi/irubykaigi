//
//  NSManagedObjectContextExtension.m
//  ioCoreTest
//
//  Created by Katsuyoshi Ito on 09/06/27.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "NSManagedObjectContextExtension.h"


@implementation NSManagedObjectContext(find)

- (NSManagedObject *)find:(PredicateCondition *)condition
{
    NSArray *array = [self findAll:condition];
    switch ([array count]) {
    case 0:
        return nil;
    case 1:
        return [array lastObject];
    default:
// FIXME:        @throw [NSException exceptionWithName:@"Duplicated" reason:nil userInfo:nil];
        return [array lastObject];
    }
}

- (NSArray *)findAll:(PredicateCondition *)condition
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:condition.entity inManagedObjectContext:self];
    [request setEntity:entityDescription];
    [request setPredicate:condition.predicate];
    [request setSortDescriptors:condition.orderings];

    return [self executeFetchRequest:request error:nil];
}

@end
