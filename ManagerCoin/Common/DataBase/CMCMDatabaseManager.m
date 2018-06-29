//
//  CMCMDatabaseManager.m
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMDatabaseManager.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"

@interface FMDatabase (_GetPrivateMethod_)

- (BOOL)executeUpdate:(NSString*)sql error:(NSError**)outErr withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args;
- (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray*)arrayArgs orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args;

@end

@interface CMCMDatabaseManager ()

@property (nonatomic, strong) NSString *dbPath;
@property (nonatomic, strong) FMDatabaseQueue *readQueue;
@property (nonatomic, strong) FMDatabaseQueue *writeQueue;
@property (nonatomic, strong, readwrite) NSMapTable *delegates;

@end

@implementation CMCMDatabaseManager

- (instancetype)initWithPath:(NSString *)dbPath
{
    self = [super init];
    if (self) {
        self.delegates = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory
                                               valueOptions:NSMapTableWeakMemory];
        self.dbPath = dbPath;
        self.readQueue = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
        self.writeQueue = self.readQueue;//[FMDatabaseQueue databaseQueueWithPath:_dbPath];
    }
    return self;
}

- (void)writeWithBlock:(BOOL (^)(CMCMDatabaseManagerWriteBlock))block {
    [self.writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        CMCMDatabaseManagerWriteBlock excBlock = ^BOOL(NSString *sql,...) {
            va_list args;
            va_start(args, sql);
            return [db executeUpdate:sql error:nil withArgumentsInArray:nil orDictionary:nil orVAList:args];
        };
        if (!block(excBlock)) {
            *rollback = YES;
        }
    }];
}

- (void)readWithBlock:(BOOL (^)(CMCMDatabaseManagerReadBlock))block {
    [self.readQueue inDatabase:^(FMDatabase *db) {
        CMCMDatabaseManagerReadBlock excBlock = ^id(NSString *sql,...) {
            va_list args;
            va_start(args, sql);
            return [db executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:args];
        };
        block(excBlock);
    }];
}

- (void)syncQueryWithBlock:(BOOL (^)(CMCMDatabaseManagerReadBlock, CMCMDatabaseManagerWriteBlock))block {
    [self.writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        CMCMDatabaseManagerWriteBlock excWriteBlock = ^BOOL(NSString *sql,...) {
            va_list args;
            va_start(args, sql);
            return [db executeUpdate:sql error:nil withArgumentsInArray:nil orDictionary:nil orVAList:args];
        };
        
        CMCMDatabaseManagerReadBlock excReadBlock = ^id(NSString *sql,...) {
            va_list args;
            va_start(args, sql);
            return [db executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:args];
        };
        if (!block(excReadBlock, excWriteBlock)) {
            // rollback
            *rollback = YES;
        }
    }];
}

//- (void)databaseManagerCallDelegateActionWithType:(CMCMDatabaseActionType)actionType tableChange:(CMCMDatabaseTable)tableChange object:(id)object {
//    /* we have one delegate so if delegate can't action method we delete it. if update delegate method need check all delegate before delete it */
//    [self mainTheard:^{
//        for (NSString *keyValue in self.delegates) {
//            id delegate = [self.delegates objectForKey:keyValue];
//            if ([delegate respondsToSelector:@selector(databaseManager:actionType:tableChange:object:)]) {
//                [delegate databaseManager:self actionType:actionType tableChange:tableChange object:object];
//            }
//            
//            if (delegate == nil) {
//                [self.delegates removeObjectForKey:keyValue];
//            }
//            // check object == nil remove
//        }
//    }];
//}

- (void)mainTheard:(void (^)())mainTheard {
    dispatch_async(dispatch_get_main_queue(), ^{
        mainTheard();
    });
}


// change add delegate
- (void)addDelegate:(id<CMCMDatabaseManagerDelegate>)delegate {
    if (delegate) {
        [self.delegates setObject:delegate forKey:[NSString stringWithFormat:@"%p",delegate]];
    }
}

- (void)removeDelegate:(id<CMCMDatabaseManagerDelegate>)delegate {
    if (delegate) {
        [self.delegates removeObjectForKey:[NSString stringWithFormat:@"%p",delegate]];
    }
}

@end
