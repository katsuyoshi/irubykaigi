//
//  Session.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class LightningTalk;
@class Room;
@class Day;
@class Speaker;

typedef enum {
    SessionTypeCodeNormal = 1,
    SessionTypeCodeKeynote,
    SessionTypeCodeOpening,
    SessionTypeCodeClosing,
    SessionTypeCodeLightningTalks,

    SessionTypeCodeOpenAndAdmission = 100,
    SessionTypeCodeBreak,
    SessionTypeCodeLunch,
    SessionTypeCodeParty,
    
    SessionTypeCodeAnnouncement = 200
} SessionTypeCode;



@interface Session :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * intermission;
@property (nonatomic, retain) NSString * profile;
@property (nonatomic, retain) NSString * attention;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSSet* speakers;
@property (nonatomic, retain) Day * day;
@property (nonatomic, retain) Room * room;
@property (nonatomic, retain) NSSet* talks;
@property (nonatomic, retain) NSNumber * sessionType;

/** NSFetchResultsControllerで対多の検索が出来ないので、検索の為にスピーカー名の生データを持つ. */
@property (nonatomic, retain) NSString * speakerRawData;

@property (assign, readonly) NSString *dayTimeTitle;


@property (readonly) BOOL isSession;
@property (readonly) BOOL isBreak;
@property (readonly) BOOL isAnnouncement;

@property (readonly) BOOL isLightningTalks;

@property (assign, readonly) NSString *startAt;
@property (assign, readonly) NSString *endAt;


@end


@interface Session (CoreDataGeneratedAccessors)
- (void)addSpeakersObject:(Speaker *)value;
- (void)removeSpeakersObject:(Speaker *)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

- (void)addLightningTalksObject:(LightningTalk *)value;
- (void)removeLightningTalksObject:(LightningTalk *)value;
- (void)addLightningTalks:(NSSet *)value;
- (void)removeLightningTalks:(NSSet *)value;

@end

