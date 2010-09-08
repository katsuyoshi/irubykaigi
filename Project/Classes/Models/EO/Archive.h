//
//  Archive.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/09/05.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@class LightningTalk;
@class Session;

@interface Archive :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) LightningTalk * lightningTalk;
@property (nonatomic, retain) Session * session;
@property (nonatomic, retain) NSNumber * position;

@end



