//
//  Region.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/28.
//

/* 

  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:
  
      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
 
      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.
 
      * Neither the name of ITO SOFT DESIGN Inc. nor the names of its
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#import <CoreData/CoreData.h>


@class Day, Room, Speaker;

@interface Region :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet* days;
@property (nonatomic, retain) NSSet* rooms;
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

// access for room
- (Room *)roomForCode:(NSString *)code;

// access for speaker
- (Speaker *)speakerForCode:(NSString *)code;

- (NSArray *)sessionsForDate:(NSDate *)date;

@end


@interface Region (CoreDataGeneratedAccessors)
- (void)addDaysObject:(Day *)value;
- (void)removeDaysObject:(Day *)value;
- (void)addDays:(NSSet *)value;
- (void)removeDays:(NSSet *)value;

- (void)addRoomsObject:(Room *)value;
- (void)removeRoomsObject:(Room *)value;
- (void)addRooms:(NSSet *)value;
- (void)removeRooms:(NSSet *)value;

- (void)addSpeakersObject:(Speaker *)value;
- (void)removeSpeakersObject:(Speaker *)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

@end

