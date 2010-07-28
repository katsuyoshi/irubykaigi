//
//  iRubyKaigi2009AppDelegate.h
//  iRubyKaigi2009
//
//  Created by Katsuyoshi Ito on 09/07/01.
//  Copyright ITO SOFT DESIGN Inc 2009. All rights reserved.
//


@interface iRubyKaigiAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UITabBarController *tabBarController;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain, readonly) IBOutlet UINavigationController *navigationController;


@end

