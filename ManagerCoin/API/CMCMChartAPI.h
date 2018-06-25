//
//  CMCMChartAPI.h
//  ManagerCoin
//
//  Created by LongLy on 16/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCMModelChart.h"

typedef enum : NSUInteger {
    TypeMin,
    TypeHou,
    Type24h,
    Type1W,
    Type1M,
    Type3M,
    Type6M,
    Type1Y,
    TypeALL,
} ChartType;

@interface CMCMChartAPI : NSObject
- (void)loadDataChartWithStyle:(ChartType)type withCodeItem:(NSString *)nameItem complete:(void (^)(CMCMModelChart *resul, NSError *error))completionBlock;

@end
