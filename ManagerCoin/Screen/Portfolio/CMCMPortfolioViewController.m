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
#import "DatabaseManager.h"
#import "CMCMAPI.h"
#import "CMCMModelProtfolio.h"
@import GoogleMobileAds;

@interface CMCMPortfolioViewController ()<UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *arrayDataTableView;
@property (nonatomic) UIBarButtonItem *btnAdd;
@property (nonatomic) UIBarButtonItem *btnEdit;
@property (nonatomic) DatabaseManager *dbManager;
@property (nonatomic) CMCMAPI *api;
@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation CMCMPortfolioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.api = [[CMCMAPI alloc] init];

    self.title = @"My Manager Coin";
//    self.dbManager = [[DatabaseManager alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view setBackgroundColor:sBackgroundColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];

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

-(void)fmn_AddItem:(id)sender{
    CMCMCreateItemViewController *vc = [[CMCMCreateItemViewController alloc] init];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:vc];
    [nav.navigationBar setBackgroundColor:sBackgroundColor];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)reloadDatabase{
    self.arrayDataTableView = [NSMutableArray new];
    self.arrayDataTableView = [[DatabaseManager shareInstance]listTracksWithType];
    weakify(self);
//    __block int i = 0;
    for (CMCMModelProtfolio *model in self.arrayDataTableView) {
        [self.api getCoinWithPriceUSD:model.idItemPro complete:^(CMCMItemModel *resul, NSError *error) {
//            i++;
            if (error == nil) {
                model.priceNow = resul.quotesUSD.price;
//                if (i == self_weak_.arrayDataTableView.count) {
                    [self_weak_.tableView reloadData];
//                }
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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.001f;
//}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CGRect f = [UIScreen mainScreen].bounds;
//    f.size.height = 60;
//    UIView *view = [[UIView alloc] initWithFrame:f];
//    [view setBackgroundColor:[UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:1.0f]];
//    [view setBackgroundColor:sBackgroundColor];
//
//    float w = view.frame.size.width / 4;
//
//    CGRect f1 = CGRectMake(0, 0, w*2, 60);
//
//    UILabel *lbName = [[UILabel alloc] initWithFrame:f1];
//    lbName.font = [UIFont boldSystemFontOfSize:15.f];
//    lbName.textColor = sTitleColor;
//    lbName.text = @"Coin Name (Code)";
//    [view addSubview:lbName];
//
//    CGRect f2 = CGRectMake(0, 0, w, 60);
//    f2.origin.x = f1.size.width + f1.origin.x;
//    UILabel *lbPrice = [[UILabel alloc] initWithFrame:f2];
//    lbPrice.font = [UIFont boldSystemFontOfSize:15.f];
//    lbPrice.textColor = sTitleColor;
//    lbPrice.text = @"Total (USD)";
//    lbPrice.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:lbPrice];
//
//    CGRect f3 = CGRectMake(0, 0, w, 60);
//    f3.origin.x = f2.size.width + f2.origin.x;
//    UILabel *lbPercent24h = [[UILabel alloc] initWithFrame:f3];
//    lbPercent24h.font = [UIFont boldSystemFontOfSize:15.f];
//    lbPercent24h.textColor = sTitleColor;
//    lbPercent24h.text = @"24h";
//    lbPercent24h.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:lbPercent24h];
//
//    return view;
//}

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
        [[DatabaseManager shareInstance] deleteTrack:self.arrayDataTableView[indexPath.row]];
        [self.arrayDataTableView removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
