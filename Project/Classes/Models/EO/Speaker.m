// 
//  Speaker.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/06/01.
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

#import "Speaker.h"
#import "CiderCoreData.h"
#import "LightningTalk.h"
#import "Region.h"
#import "Session.h"
#import "CiderCoreData.h"


@implementation Speaker 

@dynamic name;
@dynamic code;
@dynamic position;
@dynamic lightningTalks;
@dynamic sessions;
@dynamic region;
@dynamic profile;
@dynamic belongings;



+ (Speaker *)speakerWithCode:(NSString *)code region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.predicate = [NSPredicate predicateWithFormat:@"region = %@ and code = %@", region, code];
    condition.managedObjectContext = context;
    Speaker *speaker = [Speaker find:condition error:NULL];
    if (speaker == nil) {
        speaker = [Speaker createWithManagedObjectContext:context];
        speaker.code = code;
        speaker.region = region;
    }
    return speaker;
}


+ (Speaker *)speakerWithCode:(NSString *)code region:(Region *)region
{
    return [self speakerWithCode:code region:region inManagedObjectContext:DEFAULT_MANAGED_OBJECT_CONTEXT];
}

+ (NSString *)listScopeName
{
    return @"region";
}

+ (Speaker *)findByName:(NSString *)name region:(Region *)region
{
    return [self findByName:name region:region inManagedObjectContext:nil];
}

+ (Speaker *)findByName:(NSString *)name region:(Region *)region inManagedObjectContext:(NSManagedObjectContext *)context
{
    ISFetchRequestCondition *condition = [ISFetchRequestCondition fetchRequestCondition];
    condition.predicate = [NSPredicate predicateWithFormat:@"name = %@ and region = %@", name, region];
    condition.managedObjectContext = context;
    return [Speaker find:condition error:NULL];
}

- (NSSet *)sessions
{
    NSMutableSet *sessions = [self primitiveValueForKey:@"sessions"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day != nil"];
    return [sessions filteredSetUsingPredicate:predicate];
}

- (NSArray *)sortedSession
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"day.date, time"];
    return [[self.sessions allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSString *)firstLetterOfName
{
    if ([self.name length]) {
        NSString *str = [self.upperCaseName substringToIndex:1];
        str = [str uppercaseString];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[A-Z]$'"];
        return [predicate evaluateWithObject:str] ? str : @"#";
    } else {
        return nil;
    }
}

- (NSString *)upperCaseName
{
    return [self.name uppercaseString];
}

- (Speaker *)speakerForRegion:(Region *)region
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"region = %@ and code = %@", region, self.code];
    return [Speaker findWithPredicate:predicate sortDescriptors:nil managedObjectContext:self.managedObjectContext error:NULL];
}

+ (NSString *)stripWithString:(NSString *)string
{
    while([string characterAtIndex:0] == ' ') {
        string = [string substringFromIndex:1];
    }
    while ([string length]) {
        int index = [string length] - 1;
        if ([string characterAtIndex:index] == ' ') {
            string = [string substringToIndex:index];
        } else {
            break;
        }
    }
    return string;
}

+ (NSArray *)belongingsFromString:(NSString *)string
{
    if ([string length]) {
        // 1.0.で所属がない場合にプロフィールが表示されない不具合を回避する為に
        // 所属無しの場合は所属データに'　'のダミーを入れていたので、その判定
        if ([string isEqualToString:@"　"] == NO) {
            NSMutableArray *result = [NSMutableArray array];
            for (NSString *str in [string componentsSeparatedByString:@","]) {
                str = [self stripWithString:str];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] '^(inc|ltd|uk).*'"];
                if ([predicate evaluateWithObject:str]) {
                    int index = [result count] - 1;
                    if (index >= 0) {
                        NSArray *array = [NSArray arrayWithObjects:[result lastObject], str, nil];
                        [result replaceObjectAtIndex:index withObject:[array componentsJoinedByString:@","]];
                    }
                } else {
                    [result addObject:str];
                }
            }
            return result;
        }
    }
    return [NSArray array];
}

- (NSArray *)sortedBelongings
{
    return [[self.belongings allObjects] sortedArrayUsingDescriptors:[NSSortDescriptor sortDescriptorsWithString:@"position"]];
}

- (NSArray *)displayAttributesForTableViewController:(UITableViewController *)controller editing:(BOOL)editing
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"name", nil];
    if ([self.belongings count]) {
        [array addObject:@"belongings.title"];
    }
    if ([self.profile length]) {
        [array addObject:@"profile"];
    }
    return array;
}


@end
