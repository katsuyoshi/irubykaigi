//
//  Region.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SessionType.h"


@class Day, Room, Speaker;

@interface Region :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet* days;
@property (nonatomic, retain) NSSet* rooms;
@property (nonatomic, retain) NSSet* sessionTypes;
@property (nonatomic, retain) NSSet* speakers;




@property (assign, readonly) NSLocale *locale;
@property (assign, readonly) NSDateFormatter *dateFormatter;

@property (readonly) BOOL isJapanese;


+ (Region *)regionWithIdentifier:(NSString *)identifier inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Region *)japaneseInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Region *)englishInManagedObjectContext:(NSManagedObjectContext *)context;

+ (Region *)regionWithIdentifier:(NSString *)identifier;
+ (Region *)japanese;
+ (Region *)english;

// access for day
- (Day *)dayForDate:(NSDate *)date;
- (NSArray *)sortedDays;

// access for session tyep
- (SessionType *)sessionTypeForCode:(SessionTypeCode)code;

// access for room
- (Room *)roomForCode:(NSString *)code;

// access for speaker
- (Speaker *)speakerForCode:(NSString *)code;


@end


@interface Region (CoreDataGeneratedAccessors)
- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSSet *)value;
- (void)removeDays:(NSSet *)value;

- (void)addRoomsObject:(NSManagedObject *)value;
- (void)removeRoomsObject:(NSManagedObject *)value;
- (void)addRooms:(NSSet *)value;
- (void)removeRooms:(NSSet *)value;

- (void)addSessionTypesObject:(NSManagedObject *)value;
- (void)removeSessionTypesObject:(NSManagedObject *)value;
- (void)addSessionTypes:(NSSet *)value;
- (void)removeSessionTypes:(NSSet *)value;

- (void)addSpeakersObject:(NSManagedObject *)value;
- (void)removeSpeakersObject:(NSManagedObject *)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

@end

