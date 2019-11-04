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

@interface CMCMDetailItemViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) CMCMItemModel *currentItem;
@property (nonatomic) CMCMChartAPI *apiChart;
@property (nonatomic) CMCMModelChart *modelChart;
@property (nonatomic) CMCMModelSearch *currentItemS;
@property (nonatomic) CMCMAPI *api;
@property (nonatomic) BOOL isItemS;
@property(nonatomic) NSArray *arrayChart;
@property (nonatomic) UIControl *viewChart;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *arrKK;
@property (nonatomic) NSArray *arrayTableView;
@property (nonatomic) float oldX, oldY;
@property (nonatomic) BOOL dragging;
@property(nonatomic) UILabel *lbLastValue;
@property (nonatomic) NSMutableArray *arrButton;
@end
#define cItemTableViewCell @"ItemTableViewCell"
#define sHeightHeaderView 300
#define sHeightControl 50
#define sHeightCharView 200

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

-(instancetype)initWithSearchCodeItem:(CMCMModelSearch *)item{
    self = [super init];
    if (self) {
        self.currentItemS = item;
        self.isItemS = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrKK = [NSMutableArray new];
    self.arrButton = [NSMutableArray new];
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.arrayChart = [NSArray new];
    self.apiChart = [[CMCMChartAPI alloc] init];
    self.modelChart = [[CMCMModelChart alloc] init];
    [self.view setBackgroundColor:sBackgroundColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    if (self.isItemS) {
        self.title = self.currentItemS.title;
    } else {
        self.title = self.currentItem.title;
    }
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loaddayaasdasd];
    self.api = [[CMCMAPI alloc] init];
    [self loadDataWithType];
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
    NSInteger rank = self.currentItem.rank;
    if (self.isItemS) {
        rank = [self.currentItemS.idItem integerValue];
    }
    [self.api getDetailCoinWithPriceBTC:rank withCoinCover:@"BTC" complete:^(CMCMItemModel *resul, NSError *error) {
        if (error == nil) {
            self_weak_.currentItem = resul;
            [self_weak_.tableView reloadData];
        }
    }];
}

-(void)getdatabaseChartWidthType:(ChartType )type{
    [self.apiChart loadDataChartWithStyle:type withCodeItem:self.currentItem.title complete:^(CMCMModelChart *resul, NSError *error) {
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
                CGContextSetStrokeColorWithColor(context, [sTinColor CGColor]);
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
        [subChartView setBackgroundColor:sBackgroundColor];
        [self.viewChart setBackgroundColor:[UIColor yellowColor]];
        
        float max = 0;

        for (NSArray * arr in self.modelChart.price_usd) {
            float tmp = [arr.lastObject floatValue];
            if (tmp > max) {
                max = tmp;
            }
        }
        CGRect fk = self.viewChart.bounds;
        fk.size.height = 15;
        fk.size.width = 100;
        float yy = self.viewChart.bounds.size.height/5;
        for (int j = 0; j < 5; j++) {
            fk.origin.y = self.viewChart.bounds.size.height - yy*(j+1);
            UILabel *lb = [[UILabel alloc] initWithFrame:fk];
            float xx = max/5*(j+1);
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@"###,###,###"];
            
            NSInteger total = [self.currentItem.total_supply integerValue];
            NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:xx]];
            lb.text = [NSString stringWithFormat:@"$ %@",formattedNumberString];

//            lb.text = [NSString stringWithFormat:@"$ %.0f",xx];
            [lb setTextColor:sTitleColor];
            [self.viewChart addSubview:lb];
        }
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
    fChar.origin.y = sHeightHeaderView - sHeightCharView - sHeightControl;
    self.viewChart = [[UIView alloc] initWithFrame:fChar];
    [self getdatabaseChartWidthType:TypeALL];
    [self.viewChart setBackgroundColor:sBackgroundColor];
    [view setBackgroundColor:sBackgroundColor2];
    [view addSubview:self.viewChart];
    CGRect fC = [UIScreen mainScreen].bounds;
    fC.size.height = sHeightControl;
    fC.origin.y = sHeightCharView+sHeightControl;
    UIView *viewControl = [[UIView alloc] initWithFrame:fC];
    [viewControl setBackgroundColor:[UIColor clearColor]];
    CMCMQuotesModel *q = self.currentItem.quotesUSD;
    NSArray *arr = [[NSArray alloc] initWithObjects:@"H", @"24h",@"1W",@"1M",@"3M",@"6M",@"1Y",@"All", nil];
    [view addSubview:viewControl];
    float w = [UIScreen mainScreen].bounds.size.width/8;
    float h = viewControl.bounds.size.height*2/3;
    CGRect fBtn = viewControl.bounds;
    fBtn.size.width = w;
    fBtn.size.height = h;
    fBtn.origin.y = (viewControl.bounds.size.height - h)/2;
    for (int i = 0; i < arr.count; i++) {
        fBtn.origin.x = w*i;
        UIButton *btn = [[UIButton alloc] initWithFrame:fBtn];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnTouchChangeChart:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor clearColor]];
        if (i == arr.count-1) {
            [btn setBackgroundColor:sTinColor];
        }
        btn.layer.borderColor = sTinColor.CGColor;
        btn.layer.borderWidth = 0.5f;
        btn.layer.cornerRadius = 10;
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [self.arrButton addObject:btn];
        [viewControl addSubview:btn];
    }
    
    CGRect flb = [UIScreen mainScreen].bounds;
    flb.size.height = sHeightControl;

    self.lbLastValue = [[UILabel alloc] initWithFrame:flb];
    [self.lbLastValue setTextColor:sTitleColor];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,###,###,###"];
    CMCMQuotesModel *modelPrice = self.currentItem.quotesUSD;
    
    NSNumber *num = @(modelPrice.market_cap);
    NSString *numberAsString = [numberFormatter stringFromNumber:num];
    self.lbLastValue.text = [NSString stringWithFormat:@"$%@",numberAsString];

    self.lbLastValue.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.lbLastValue];
    
    return view;
}

-(void)updateUIButton:(NSInteger )index{
    for (UIButton *btn in self.arrButton) {
        [btn setBackgroundColor:[UIColor clearColor]];
        if (btn.tag == index) {
            [btn setBackgroundColor:sTinColor];
        }
    }
}

-(void)btnTouchChangeChart:(UIButton *)sender{
    [self updateUIButton:sender.tag];
    switch (sender.tag) {
        case 0:
            [self getdatabaseChartWidthType:TypeHou];
            break;
        case 1:
            [self getdatabaseChartWidthType:Type24h];
            break;
        case 2:
            [self getdatabaseChartWidthType:Type1W];
            break;
        case 3:
            [self getdatabaseChartWidthType:Type1M];
            break;
        case 4:
            [self getdatabaseChartWidthType:Type3M];
            break;
        case 5:
            [self getdatabaseChartWidthType:Type6M];
            break;
        case 6:
            [self getdatabaseChartWidthType:Type1Y];
            break;
        case 7:
            [self getdatabaseChartWidthType:TypeALL];
            break;
        default:
            break;
    }
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
