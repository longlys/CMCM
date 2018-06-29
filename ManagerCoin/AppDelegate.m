//
//  AppDelegate.m
//  ManagerCoin
//
//  Created by LongLy on 04/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "AppDelegate.h"
#import "CMCMSegmentedViewController.h"
#import "CMCMPortfolioViewController.h"
#import "CMCMSearchViewController.h"
#import "CMCMApplication.h"
#import "CMCMNavigationViewController.h"
#import "CMCMWindow.h"

@interface AppDelegate ()
@property(nonatomic) UITabBarController *tabbar;
@property (nonatomic, strong, readwrite) CMCMDatabaseManager *databaseManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[CMCMWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ((CMCMWindow*)_window).isFullscreen = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:[self styleStatusBar]];

    self.tabbar = [[UITabBarController alloc] init];
    self.tabbar.tabBar.barTintColor = sBackgroundColor;
    self.tabbar.tabBar.tintColor = sTinColor;

    self.tabbar.viewControllers = [self viewControllers];
    self.window.rootViewController = self.tabbar;
    [self.window makeKeyAndVisible];
    [[CMCMApplication sharedInstance] setupDatabase];

    return YES;
}
- (UIStatusBarStyle)styleStatusBar {
    return UIStatusBarStyleLightContent;
}

- (NSArray *) viewControllers {
    
    //////
    //Home View Controllers
    //////
    id homeViewController = [[CMCMSegmentedViewController alloc] init];
    CMCMNavigationViewController *homeNC = [[CMCMNavigationViewController alloc] initWithRootViewController:homeViewController];
    [homeNC.navigationBar setTintColor:sBackgroundColor];
    UIImage *infoIcon0 = [UIImage imageNamed:@"market-cap"];
    UIImage *infoIconSelected0 =[UIImage imageNamed:@"market-cap-selected"];
    homeNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home"
                                                      image:infoIcon0
                                              selectedImage:infoIconSelected0];
    
    id searchController = [[CMCMSearchViewController alloc] init];
    CMCMNavigationViewController *searchNC = [[CMCMNavigationViewController alloc] initWithRootViewController:searchController];
    [searchNC.navigationBar setBackgroundColor:sBackgroundColor];
    UIImage *infoIcon3 = [UIImage imageNamed:@"icon_tab_search"];
    UIImage *infoIconSelected3 =[UIImage imageNamed:@"icon_tab_search"];
    searchNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"search"
                                                    image:infoIcon3
                                            selectedImage:infoIconSelected3];
    

    //////
    //Second View PORTFOLIO
    //////
    id myController = [[CMCMPortfolioViewController alloc] init];
    CMCMNavigationViewController *myNC = [[CMCMNavigationViewController alloc] initWithRootViewController:myController];
    [myNC.navigationBar setBackgroundColor:sBackgroundColor];
    UIImage *infoIcon2 = [UIImage imageNamed:@"vi"];
    UIImage *infoIconSelected2 =[UIImage imageNamed:@"vi-selected"];
    myNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Portfolio"
                                                      image:infoIcon2
                                              selectedImage:infoIconSelected2];
    
    
    return @[homeNC, searchNC, myNC];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
