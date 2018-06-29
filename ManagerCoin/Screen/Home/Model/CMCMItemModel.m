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

- (instancetype)initWithSearchDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.idItem = dic[@"id"];
        self.title = dic[@"name"];
        self.imageName = [NSString stringWithFormat:@"https://s2.coinmarketcap.com/static/img/coins/32x32/%@.png", dic[@"id"]];
        self.symbol = dic[@"symbol"];
        self.circulating_supply = dic[@"available_supply"];
        self.max_supply= dic[@"max_supply"];
        
//        self.quotesUSD = [[CMCMQuotesModel alloc] initWidth:dic[@"market_cap_usd"] width:dic[@"percent_change_1h"] width:dic[@"percent_change_24h"] width:dic[@"percent_change_7d"] width:dic[@"price_usd"] width:dic[@"24h_volume_usd"]];
//
//        self.quotesBTC = [[CMCMQuotesModel alloc] initWidth:dic[@"market_cap_usd"] width:dic[@"percent_change_1h"] width:dic[@"percent_change_24h"] width:dic[@"percent_change_7d"] width:dic[@"price_btc"] width:dic[@"24h_volume_usd"]];
        
        self.rank= [dic[@"rank"] integerValue];
        self.total_supply= dic[@"total_supply"];
        
        NSDictionary *temquotesUSD = [[NSDictionary alloc] initWithDictionary:dic];
        self.quotesUSD = [[CMCMQuotesModel alloc] initQuotesFollowUSDWithDictionary:temquotesUSD];
        NSDictionary *temquotesBTC = [[NSDictionary alloc] initWithDictionary:dic];
        self.quotesBTC = [[CMCMQuotesModel alloc] initQuotesFollowUSDWithDictionary:temquotesBTC];

    }
    return self;
}


@end
