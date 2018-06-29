//
//  CMCMSearchViewController.m
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMSearchViewController.h"
#import "CMCMSearchBar.h"
#import "Masonry.h"
#import "CMCMDetailItemViewController.h"
#import "CMCMModelSearch.h"
#import "CMCMSearchTableViewController.h"
#import "CMCMNavigationViewController.h"

@import GoogleMobileAds;
@interface CMCMSearchViewController ()<CMCMSearchBarDelegate, CMCMSearchTableViewControllerDelegate, GADBannerViewDelegate, GADInterstitialDelegate>
@property (nonatomic) CMCMSearchBar *searchBar;
@property (nonatomic) CMCMAPI *api;
@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic) CMCMModelSearch *sItem;
@property (nonatomic) CMCMSearchTableViewController *searchVC;
@end

@implementation CMCMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.api = [[CMCMAPI alloc] init];
    self.title = @"SEARCH";
    [self.view setBackgroundColor:sBackgroundColor];
//    self.searchBar = [[CMCMSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    self.searchBar.clipsToBounds = YES;
//    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
//    self.searchBar.delegate = self;
////    self.navigationController.navigationItem.titleView = self.searchBar;
//    [self.view addSubview:self.searchBar];
    [self setupTableView];
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    [self addBannerViewToView:self.bannerView];
    self.bannerView.adUnitID = idBanner;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;
    
    self.interstitial = [self createAndLoadInterstitial];
    [self.api getallListcoinSearchAndSave];

}
- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:idinterstitial];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
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

-(void)setupTableView {
    self.searchBar = [[CMCMSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.searchBar.clipsToBounds = YES;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(44);
    }];

    self.searchVC = [[CMCMSearchTableViewController alloc] init];
    self.searchVC.delegate = self;
    self.searchVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.searchVC requestTableViewWithKeyword:@""];

    [self.view addSubview:self.searchVC.view];
    [self addChildViewController:self.searchVC];
    [self.searchVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Search
- (void)searchBarSearchButtonClicked:(CMCMSearchBar *)searchBar {
    [self.searchVC requestTableViewWithKeyword:searchBar.text];
}

- (void)searchBar:(CMCMSearchBar *)searchBar textDidChange:(NSString *)searchText{
   [self.searchVC requestTableViewWithKeyword:searchBar.text];
}
- (void)SML_suggestViewController:(CMCMSearchTableViewController *)sender didSelectString:(CMCMModelSearch *)modelSearch{
    CMCMDetailItemViewController *vc = [[CMCMDetailItemViewController alloc] initWithSearchCodeItem:modelSearch];
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
//    CMCMNavigationViewController
    [self.navigationController pushViewController:vc animated:YES];
}


//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    CGRect f = [UIScreen mainScreen].bounds;
//    f.size.height = 60;
//    UIView *view = [[UIView alloc] initWithFrame:f];
//    [view setBackgroundColor:sBackgroundColor];
//
//    float w = view.frame.size.width / 8;
//
//    CGRect f1 = CGRectMake(0, 0, w*5, 60);
//
//    UILabel *lbName = [[UILabel alloc] initWithFrame:f1];
//    lbName.font = [UIFont boldSystemFontOfSize:15.f];
//    lbName.textColor = sTitleColor;
//    lbName.text = @"Coin Name (Code)";
//    [view addSubview:lbName];
//
//    CGRect f2 = CGRectMake(0, 0, w*2, 60);
//    f2.origin.x = f1.size.width + f1.origin.x;
//    UILabel *lbPrice = [[UILabel alloc] initWithFrame:f2];
//    lbPrice.font = [UIFont boldSystemFontOfSize:15.f];
//    lbPrice.text = @"Price";
//    lbPrice.textColor = sTitleColor;
//    lbPrice.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:lbPrice];
//
//    CGRect f3 = CGRectMake(0, 0, w, 60);
//    f3.origin.x = f2.size.width + f2.origin.x;
//    UILabel *lbPercent24h = [[UILabel alloc] initWithFrame:f3];
//    lbPercent24h.font = [UIFont boldSystemFontOfSize:15.f];
//    lbPercent24h.text = @"24h";
//    lbPercent24h.textColor = sTitleColor;
//    lbPercent24h.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:lbPercent24h];
//
//    return view;
//}


@end
