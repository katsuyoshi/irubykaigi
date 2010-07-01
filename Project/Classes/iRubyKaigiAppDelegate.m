//
//  iRubyKaigi2009AppDelegate.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/01.
//  Copyright ITO SOFT DESIGN Inc 2009. All rights reserved.
//

#import "iRubyKaigiAppDelegate.h"
#import "SessionTableViewController.h"
#import "TestDataImporter.h"

@implementation iRubyKaigiAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {

    [[[TestDataImporter new] autorelease] import];

    tabBarController.viewControllers = [NSArray arrayWithObject:[SessionTableViewController navigationController]];
    UITabBarItem *tabBarItem = [tabBarController.tabBar.items lastObject];
// DELETEME:    tabBarItem.title = NSLocalizedString(@"Date", nil);
    tabBarItem.image = [UIImage imageNamed:@"session_by_date_icon_30x30.png"];

    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    
    
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[tabBarController release];
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

