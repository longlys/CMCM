//
//  CMCMApplication.h
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCMDatabaseManager.h"
#import "CMCMDatabaseManager+CMCMItem.h"
#import "RBAdsManager.h"

#define sApplication [CMCMApplication sharedInstance]
#define sAdsManager [[CMCMApplication sharedInstance] adsManager]
@interface CMCMApplication : NSObject
@property (nonatomic, strong, readonly) CMCMDatabaseManager *databaseManager;
@property (nonatomic, strong, readonly) RBAdsManager *adsManager;

+ (instancetype)sharedInstance;
+ (NSString *)DBPath;
- (void)setupDatabase;

@end
