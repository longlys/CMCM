//
//  CMCMPortfolioViewController.m
//  ManagerCoin
//
//  Created by LongLy on 09/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMPortfolioViewController.h"
#import "CMCMPortfolioTableViewCell.h"
#import "CMCMCreateItemViewController.h"
#import "CMCMDatabaseManager.h"
#import "CMCMAPI.h"
#import "CMCMModelProtfolio.h"
@import GoogleMobileAds;
#import "DLPieChart.h"
#import "CMCMModelpieChart.h"
#define sHeightHeaderView 300

@interface CMCMPortfolioViewController ()<UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *arrayDataTableView;
@property (nonatomic) UIBarButtonItem *btnAdd;
@property (nonatomic) UIBarButtonItem *btnEdit;
@property (nonatomic) CMCMAPI *api;
@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic) DLPieChart *chartView;
@end

@implementation CMCMPortfolioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.api = [[CMCMAPI alloc] init];

    self.title = @"My Manager Coin";
    self.arrayDataTableView = [NSMutableArray new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view setBackgroundColor:sBackgroundColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.btnAdd = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(fmn_AddItem:)];
    self.navigationItem.rightBarButtonItem = self.btnAdd;
    self.navigationController.navigationBar.barTintColor = sBackgroundColor;
    self.navigationController.navigationBar.tintColor = sTinColor;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : sTitleColor}];
    [self reloadDatabase];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatabase) name:@"AddItemNew" object:nil];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    [self addBannerViewToView:self.bannerView];
    self.bannerView.adUnitID = idBanner;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;
    
    //chart
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

-(void)fmn_AddItem:(id)sender{
    CMCMCreateItemViewController *vc = [[CMCMCreateItemViewController alloc] init];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:vc];
    [nav.navigationBar setBackgroundColor:sBackgroundColor];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)reloadDatabase{
    weakify(self);
    [cmcmDBMgr allTracks:^(NSArray *arrayItems) {
        self_weak_.arrayDataTableView = arrayItems.mutableCopy;
        [self_weak_ requestWithDB:arrayItems complete:^(NSArray *arrTems, NSError *error) {
            self_weak_.arrayDataTableView = arrTems.mutableCopy;
            [self_weak_.tableView reloadData];
        }];
    }];
}
-(void)requestWithDB:(NSArray *)arrayItems complete:(void (^)(NSArray *arrTems, NSError *error))completionBlock{
    weakify(self);
    NSMutableArray *tmpArray = [NSMutableArray new];
    __block NSInteger Scount = 0;
    for (int i = 0; i < arrayItems.count; i++) {
        CMCMModelProtfolio *m = [arrayItems objectAtIndex:i];
        [self_weak_.api getCoinWithPriceUSD:[m.idItemPro integerValue]-1 complete:^(CMCMItemModel *resul, NSError *error) {
            CMCMModelProtfolio *model = [arrayItems objectAtIndex:i];
            if (error == nil) {
                model.priceNow = resul.quotesUSD.price;
                model.total = model.quanlity * model.priceNow;
            } else {
                model.total = model.quanlity * model.price;
            }
            [tmpArray addObject:model];
            Scount = Scount+1;
            if (Scount == arrayItems.count) {
                completionBlock(tmpArray, nil);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayDataTableView count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMCMPortfolioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableViewCell"];
    if (cell == nil) {
        cell = [CMCMPortfolioTableViewCell CMCM_newCellWithReuseIdentifier:@"ItemTableViewCell"];
    }
    
    [cell setDisplayForCell:[self.arrayDataTableView objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CMCMModelProtfolio *model = [self.arrayDataTableView objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        weakify(self);
        [cmcmDBMgr deleteTracks:@[model] completion:^(NSError *error) {
            [self_weak_.arrayDataTableView removeObject:model];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sHeightHeaderView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect f = [UIScreen mainScreen].bounds;
    f.size.height = sHeightHeaderView;
    UIView *view = [[UIView alloc] initWithFrame:f];
    [view setBackgroundColor:sLine];
    self.view.clipsToBounds = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

    NSMutableArray *arrayDataChart = [NSMutableArray new];
    self.chartView  = [[DLPieChart alloc] initWithFrame:f];
    for (int i = 0; i < [self.arrayDataTableView count]; i++) {
        CMCMModelProtfolio *model = [self.arrayDataTableView objectAtIndex:i];
        CMCMModelpieChart *modelChar = [[CMCMModelpieChart alloc] init];
        modelChar.symbol = model.symbol;
        modelChar.total = model.total;
        [arrayDataChart addObject:modelChar];
    }
    NSMutableArray *arrayDataChartView = [NSMutableArray new];
    for (int i = 0; i < arrayDataChart.count; i++) {
        CMCMModelpieChart *m = [arrayDataChart objectAtIndex:i];
        NSNumber *num = [NSNumber numberWithFloat:m.total];
        [arrayDataChartView addObject:num];
    }
    [self.chartView renderInLayer:self.chartView dataArray:arrayDataChartView];

    [view addSubview:self.chartView];
    self.chartView.clipsToBounds = YES;
    self.chartView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    return view;
}


@end
