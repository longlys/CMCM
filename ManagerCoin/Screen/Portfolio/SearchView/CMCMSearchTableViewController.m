//
//  CMCMSearchTableViewController.m
//  ManagerCoin
//
//  Created by LongLy on 01/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMSearchTableViewController.h"
#import "CMCMAPI.h"
#import "CMCMSearchTableViewCell.h"

#define cItemTableViewCell @"ItemTableViewCell"
@interface CMCMSearchTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) CMCMAPI *api;
@property (nonatomic) NSString *keyword;
@property (nonatomic) NSArray *arrayDataTableView;
@property (nonatomic) BOOL isShowOnViewController;
@end

@implementation CMCMSearchTableViewController

-(instancetype)initWithFrame:(CGRect )frame{
    self = [super init];
    if (self) {
        self.keyword = @"";
    }
    return self;
}

-(void)requestTableViewWithKeyword:(NSString *)key{
    self.keyword = key;
    [self searchWithKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.api = [[CMCMAPI alloc] init];
    self.arrayDataTableView = [NSArray new];
    [self searchWithKey];
    [self.view setBackgroundColor:sBackgroundColor];
}

-(void)searchWithKey{
    if ([self.keyword isEqualToString:@""] || self.keyword == nil) {
        self.arrayDataTableView = [self.api getListCoin];
    } else {
        self.arrayDataTableView = [self.api searchCoin:self.keyword];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)SML_showOnViewController:(UIViewController *)viewController withFrame:(CGRect)frm{
    self.view.frame = frm;
    self.view.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [viewController.view addSubview:self.view];
    [viewController addChildViewController:self];
    self.isShowOnViewController = YES;
}
-(void)SML_hideOnViewController{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    self.isShowOnViewController = NO;
}
- (BOOL)isShow {
    return self.isShowOnViewController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arrayDataTableView count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMCMSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cItemTableViewCell];
    if (cell == nil) {
        cell = [CMCMSearchTableViewCell CMCM_newCellWithReuseIdentifier:cItemTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CMCMModelSearch *model = [self.arrayDataTableView objectAtIndex:indexPath.row];
    [cell setDisplayForCell:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    CMCMModelSearch *model = self.arrayDataTableView[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(SML_suggestViewController:didSelectString:)]) {
        [self.delegate SML_suggestViewController:self
                                 didSelectString:model];
    }

}

@end
