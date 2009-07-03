//
//  NSManagedObjectContextExtension.h
//  ioCoreTest
//
//  Created by Katsuyoshi Ito on 09/06/27.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PredicateCondition.h"


@interface NSManagedObjectContext(find)

#pragma mark -
#pragma mark find

- (NSManagedObject *)find:(PredicateCondition *)condition;
- (NSArray *)findAll:(PredicateCondition *)condition;

@end
