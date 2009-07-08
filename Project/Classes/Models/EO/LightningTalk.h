//
//  LightningTalk.h
//  iRubyKaigi2009Test
//
//  Created by Katsuyoshi Ito on 09/07/08.
//  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LightningTalk : NSManagedObject {

}

@property (assign) NSManagedObject *room;
@property (assign, readonly) NSString *time;

@end
