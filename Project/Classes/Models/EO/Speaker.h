//
//  Speaker.h
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/06/01.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class LightningTalk;
@class Region;
@class Session;

@interface Speaker :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * belonging;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSSet* lightningTalks;
@property (nonatomic, retain) NSSet* sessions;
@property (nonatomic, retain) Region * region;

@property (assign, readonly) NSArray *sortedSession;
@property (assign, readonly) NSString *firstLetterOfName;
@property (assign, readonly) NSString *upperCaseName;



+ (Speaker *)speakerWithCode:(NSString *)code region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Speaker *)speakerWithCode:(NSString *)code region:(Region *)region;

+ (Speaker *)findByName:(NSString *)name region:(Region *)region;
+ (Speaker *)findByName:(NSString *)name region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context;

- (Speaker *)speakerForRegion:(Region *)region;

@end

// coalesce these into one @interface Speaker (CoreDataGeneratedAccessors) section
@interface Speaker (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

- (void)addLightningTalksObject:(LightningTalk *)value;
- (void)removeLightningTalksObject:(LightningTalk *)value;
- (void)addLightningTalks:(NSSet *)value;
- (void)removeLightningTalks:(NSSet *)value;
@end


