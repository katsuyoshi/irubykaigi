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
@property (nonatomic, retain) LightningTalk * lightningTalk;
@property (nonatomic, retain) Session * session;
@property (nonatomic, retain) Region * region;

+ (Speaker *)speakerWithCode:(NSString *)code region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Speaker *)speakerWithCode:(NSString *)code region:(Region *)region;

@end



