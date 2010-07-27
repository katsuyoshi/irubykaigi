//
//  LightningTalk.h
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Session;
@class Speaker;

@interface LightningTalk : NSManagedObject {

}

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;

@property (nonatomic, retain) Session * session;
@property (nonatomic, retain) NSSet* speakers;

@end

// coalesce these into one @interface LightningTalk (CoreDataGeneratedAccessors) section
@interface LightningTalk (CoreDataGeneratedAccessors)
- (void)addSpeakersObject:(Speaker *)value;
- (void)removeSpeakersObject:(Speaker *)value;
- (void)addSpeakers:(NSSet *)value;
- (void)removeSpeakers:(NSSet *)value;

@end

