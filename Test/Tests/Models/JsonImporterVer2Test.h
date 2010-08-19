//
//  JsonImporterVer2Test.h
//  iRubyKaigiTest
//
//  Created by Katsuyoshi Ito on 10/08/13.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelTest.h"

@class Speaker;
@class Region;

@interface JsonImporterVer2Test : ModelTest {

}

- (Speaker *)speakerForName:(NSString *)name region:(Region *)region;

@end
