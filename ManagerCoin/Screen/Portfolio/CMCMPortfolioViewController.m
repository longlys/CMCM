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

@interface CMCMPortfolioViewController ()<UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *arrayDataTableView;
@property (nonatomic) UIBarButtonItem *btnAdd;
@property (nonatomic) UIBarButtonItem *btnEdit;
@property (nonatomic) CMCMAPI *api;
@property(nonatomic, strong) GADBannerView *bannerView;

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
    [self_weak_.arrayDataTableView removeAllObjects];
    [cmcmDBMgr allTracks:^(NSArray *arrayItems) {
        [self_weak_.arrayDataTableView addObjectsFromArray:arrayItems];
        for (int i = 0; i < self_weak_.arrayDataTableView.count; i++) {
            CMCMModelProtfolio *model = [self_weak_.arrayDataTableView objectAtIndex:i];
            [self_weak_.api getCoinWithPriceUSD:model.idItemPro complete:^(CMCMItemModel *resul, NSError *error) {
                if (error == nil) {
                    model.priceNow = resul.quotesUSD.price;
                    if (i == self_weak_.arrayDataTableView.count-1) {
                        [self_weak_.tableView reloadData];
                    }
                }
            }];
        }
    }];
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
    model.idItemPro = indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        weakify(self);
        [cmcmDBMgr deleteTracks:@[model] completion:^(NSError *error) {
            [self_weak_.arrayDataTableView removeObject:model];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];

    }
}

@end
