//
//  iRubyKaigi2009AppDelegate.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/01.
//  Copyright ITO SOFT DESIGN Inc 2009. All rights reserved.
//

#import "iRubyKaigiAppDelegate.h"
#import "SessionTableViewController.h"
#import "SpeakerTableViewController.h"
#import "RoomTableViewController.h"
#import "SettingTableViewController.h"
#import "FavoriteSessionTableViewController.h"
#import "FindTableViewController.h"
#import "UIColorIRK.h"

#import "TestDataImporter.h"

@implementation iRubyKaigiAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {

    NSArray *iconNames = [NSArray arrayWithObjects:
//                                @"session_by_date_icon_30x30.png",
                                @"session_by_room_icon_30x30.png",
                                @"session_by_speaker_icon_30x30.png",
                                @"favorite_30x30.png",
                                @"find_30x30.png",
                                @"setting_icon_30x30.png",
                                nil];
                                
    [[[TestDataImporter new] autorelease] import];

    NSArray *tabBarControllers = [NSArray arrayWithObjects:
// DELETEME:                                    [SessionTableViewController navigationController],
                                    [RoomTableViewController navigationController],
                                    [SpeakerTableViewController navigationController],
                                    [FavoriteSessionTableViewController navigationController],
                                    [FindTableViewController navigationController],
                                    [SettingTableViewController navigationController],
                                    nil];
    tabBarController.viewControllers = tabBarControllers;
    
    NSEnumerator *iconEnumerator = [iconNames objectEnumerator];
    for (UITabBarItem *tabBarItem in tabBarController.tabBar.items) {
        tabBarItem.image = [UIImage imageNamed:[iconEnumerator nextObject]];
    }
    
    
    window.backgroundColor = [UIColor normalSessionColor];
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    [application setStatusBarHidden:NO animated:YES];
    
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

