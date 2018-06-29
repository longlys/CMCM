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

#define sApplication [MSTApplication sharedInstance]

@interface CMCMApplication : NSObject
@property (nonatomic, strong, readonly) CMCMDatabaseManager *databaseManager;

+ (instancetype)sharedInstance;
+ (NSString *)DBPath;
- (void)setupDatabase;

@end
