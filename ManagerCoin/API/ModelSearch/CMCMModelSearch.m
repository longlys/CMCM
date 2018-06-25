//
//  CMCMModelSearch.m
//  ManagerCoin
//
//  Created by LongLy on 01/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMModelSearch.h"

@implementation CMCMModelSearch
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.idItem = dic[@"id"];
        self.title = dic[@"name"];
        self.idSearch = [dic[@"name"] lowercaseString];
        self.symbol = dic[@"symbol"];
        self.image = [NSString stringWithFormat:@"https://s2.coinmarketcap.com/static/img/coins/32x32/%@.png", dic[@"id"]];
    }
    return self;
}

@end
