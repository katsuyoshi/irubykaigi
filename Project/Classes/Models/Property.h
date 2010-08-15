//
//  Property.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/29.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CiderCoreData.h"

@interface Property : ISProperty {

    NSNumber *iOS4;
    
}

+ (Property *)sharedProperty;

@property BOOL japanese;

@property (assign) NSArray *sessionSearchHistories;

@property (assign) NSArray *favoriteSessons;

@property (assign) NSArray *favoriteLightningTalks;

@property (assign) NSDate *updatedAt;

@property (getter=iOS4, readonly) BOOL isIOS4;

@property (assign, readonly) NSString *version;

@end
