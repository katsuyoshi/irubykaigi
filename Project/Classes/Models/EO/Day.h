//
//  Day.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Region;
@class Session;

@interface Day :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Region * region;
@property (nonatomic, retain) NSSet* sessions;

@property (assign, readonly) NSString *title;
@property (assign, readonly) NSString *dayString;

+ (Day *)dayWithDate:(NSDate *)date region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Day *)dayWithDate:(NSDate *)date region:(Region *)region;

- (Day *)dayForRegion:(Region *)region;


@end


@interface Day (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

