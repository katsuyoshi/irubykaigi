//
//  Belonging.h
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/08/13.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Speaker;

@interface Belonging :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Speaker * speaker;

@end



