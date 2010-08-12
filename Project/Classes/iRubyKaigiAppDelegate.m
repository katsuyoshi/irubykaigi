//
//  iRubyKaigi2009AppDelegate.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/01.
//  Copyright ITO SOFT DESIGN Inc 2009. All rights reserved.
//

#import "iRubyKaigiAppDelegate.h"
#import "SpeakerTableViewController.h"
#import "RoomTableViewController.h"
#import "SettingTableViewController.h"
#import "FavoriteSessionTableViewController.h"
#import "FindTableViewController.h"
#import "UIColorIRK.h"

#import "TestDataImporter.h"
#import "Importer.h"


@implementation iRubyKaigiAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {

    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    
    // モデルの更新
    @try {
        DEFAULT_MANAGED_OBJECT_CONTEXT;
    }
    @catch (NSException * e) {
NSLog(@"%@", e);
    }
    @finally {
        
    }
    
    // 未登録の場合は初期データをインポートする
    Importer *importer = [Importer defaultImporter];
    [importer addObserver:self forKeyPath:@"isUpdated" options:NSKeyValueObservingOptionNew context:importer];
//    [importer cleanUp];
    if ([Property sharedProperty].updatedAt == nil) {
        [[Importer defaultImporter] beginImport];
    }

    NSArray *iconNames = [NSArray arrayWithObjects:
                                @"session_by_room_icon_30x30.png",
                                @"session_by_speaker_icon_30x30.png",
                                @"favorite_30x30.png",
                                @"find_30x30.png",
                                @"setting_icon_30x30.png",
                                nil];
    
    NSArray *tabBarControllers = [NSArray arrayWithObjects:
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
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
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
    [[Importer defaultImporter] removeObserver:self forKeyPath:@"isUpdated"];

	[tabBarController release];
	[navigationController release];
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == [Importer defaultImporter]) {
/* FIXME: データが削除された時の場合に備えてだが、exception発生してしまう。
        for (UIViewController *controller in tabBarController.viewControllers) {
            if ([controller isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)controller popToRootViewControllerAnimated:NO];
            }
        }
*/
    }
}


@end

