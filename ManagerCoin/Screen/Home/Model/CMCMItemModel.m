//
//  CMCMItemModel.m
//  ManagerCoin
//
//  Created by LongLy on 08/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMItemModel.h"

@implementation CMCMItemModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.idItem = dic[@"id"];
        self.title = dic[@"name"];
        self.imageName = [NSString stringWithFormat:@"https://s2.coinmarketcap.com/static/img/coins/32x32/%@.png", dic[@"id"]];
        self.symbol = dic[@"symbol"];
        self.circulating_supply = dic[@"circulating_supply"];
        self.max_supply= dic[@"max_supply"];
        NSDictionary *temquotesUSD = [[NSDictionary alloc] initWithDictionary:dic[@"quotes"][@"USD"]];
        self.quotesUSD = [[CMCMQuotesModel alloc] initQuotesFollowUSDWithDictionary:temquotesUSD];
        NSDictionary *temquotesBTC = [[NSDictionary alloc] initWithDictionary:dic[@"quotes"][@"BTC"]];
        self.quotesBTC = [[CMCMQuotesModel alloc] initQuotesFollowUSDWithDictionary:temquotesBTC];
        self.rank= [dic[@"rank"] integerValue];
        self.total_supply= dic[@"total_supply"];
        self.website_slug= dic[@"website_slug"];

    }
    return self;
}


@end
