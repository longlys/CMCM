//
//  AppDelegate.h
//  ManagerCoin
//
//  Created by LongLy on 04/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CMCMWindow;

#define sAppDelegate        ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) CMCMWindow *window;

@end

