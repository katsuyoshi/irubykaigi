//
//  Region.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Day;

@interface Region :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet* days;

@property (assign, readonly) NSLocale *locale;
@property (assign, readonly) NSDateFormatter *dateFormatter;


@end


@interface Region (CoreDataGeneratedAccessors)
- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSSet *)value;
- (void)removeDays:(NSSet *)value;

@end

