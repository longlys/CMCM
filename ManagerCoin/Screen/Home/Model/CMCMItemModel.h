//
//  CMCMItemModel.h
//  ManagerCoin
//
//  Created by LongLy on 08/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCMQuotesModel.h"

typedef enum : NSUInteger {
    TypeBTC,
    TypeUSD
} SKUType;

@interface CMCMItemModel : NSObject

@property (nonatomic)NSString *title;
@property (nonatomic)NSString *imageName;
@property (nonatomic)NSString *idItem;
@property (nonatomic)NSString *symbol;
@property (nonatomic)NSString *circulating_supply;
@property (nonatomic)NSString *max_supply;
@property (nonatomic)CMCMQuotesModel *quotesUSD;
@property (nonatomic)CMCMQuotesModel *quotesBTC;
@property (nonatomic)NSInteger rank;
@property (nonatomic)NSString *total_supply;
@property (nonatomic)NSString *website_slug;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

