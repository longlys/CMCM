//
//  CMCMDatabaseManager+CMCMItem.h
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMDatabaseManager.h"
#import "CMCMModelProtfolio.h"

@interface CMCMDatabaseManager (CMCMProtfolio)

+ (CMCMModelProtfolio *)parseTrackItemsWithResulSet:(FMResultSet *)s;

- (void)allTracks:(void (^)(NSArray *arrayItems))completion;
- (void)insertTrackItem:(CMCMModelProtfolio *)trackModel withComplete:(void (^)(CMCMModelProtfolio *trackModel, NSError *error))completeBlock;
- (void)deleteTracks:(NSArray *)tracks completion:(void (^)(NSError *error))completion;

@end
