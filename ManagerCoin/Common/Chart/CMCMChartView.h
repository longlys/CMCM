//
//  CMCMChartView.h
//  ManagerCoin
//
//  Created by LongLy on 25/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMCMChartData: NSObject

@property (nonatomic) NSArray<CMCMPointChart *> *data;
@property (nonatomic) void(^drawBlock)(CGContextRef context, CGPoint from, CGPoint to);


@end

@interface CMCMChartView : UIView

@property (nonatomic, strong) NSMutableArray<CMCMChartData *> *chartData;

- (CMCMPointChart *) getDataAtPoint:(CGPoint) point onChartData: (CMCMChartData *)chart;

@end
