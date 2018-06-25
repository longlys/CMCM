//
//  DatabaseManager.m
//  ManagerCoin
//
//  Created by LongLy on 25/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h"
#import "CMCMModelProtfolio.h"

@implementation DatabaseManager {
    FMDatabase *db;
}

+ (instancetype) shareInstance{
    static DatabaseManager *_shareObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_shareObject == nil) {
            _shareObject = [[self alloc] init];
        }
    });
    return _shareObject;
}

- (id) init{
    self = [super init];
    if (self) {
        [self createDatabaseAndTableIfNeed];
    }
    return self;
}

- (void) createDatabaseAndTableIfNeed{
    NSString *docmentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dbPath = [docmentPath stringByAppendingPathComponent:@"db.sqlite"];
    db = [FMDatabase databaseWithPath:dbPath];
    NSLog(@"%@", dbPath);
    [db open];
    
    NSString *sql = @"CREATE TABLE IF NOT EXISTS Item (title Text, quanlity Text, price Text, tradedate Text, total Text, priceType Text, symbol Text, artwork Text, idItemPro Integer)";
    BOOL isOK = [db executeUpdate:sql];
    if (isOK) {
        NSLog(@"Tao Table Item thanh cong");
    } else {
        NSLog(@"Tao Table Item khong thanh cong");
    }
    [db close];
}


- (BOOL) insertTrackModel: (CMCMModelProtfolio *)itemModel{
    [db open];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Item (title, quanlity, price, tradedate, total, priceType, symbol, artwork, idItemPro) VALUES ('%@',%ld,%ld,'%@',%ld,'%ld','%@','%@','%ld')", itemModel.title, itemModel.quanlity, itemModel.price, itemModel.tradedate, itemModel.total, (long)itemModel.priceType, itemModel.symbol, itemModel.artwork, (long)itemModel.idItemPro];
    BOOL isOK = [db executeUpdate:sql, [NSString stringWithFormat:@"%@", itemModel.title]];
    [db close];
    return isOK;
}

- (NSMutableArray *) listTracksWithType{
    [db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT rowid, * FROM Item "];
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *items = [NSMutableArray array];
    while ([rs next]) {
        CMCMModelProtfolio *itemModel = [[CMCMModelProtfolio alloc] init];
        itemModel.idItemPro = [rs intForColumn:@"idItemPro"];
        itemModel.title = [rs stringForColumn:@"title"];
        itemModel.quanlity = [rs intForColumn:@"quanlity"];
        itemModel.price = [rs intForColumn:@"price"];
        itemModel.total = [rs intForColumn:@"total"];
        itemModel.priceType = [rs intForColumn:@"priceType"];
        itemModel.symbol = [rs stringForColumn:@"symbol"];
        itemModel.artwork = [rs stringForColumn:@"artwork"];
        [items addObject:itemModel];
    }
    [db close];
    return items;
}

- (BOOL) moveTrack: (CMCMModelProtfolio *) trackModel{
    NSString *sql = [NSString stringWithFormat:@"UPDATE Item WHERE rowid = %ld", (long)trackModel.idItemPro];
    [db open];
    BOOL isOK = [db executeUpdate:sql];
    [db close];
    return isOK;
}

- (BOOL) deleteTrack: (CMCMModelProtfolio *) trackModel {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Item WHERE rowid = %ld", (long)trackModel.idItemPro];
    [db open];
    BOOL isOK = [db executeUpdate:sql];
    [db close];
    NSLog(@"D-=---- %@", isOK);
    return isOK;
}
-(BOOL) checkID: (CMCMModelProtfolio *) trackModel
{
    [db open];
    NSString *sql = [NSString stringWithFormat:@"select count(*) from Item WHERE id (long)= %ld", (long)trackModel.idItemPro];
    NSUInteger counts = [db intForQuery:sql];
    [db close];
    if (counts > 0) {
        return YES;
    } else {
        return NO;
    }
}
@end
