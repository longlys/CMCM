//
//  CMCMModelProtfolio.h
//  ManagerCoin
//
//  Created by LongLy on 13/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum : NSUInteger {
//    TypeUSD,
//    TypeBTC,
//    TypeETH
//} PriceType;
@interface CMCMModelProtfolio : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *symbol;
@property (nonatomic) NSString *tradedate;
@property (nonatomic) NSString *artwork;
@property (nonatomic) NSString *idItemPro;
@property float quanlity;
@property float price;
@property float total;
@property float priceType;
@property float priceNow;

@property (nonatomic) NSString  *idCoin;

@end
