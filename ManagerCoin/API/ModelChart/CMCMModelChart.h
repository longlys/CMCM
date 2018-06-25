//
//  CMCMModelChart.h
//  ManagerCoin
//
//  Created by LongLy on 16/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCMPointChart.h"

@interface CMCMModelChart : NSObject

@property(nonatomic) NSArray<CMCMPointChart *> *market_cap_by_available_supply;
@property(nonatomic) NSArray<CMCMPointChart *> *price_btc;
@property(nonatomic) NSArray<CMCMPointChart *> *price_usd;
@property(nonatomic) NSArray<CMCMPointChart *> *volume_usd;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
