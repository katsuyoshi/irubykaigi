//
//  SummaryViewController.h
//  iRubyKaigi
//
//  Created by Katsuyoshi Ito on 10/08/16.
//  Copyright 2010 ITO SOFT DESIGN Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SummaryViewController : UIViewController {

    NSString *text;
    IBOutlet UITextView *textView;
    
}

+ (SummaryViewController *)summaryViewController;


@property (retain) NSString *text;

@end
