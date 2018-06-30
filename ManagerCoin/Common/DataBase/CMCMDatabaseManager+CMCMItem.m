//
//  CMCMDatabaseManager+CMCMItem.m
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMDatabaseManager+CMCMItem.h"
#import <FMResultSet.h>

@implementation CMCMDatabaseManager (CMCMProtfolio)

+ (CMCMModelProtfolio *)parseTrackItemsWithResulSet:(FMResultSet *)s{
    CMCMModelProtfolio *itemModel = [CMCMModelProtfolio new];
    itemModel.idCoin = [s stringForColumn:@"idCoin"];
    itemModel.title = [s stringForColumn:@"title"];
    itemModel.quanlity = [s intForColumn:@"quanlity"];
    itemModel.price = [s intForColumn:@"price"];
    itemModel.total = [s intForColumn:@"total"];
    itemModel.priceType = [s intForColumn:@"priceType"];
    itemModel.symbol = [s stringForColumn:@"symbol"];
    itemModel.artwork = [s stringForColumn:@"artwork"];
    itemModel.idItemPro = [s stringForColumn:@"idItemPro"];
    return itemModel;
}

- (void)allTracks:(void (^)(NSArray *arrayItems))completion {
    [self readWithBlock:^BOOL(CMCMDatabaseManagerReadBlock readBlock) {
        FMResultSet *resultSet = readBlock(@"SELECT * FROM MCoin");
        if (resultSet) {
            NSMutableArray *arrayResult = [NSMutableArray new];
            while ([resultSet next]) {
                [arrayResult addObject:[CMCMDatabaseManager parseTrackItemsWithResulSet:resultSet]];
            }
            [resultSet close];
            [self mainTheard:^{
                if (completion) completion(arrayResult);
            }];
        } else {
            [self mainTheard:^{
                if (completion) completion(nil);
            }];
            
        }
        
        return YES;
    }];
}

- (void)searchTrackWithId:(NSString *)trackId completion:(void (^)(CMCMModelProtfolio *trackModel, NSError * error))completeBlock {
    [self readWithBlock:^BOOL(CMCMDatabaseManagerReadBlock readBlock) {
        NSString *sql = @"SELECT * FROM MCoin WHERE idCoin = ? LIMIT 1";//trackID is unique field
        FMResultSet *result = readBlock(sql,trackId);
        if ([result next]) {
            CMCMModelProtfolio *model = [CMCMDatabaseManager parseTrackItemsWithResulSet:result];
            [self mainTheard:^{
                if (completeBlock) completeBlock(model, nil);
            }];
        } else {
            [self mainTheard:^{
                if (completeBlock) completeBlock(nil, nil);
            }];
        }
        [result close];
        return YES;
    }];
}

- (void)insertTrackItem:(CMCMModelProtfolio *)trackModel withComplete:(void (^)(CMCMModelProtfolio *trackModel, NSError *error))completeBlock {
    [self writeWithBlock:^BOOL(CMCMDatabaseManagerWriteBlock writeBlock) {
        if (trackModel) {
            NSString *sql = @"INSERT INTO MCoin (idCoin, quanlity, createAt, title, price, artwork, total, priceType, symbol, idItemPro) VALUES (?,?,?,?,?,?,?,?,?,?)";

            BOOL result = writeBlock(sql, trackModel.idCoin, @(trackModel.quanlity), trackModel.tradedate, trackModel.title, @(trackModel.price), trackModel.artwork, @(trackModel.total), @(trackModel.priceType), trackModel.symbol, trackModel.idItemPro);
            if (result) {
                [self mainTheard:^{
                    if (completeBlock) completeBlock(trackModel, nil);
                }];
                return YES;
            } else {
                [self mainTheard:^{
                    if (completeBlock) completeBlock(nil, nil);
                }];
                return NO;
            }
        } else {
            NSLog(@"Can't insert empty track");
            [self mainTheard:^{
                completeBlock(nil, nil);
            }];
            return NO;
        }
    }];
}

- (void)deleteTracks:(NSArray *)tracks completion:(void (^)(NSError *))completion {
    [self syncQueryWithBlock:^BOOL(CMCMDatabaseManagerReadBlock readBlock, CMCMDatabaseManagerWriteBlock writeBlock) {
        
        if (tracks.count == 0) {
            NSLog(@"Can't delete empty track");
            [self mainTheard:^{
                if (completion) completion(nil);
            }];
            return YES;
        } else {
            
            NSMutableDictionary *dictionaryDelete = [NSMutableDictionary new];
            for (CMCMModelProtfolio *track in tracks) {
                NSString *sql = @"DELETE FROM MCoin WHERE idCoin = ?";//"LIMIT 1" can not be used in sqlite
                BOOL success = writeBlock(sql, track.idCoin);
                
                if (success) {
                    [dictionaryDelete setObject:track forKey:track.idCoin];
                } else {
                    [self mainTheard:^{
                        if (completion) completion(nil);
                    }];
                    return NO;
                }
                
                
            }
            
//            NSMutableDictionary *changedPlaylists = [NSMutableDictionary dictionary];
//            if (playlistIDs.count) {
//                //Opps, some playlist has changed, need to tell everyone this thing
//                for (NSNumber *playlistID in playlistIDs) {
//                    FMResultSet *rs = readBlock(CMCMDatabaseManager_CMCMPlaylists_GetAllPlaylistByIDSql, playlistID);
//                    if (rs.next) {
//                        CMCMPlaylistModel *pl = [self.class parsePlaylistWithResultSet:rs];
//                        [changedPlaylists setObject:pl forKey:@(pl.playlistID)];
//                    }
//                    [rs close];
//                }
//            }
            
            //OK, we deleted all track which need to be deleted, it's time to notify
            [self mainTheard:^{
                if (completion) completion(nil);
            }];
            
//            if (dictionaryDelete.count) {
//                [self databaseManagerCallDelegateActionWithType:CMCMDatabaseActionTypeDelete object:dictionaryDelete];
//            }
            return YES;
        }
    }];
}

@end
