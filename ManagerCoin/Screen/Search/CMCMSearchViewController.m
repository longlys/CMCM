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


@interface CMCMSearchViewController ()<CMCMSearchBarDelegate, CMCMSearchTableViewControllerDelegate>
@property (nonatomic) CMCMSearchBar *searchBar;
@property (nonatomic) CMCMAPI *api;
@property (nonatomic) CMCMModelSearch *sItem;
@property (nonatomic) CMCMSearchTableViewController *searchVC;
@end

@implementation CMCMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.api = [[CMCMAPI alloc] init];
    self.title = @"SEARCH";
    [self.view setBackgroundColor:sBackgroundColor];
    [self setupTableView];
    
    [self.api getallListcoinSearchAndSave];

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
    if (![sAdsManager getIspro]) {
        [sAdsManager showAdBanner];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
