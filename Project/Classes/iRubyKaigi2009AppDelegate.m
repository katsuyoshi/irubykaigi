//
//  iRubyKaigi2009AppDelegate.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/01.
//  Copyright ITO SOFT DESIGN Inc 2009. All rights reserved.
//

#import "iRubyKaigi2009AppDelegate.h"


@implementation iRubyKaigi2009AppDelegate

@synthesize window;
@synthesize navigationController, firstSessionViewController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    Document *document = [Document sharedDocument];
    [document import];
    
    firstSessionViewController = [[SessionTableViewController alloc] initWithStyle:UITableViewStylePlain];

    // 日付を設定
    SessionTableViewController *sessionViewController = firstSessionViewController;
    SessionTableViewController *currentViewController = firstSessionViewController;
    NSArray *days = [document days];
    NSDate *selectedDay = [document selectedDay];
    
    sessionViewController.day = [[days objectAtIndex:0] valueForKey:@"date"];
    int i, count = [days count];
    for (i = 1; i < count; i++) {
        NSDate *day = [[days objectAtIndex:i] valueForKey:@"date"];
        sessionViewController.nextDay = day;
        sessionViewController = sessionViewController.nextDaysSessionController;
        if ([sessionViewController.day isEqual:selectedDay]) {
            currentViewController = sessionViewController;
        }
    }
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:firstSessionViewController];
//    navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [navigationController setToolbarHidden:NO animated:NO];
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];

    [firstSessionViewController moveToController:currentViewController];
    
    if ([document needsUpdate]) {
        [document beginUpdate];
    }
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

