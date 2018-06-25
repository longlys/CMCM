//
//  CMCMPointChart.h
//  ManagerCoin
//
//  Created by LongLy on 19/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMCMPointChart : NSObject
@property(nonatomic) long a;
@property(nonatomic) long b;

- (instancetype)initWithDictionary:(NSArray *)point;

@end
