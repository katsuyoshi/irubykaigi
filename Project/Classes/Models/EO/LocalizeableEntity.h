//
//  LocalizeableEntity.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/05/26.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface LocalizeableEntity :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * locale;

@end



