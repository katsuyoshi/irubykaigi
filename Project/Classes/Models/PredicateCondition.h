//
//  PredicateCondition.h
//  MakePlc
//
//  Created by Katsuyoshi Ito on 09/05/23.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PredicateCondition : NSObject {
    NSString *entity;
    NSString *format;
    NSArray *arguments;
    NSArray *orderings;
}

+ (id)conditionWithEntity:(NSString *)entity format:(NSString *)format argumentArray:(NSArray *)arguments;
- (id)initWithEntity:(NSString *)entity format:(NSString *)format argumentArray:(NSArray *)arguments;

@property (retain, readonly) NSString *entity;

@property (retain) NSArray *orderings;

@property (assign, readonly) NSPredicate *predicate;

@end
