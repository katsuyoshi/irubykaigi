//
//  iRubyKaigi2009AppDelegate.m
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/01.
//

/* 

  Copyright 2009 ITO SOFT DESIGN Inc. All rights reserved.

  Redistribution and use in source and binary forms, with or without modification,
  are permitted provided that the following conditions are met:
  
      * Redistributions of source code must retain the above copyright notice,
        this list of conditions and the following disclaimer.
 
      * Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.
 
      * Neither the name of ITO SOFT DESIGN Inc. nor the names of its
        contributors may be used to endorse or promote products derived from this
        software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

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
    [importer cleanUp];
    [importer addObserver:self forKeyPath:@"isUpdated" options:NSKeyValueObservingOptionNew context:importer];
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

