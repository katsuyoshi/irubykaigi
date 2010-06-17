//
//  Session.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class LightningTalk;

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
@property (nonatomic, retain) NSManagedObject * day;
@property (nonatomic, retain) NSManagedObject * room;
@property (nonatomic, retain) NSSet* lightningTalks;
/** NSFetchResultsControllerで対多の検索が出来ないので、検索の為にスピーカー名の生データを持つ. */
@property (nonatomic, retain) NSString * speakerRawData;

@end


@interface Session (CoreDataGeneratedAccessors)
- (void)addSpeakersObject:(NSManagedObject *)value;
- (void)removeSpeakersObject:(NSManagedObject *)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

- (void)addLightningTalksObject:(LightningTalk *)value;
- (void)removeLightningTalksObject:(LightningTalk *)value;
- (void)addLightningTalks:(NSSet *)value;
- (void)removeLightningTalks:(NSSet *)value;

@end
