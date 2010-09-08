//
//  Property.m
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/29.
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

#import "Property.h"


@implementation Property

+ (Property *)sharedProperty
{
    return (Property *)[super sharedProperty];
}

- (void)dealloc
{
    [iOS4 release];
    [super dealloc];
}

- (void)setJapanese:(BOOL)value
{
    [self setBoolValue:value forKey:@"japanese"];
}

- (BOOL)japanese
{
    BOOL isJapanese = [[[NSLocale currentLocale] localeIdentifier] isEqualToString:@"ja_JP"];
    return [self boolValueForKey:@"japanese" defaultValue:isJapanese];
}

- (void)setSessionSearchHistories:(NSArray *)array
{
    [self setArray:array forKey:@"sessionSearchHistories"];
}


- (NSArray *)sessionSearchHistories
{
    return [self arrayForKey:@"sessionSearchHistories"];
}


- (void)setFavoriteSessons:(NSArray *)array
{
    [self setArray:array forKey:@"favoriteSessons"];
}


- (NSArray *)favoriteSessons
{
    return [self arrayForKey:@"favoriteSessons"];
}



- (void)setFavoriteLightningTalks:(NSArray *)array
{
    [self setArray:array forKey:@"favoriteLightningTalks"];
}


- (NSArray *)favoriteLightningTalks
{
    return [self arrayForKey:@"favoriteLightningTalks"];
}


- (void)setUpdatedAt:(NSDate *)date
{
    [self setDate:date forKey:@"lastUpdated"];
}

- (NSDate *)updatedAt
{
    return [self dateForKey:@"lastUpdated"];
}


- (void)setArchiveUpdatedAt:(NSDate *)date
{
    [self setDate:date forKey:@"archiveUpdatedAt"];
}

- (NSDate *)archiveUpdatedAt
{
    return [self dateForKey:@"archiveUpdatedAt"];
}




- (BOOL)iOS4
{
    if (iOS4 == nil) {
        NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
        iOS4 = [NSNumber numberWithBool:[components respondsToSelector:@selector(timeZone)]];
    }
    return [iOS4 boolValue];
}

- (NSString *)version
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
}


@end
