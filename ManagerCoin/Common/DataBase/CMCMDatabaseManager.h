//
//  CMCMDatabaseManager.h
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCMDatabaseManagerDelegate.h"
#import "FMResultSet.h"
#import "CMCMModelProtfolio.h"

typedef BOOL (^CMCMDatabaseManagerWriteBlock)(NSString *sql,...);
typedef FMResultSet* (^CMCMDatabaseManagerReadBlock)(NSString *sql,...);

@interface CMCMDatabaseManager : NSObject

- (void)addDelegate:(id<CMCMDatabaseManagerDelegate>)delegate;
- (void)removeDelegate:(id<CMCMDatabaseManagerDelegate>)delegate;

- (instancetype)initWithPath:(NSString *)dbPath;

- (void)writeWithBlock:(BOOL (^)(CMCMDatabaseManagerWriteBlock writeBlock))block;
- (void)readWithBlock:(BOOL (^)(CMCMDatabaseManagerReadBlock readBlock))block;

- (void)syncQueryWithBlock:(BOOL (^)(CMCMDatabaseManagerReadBlock readBlock, CMCMDatabaseManagerWriteBlock writeBlock))block;

- (void)mainTheard:(void (^)())mainTheard;

@end
