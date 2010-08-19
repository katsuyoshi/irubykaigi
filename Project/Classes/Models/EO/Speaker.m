// 
//  Speaker.m
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/06/01.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

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
    } else {
        return [NSArray array];
    }
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
