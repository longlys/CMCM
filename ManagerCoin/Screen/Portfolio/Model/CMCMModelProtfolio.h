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
@property NSInteger quanlity;
@property NSInteger price;
@property NSInteger total;
@property NSInteger priceType;
@property NSInteger idItemPro;
@property NSInteger priceNow;

@property (nonatomic) NSString  *idCoin;

@end
