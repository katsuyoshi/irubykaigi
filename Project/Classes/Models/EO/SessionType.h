//
//  SessionType.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/31.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Region;
@class Session;

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


@interface SessionType :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * code;
@property (nonatomic, retain) Region * region;
@property (nonatomic, retain) NSSet* sessions;

+ (SessionType *)sessionTypeWithCode:(SessionTypeCode)code region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context;
+ (SessionType *)sessionTypeWithCode:(SessionTypeCode)code region:(Region *)region;

@end


@interface SessionType (CoreDataGeneratedAccessors)
- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)value;
- (void)removeSessions:(NSSet *)value;

@end

