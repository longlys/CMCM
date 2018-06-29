//
//  CMCMQuotesModel.h
//  ManagerCoin
//
//  Created by LongLy on 08/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCMQuotesModel : NSObject

@property (nonatomic)NSInteger market_cap;
@property (nonatomic)double percent_change_1h;
@property (nonatomic)double percent_change_24h;
@property (nonatomic)double percent_change_7d;
@property (nonatomic)double price;
@property (nonatomic)double volume_24h;

- (instancetype)initQuotesFollowUSDWithDictionary:(NSDictionary *)dic;
- (instancetype)initWidth:(NSString *)market_cap
                    width:(NSString *)percent_change_1h
                    width:(NSString *)percent_change_24h
                    width:(NSString *)percent_change_7d
                    width:(NSString *)price
                    width:(NSString *)volume_24h;


@end

