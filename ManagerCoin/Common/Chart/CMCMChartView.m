//
//  CMCMChartView.m
//  ManagerCoin
//
//  Created by LongLy on 25/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMChartView.h"


@implementation CMCMChartData

@end

@implementation CMCMChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.chartData = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.chartData = [NSMutableArray new];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    //CGContextRef
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i< self.chartData.count; i++) {
        CMCMChartData *chartData = self.chartData[i];
        if (chartData.data.count==0) continue;
        double maxY = 0;
        for (int j = 0; j < chartData.data.count-1; j++) {
            if (maxY<chartData.data[j].b){
                maxY = chartData.data[j].b;
            }
        }
        
        maxY = self.bounds.size.height/maxY;
        float stepX = self.bounds.size.width/chartData.data.count;
        for (int j = 0; j < chartData.data.count-1; j++) {
            chartData.drawBlock(context, CGPointMake(stepX*j, self.bounds.size.height - maxY*chartData.data[j].b) , CGPointMake(stepX*(j+1), self.bounds.size.height - maxY*chartData.data[j+1].b));
        }
    }
}

- (CMCMPointChart *) getDataAtPoint:(CGPoint) point onChartData: (CMCMChartData *)chart{
    return nil;
}


@end
