//
//  CMCMPointChart.m
//  ManagerCoin
//
//  Created by LongLy on 19/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMPointChart.h"

@implementation CMCMPointChart

- (instancetype)initWithDictionary:(NSArray *)point{
    self = [super init];
    if (self) {
        self.a = [point[0] longValue];
        self.b = [point[1] longValue];
    }
    return self;
}

@end
