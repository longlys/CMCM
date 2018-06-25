//
//  CMCMModelChart.m
//  ManagerCoin
//
//  Created by LongLy on 16/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMModelChart.h"

@implementation CMCMModelChart

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.market_cap_by_available_supply = [self covertPoint:dic[@"market_cap_by_available_supply"]];
        self.price_btc = [self covertPoint:dic[@"price_btc"]];
        self.price_usd = [self covertPoint:dic[@"price_usd"]];
        self.volume_usd = [self covertPoint:dic[@"volume_usd"]];
    }
    return self;
}
-(NSArray *)covertPoint:(NSArray *)tmpArray{
    NSMutableArray *resulArraymarket = [NSMutableArray new];
    for (CMCMPointChart *item in tmpArray) {
        [resulArraymarket addObject:item];
    }
    return resulArraymarket;
}

@end
