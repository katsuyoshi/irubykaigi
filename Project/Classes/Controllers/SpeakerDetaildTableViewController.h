//
//  SpeakerDetaildTableViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/08/12.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractSessionDetaildTableViewController.h"


@interface SpeakerDetaildTableViewController : AbstractSessionDetaildTableViewController {

}

+ (SpeakerDetaildTableViewController *)speakerDetailedTableViewController;

@property (assign, readonly) Speaker *speaker;

@end
