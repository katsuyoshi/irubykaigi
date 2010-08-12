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
@dynamic belonging;
@dynamic position;
@dynamic lightningTalks;
@dynamic sessions;
@dynamic region;
@dynamic profile;


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

- (NSArray *)sortedSession
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"day.date, time"];
    return [self.sessions sortedArrayUsingDescriptors:sortDescriptors];
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

- (NSArray *)belongings
{
    if ([self.belonging length]) {
        return [self.belonging componentsSeparatedByString:@","];
    } else {
        return [NSArray array];
    }
}


- (NSArray *)displayAttributesForTableViewController:(UITableViewController *)controller editing:(BOOL)editing
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"name", nil];
    if ([self.belonging length]) {
        [array addObject:@"belonging"];
    }
    if ([self.profile length]) {
        [array addObject:@"profile"];
    }
    return array;
}


@end
