//
//  iRubyKaigi2009AppDelegate.h
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/01.
//  Copyright ITO SOFT DESIGN Inc 2009. All rights reserved.
//
#import "SessionTableViewController.h"
#import "Document.h"


@interface iRubyKaigiAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
    SessionTableViewController *firstSessionViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain, readonly) IBOutlet UINavigationController *navigationController;
@property (retain, readonly) SessionTableViewController *firstSessionViewController;


@end

