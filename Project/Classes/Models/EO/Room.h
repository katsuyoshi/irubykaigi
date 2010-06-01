//
//  Room.h
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/06/01.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Region;
@class Session;

@interface Room :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * floor;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) Region * region;
@property (nonatomic, retain) NSSet* sessions;

+ (Room *)roomWithCode:(NSString *)code region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Room *)roomWithCode:(NSString *)code region:(Region *)region;


@end


@interface Room (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

