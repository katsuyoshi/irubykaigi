//
//  Session.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
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

@class LightningTalk;
@class Room;
@class Day;
@class Speaker;
@class Region;

typedef enum {
    SessionTypeCodeNormal = 1,
    SessionTypeCodeKeynote,
    SessionTypeCodeOpening,
    SessionTypeCodeClosing,
    SessionTypeCodeLightningTalks,
    SessionTypeCodeParty,

    SessionTypeCodeOpenAndAdmission = 100,
    SessionTypeCodeBreak,
    SessionTypeCodeLunch,
    
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

@property (assign, readonly) NSArray *sortedSpeakers;


- (Session *)sessionForRegion:(Region *)region;

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

