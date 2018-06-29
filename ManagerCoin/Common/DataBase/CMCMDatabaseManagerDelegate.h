//
//  CMCMDatabaseManagerDelegate.h
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

typedef enum {
    CMCMDatabaseActionTypeInsert,
    CMCMDatabaseActionTypeDelete,
    CMCMDatabaseActionTypeUpdate,
    CMCMDatabaseActionTypeRestore,
} CMCMDatabaseActionType;

@class CMCMDatabaseManager;

@protocol CMCMDatabaseManagerDelegate <NSObject>

@required
- (void)databaseManager:(CMCMDatabaseManager *)databaseManager
             actionType:(CMCMDatabaseActionType)actionType
                 object:(id)object;

@end

