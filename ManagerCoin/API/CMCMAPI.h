//
//  CMCMAPI.h
//  ManagerCoin
//
//  Created by LongLy on 04/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCMItemModel.h"
#import "CMCMModelSearch.h"

@interface CMCMAPI : NSObject
- (void)loadmoreListCoinWithStart:(NSInteger )start complete:(void (^)(NSArray *resul, NSError *error))completionBlock;
- (void)getDetailCoinWithPriceBTC:(NSInteger )idItem withCoinCover:(NSString *)typeSku complete:(void (^)(CMCMItemModel *resul, NSError *error))completionBlock;
- (void)getCoinWithPriceUSD:(NSInteger )idItem  complete:(void (^)(CMCMItemModel *resul, NSError *error))completionBlock;
- (NSArray *)getListCoin;
- (NSArray *)searchCoin:(NSString *)key;
- (void)getallListcoinSearchAndSave;
@end
