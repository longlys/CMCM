//
//  CMCMDetailItemViewController.m
//  ManagerCoin
//
//  Created by LongLy on 16/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMDetailItemViewController.h"
#import "CMCMModelChart.h"
#import "CMCMChartAPI.h"
#import "CMCMPointChart.h"
#import "CMCMDetailTableViewCell.h"
#import "CMCMAPI.h"
#import "CMCMChartView.h"
@import GoogleMobileAds;

@interface CMCMDetailItemViewController ()<UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate>
@property(nonatomic) CMCMItemModel *currentItem;
@property (nonatomic) CMCMChartAPI *apiChart;
@property (nonatomic) CMCMModelChart *modelChart;
@property (nonatomic) CMCMAPI *api;
@property(nonatomic) NSArray *arrayChart;
@property (nonatomic) UIControl *viewChart;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *arrayTableView;
@property (nonatomic) float oldX, oldY;
@property (nonatomic) BOOL dragging;
@property(nonatomic, strong) GADBannerView *bannerView;

@end
#define cItemTableViewCell @"ItemTableViewCell"
#define sHeightHeaderView 200
#define sHeightCharView 150

@implementation CMCMDetailItemViewController

- (UIImage *)imageFromColor:(UIColor *)color withRect:(CGRect )rect{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(instancetype)initWithCodeItem:(CMCMItemModel *)item{
    self = [super init];
    if (self) {
        self.currentItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.arrayChart = [NSArray new];
    self.apiChart = [[CMCMChartAPI alloc] init];
    self.modelChart = [[CMCMModelChart alloc] init];
    [self.view setBackgroundColor:sBackgroundColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.title = self.currentItem.title;
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loaddayaasdasd];
    self.api = [[CMCMAPI alloc] init];
    [self loadDataWithType];
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    [self addBannerViewToView:self.bannerView];
    self.bannerView.adUnitID = @"ca-app-pub-2427874870616509/4322484086";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;

}
- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loaddayaasdasd{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CoinDetail" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    self.arrayTableView = array.copy;
}
-(void)loadDataWithType{
    weakify(self);
    [self.api getDetailCoinWithPriceBTC:self.currentItem.rank withCoinCover:@"BTC" complete:^(CMCMItemModel *resul, NSError *error) {
        if (error == nil) {
            self_weak_.currentItem = resul;
            [self_weak_.tableView reloadData];
        }
    }];
}

-(void)getdatabaseChart{
    [self.apiChart loadDataChartWithStyle:TypeALL withCodeItem:self.currentItem.title complete:^(CMCMModelChart *resul, NSError *error) {
        self.modelChart = resul;
        CMCMChartView *subChartView = [[CMCMChartView alloc] initWithFrame:self.viewChart.bounds];
        {
            CMCMChartData *chartData = [CMCMChartData new];
            NSMutableArray *points = [NSMutableArray new];
            for (NSArray * arr in self.modelChart.market_cap_by_available_supply) {
                CMCMPointChart *pointChart = [CMCMPointChart new];
                pointChart.a = [arr[0] longValue];
                pointChart.b = [arr[1] longValue];
                [points addObject:pointChart];
            }
            chartData.data = points;
            [chartData setDrawBlock:^(CGContextRef context, CGPoint from, CGPoint to) {
                CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
                CGContextSetLineWidth(context, 1.0);
                CGContextMoveToPoint(context, from.x, from.y);
                CGContextAddLineToPoint(context, to.x, to.y);
                CGContextDrawPath(context, kCGPathStroke);
            }];
            [subChartView.chartData addObject:chartData];
            
            [subChartView setNeedsDisplay];
        }

        [subChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.viewChart addSubview:subChartView];
    }];
}

-(void)TriangularPinkView:(NSArray *)arrayLine{
    CGRect f = self.viewChart.frame;
    CGFloat w = f.size.width/[arrayLine count];
    CMCMPointChart *p = [[CMCMPointChart alloc] init];
    NSMutableArray<CMCMPointChart *> *arrPoint = [NSMutableArray new];
    for (NSArray *item in arrayLine) {
        CMCMPointChart *currentP = [[CMCMPointChart alloc] initWithDictionary:item];
        [arrPoint addObject:currentP];
        if (p.b < currentP.b) {
            p = currentP;
        }
    }
    float radio = f.size.height/p.b;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i< arrPoint.count; i++) {
        CMCMPointChart *point = arrPoint[i];
        float x = self.viewChart.frame.size.height;
        float y = self.viewChart.frame.size.height;
        float h = -point.b*radio;
        UIImage *img = [UIImage new];
        [img drawInRect:CGRectMake(w*i, y, w, h)];

        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.image = img;
        
        imgView.frame = CGRectMake(w*i, y, w, h);
        [imgView setBackgroundColor:[UIColor colorWithRed:3/255.f green:183/255.f blue:255/255.f alpha:1.0f]];

        [self.viewChart addSubview:imgView];
        // line
        if(i==0){
            [path moveToPoint:CGPointMake(0, h/2)];
        } else {
            [path addLineToPoint:CGPointMake(w*i, h/2)];
        }
    }
    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = [path CGPath];
//    shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
//    shapeLayer.lineWidth = 1.0f;
//    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
//    [self.viewChart.layer addSublayer:shapeLayer];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context, 10.0, 10.0);
    CGContextAddLineToPoint(context, 100.0, 100.0);
    CGContextDrawPath(context, kCGPathStroke);
}
#pragma Toutch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(self.viewChart.frame, touchLocation)) {
        
        self.dragging = YES;
        self.oldX = touchLocation.x;
        self.oldY = touchLocation.y;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (self.dragging) {
        CGRect frame = self.viewChart.frame;
        frame.origin.x = self.viewChart.frame.origin.x + touchLocation.x - self.oldX;
        frame.origin.y =  self.viewChart.frame.origin.y + touchLocation.y - self.oldY;
        NSLog(@"X: %f -  Y: %f", frame.origin.x, frame.origin.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.dragging = NO;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayTableView count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sHeightHeaderView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect f = [UIScreen mainScreen].bounds;
    f.size.height = sHeightHeaderView;
    UIView *view = [[UIView alloc] initWithFrame:f];
    CGRect fChar = [UIScreen mainScreen].bounds;
    fChar.size.height = sHeightCharView;
    fChar.origin.y = (sHeightHeaderView-sHeightCharView)/2;
    self.viewChart = [[UIView alloc] initWithFrame:fChar];
    [self getdatabaseChart];
    [self.viewChart setBackgroundColor:sBackgroundColor];
    [view setBackgroundColor:sBackgroundColor];
    [view addSubview:self.viewChart];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMCMDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cItemTableViewCell];
    if (cell == nil) {
        cell = [CMCMDetailTableViewCell CMCM_newCellWithReuseIdentifier:cItemTableViewCell];
    }
    NSString *title = [self.arrayTableView objectAtIndex:indexPath.row];
    [cell setDisplayForCell:self.currentItem withTitle:title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

}

@end
