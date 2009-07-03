//
//  PredicateCondition.m
//  MakePlc
//
//  Created by Katsuyoshi Ito on 09/05/23.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import "PredicateCondition.h"


@implementation PredicateCondition

@synthesize entity, orderings;

+ (id)conditionWithEntity:(NSString *)entity format:(NSString *)format argumentArray:(NSArray *)arguments
{
    return [[[self alloc] initWithEntity:entity format:format argumentArray:arguments] autorelease];
}

- (id)initWithEntity:(NSString *)anEntity format:(NSString *)aFormat argumentArray:(NSArray *)anArguments
{
    self = [super init];
    if (self) {
        entity = [anEntity retain];
        format = [aFormat retain];
        arguments = [anArguments retain];
    }
    return self;
}

- (void)dealloc
{
    [entity release];
    [format release];
    [arguments release];
    [orderings release];
    [super dealloc];
}


- (NSPredicate *)predicate
{
    if (format) {
        return [NSPredicate predicateWithFormat:format argumentArray:arguments];
    } else {
        return nil;
    }
}



@end
