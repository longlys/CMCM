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
#import "RBTabbarViewController.h"
#import "CMCMSettingsViewController.h"

@import Firebase;
@interface AppDelegate ()
@property(nonatomic) UITabBarController *tabbar;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    _window = [[CMCMWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ((CMCMWindow*)_window).isFullscreen = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:[self styleStatusBar]];
    [sApplication setupDatabase];

    [self setupRootViewController];
    [self.window makeKeyAndVisible];

    return YES;
}
- (UIStatusBarStyle)styleStatusBar {
    return UIStatusBarStyleLightContent;
}

- (void)setupRootViewController {
    
    //////
    //Home View Controllers
    //////
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    CMCMSegmentedViewController *homeVC = [CMCMSegmentedViewController new];
    CMCMNavigationViewController *navHome = [[CMCMNavigationViewController alloc] initWithRootViewController:homeVC];
    navHome.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"market-cap"] selectedImage:[UIImage imageNamed:@"market-cap-selected"]];
    [viewControllers addObject:navHome];

    
    CMCMSearchViewController *searchController = [CMCMSearchViewController new];
    CMCMNavigationViewController *searchNC = [[CMCMNavigationViewController alloc] initWithRootViewController:searchController];
    searchNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_tab_search"] selectedImage:[UIImage imageNamed:@"icon_tab_search"]];
    [viewControllers addObject:searchNC];

    CMCMPortfolioViewController *myController = [CMCMPortfolioViewController new];
    CMCMNavigationViewController *myNC = [[CMCMNavigationViewController alloc] initWithRootViewController:myController];
    myNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"vi"] selectedImage:[UIImage imageNamed:@"vi-selected"]];
    [viewControllers addObject:myNC];

    CMCMSettingsViewController *settingVC = [CMCMSettingsViewController new];
    CMCMNavigationViewController *settingNC = [[CMCMNavigationViewController alloc] initWithRootViewController:settingVC];
    settingNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"settings"] selectedImage:[UIImage imageNamed:@"settings"]];
    [viewControllers addObject:settingNC];

    //////
    //Second View PORTFOLIO
    //////
    
    RBTabbarViewController *tabbarViewController = [[RBTabbarViewController alloc] init];
    [tabbarViewController fmn_setViewControllers:viewControllers];
    self.window.rootViewController = tabbarViewController;
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
