//
//  CMCMHomeViewController.m
//  ManagerCoin
//
//  Created by LongLy on 04/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMHomeViewController.h"
#import "CMCMAPI.h"
#import "CMCMHomeTableViewCell.h"
#import "SVPullToRefresh.h"
#import "CMCMDetailItemViewController.h"
@import GoogleMobileAds;

#define cItemTableViewCell @"ItemTableViewCell"

@interface CMCMHomeViewController ()<UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, GADInterstitialDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *arrayDataTableView;
@property (nonatomic) NSArray *arrayFavorites;
@property (nonatomic) CMCMAPI *api;
@property (nonatomic) BOOL isAdd;
@property (nonatomic) CGRect frameView;
@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation CMCMHomeViewController

-(instancetype)initWithFrame:(CGRect )f{
    self = [super init];
    if (self) {
        self.frameView = f;
        self.view.frame = f;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayFavorites = [[NSArray alloc] initWithArray:[self getFavorites]];
    self.api = [[CMCMAPI alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view setBackgroundColor:sBackgroundColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.arrayDataTableView = [NSArray new];
    
    weakify(self);
    [self.tableView.infiniteScrollingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
//    [self.tableView addPullToRefreshWithActionHandler:^{
        [self_weak_ loadNewData];
//    }];
    [self loadteamp];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self_weak_ loadNewData];
    }];
    [self.tableView triggerPullToRefresh];
    
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    [self addBannerViewToView:self.bannerView];
    self.bannerView.adUnitID = idBanner;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;

    self.interstitial = [self createAndLoadInterstitial];

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

-(void)loadteamp{
    if([self.api getListCoin].count > 0){
        return;
    } else {
        [self.api getallListcoinSearchAndSave];
    }
}
-(void)loadNewData{
    weakify(self);
    NSInteger numberStart = 0;
    if (self.arrayDataTableView.count > 0) {
        numberStart = self.arrayDataTableView.count;
    }
    [self.api loadmoreListCoinWithStart:numberStart complete:^(NSArray *resul, NSError *error) {
        [self_weak_.tableView.pullToRefreshView stopAnimating];
        [self_weak_.tableView.infiniteScrollingView stopAnimating];
        if (error == nil) {
            if (numberStart == 0) {
                self_weak_.arrayDataTableView = resul;
            } else {
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self_weak_.arrayDataTableView];
                [arr addObjectsFromArray:resul];
                self_weak_.arrayDataTableView = arr;
            }
            [self_weak_.tableView reloadData];
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
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect f = [UIScreen mainScreen].bounds;
    f.size.height = 60;
    UIView *view = [[UIView alloc] initWithFrame:f];
    [view setBackgroundColor:sBackgroundColor2];

    float w = view.frame.size.width / 8;
    
    CGRect f1 = CGRectMake(0, 0, w*5, 60);
    
    UILabel *lbName = [[UILabel alloc] initWithFrame:f1];
    lbName.font = [UIFont boldSystemFontOfSize:15.f];
    lbName.textColor = sTitleColor;
    lbName.text = @"Coin Name (Code)";
    [view addSubview:lbName];
    
    CGRect f2 = CGRectMake(0, 0, w*2, 60);
    f2.origin.x = f1.size.width + f1.origin.x;
    UILabel *lbPrice = [[UILabel alloc] initWithFrame:f2];
    lbPrice.font = [UIFont boldSystemFontOfSize:15.f];
    lbPrice.text = @"Price";
    lbPrice.textColor = sTitleColor;
    lbPrice.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lbPrice];
    
    CGRect f3 = CGRectMake(0, 0, w, 60);
    f3.origin.x = f2.size.width + f2.origin.x;
    UILabel *lbPercent24h = [[UILabel alloc] initWithFrame:f3];
    lbPercent24h.font = [UIFont boldSystemFontOfSize:15.f];
    lbPercent24h.text = @"24h";
    lbPercent24h.textColor = sTitleColor;
    lbPercent24h.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lbPercent24h];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CMCMHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cItemTableViewCell];
    if (cell == nil) {
        cell = [CMCMHomeTableViewCell CMCM_newCellWithReuseIdentifier:cItemTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    CMCMItemModel *item = [self.arrayDataTableView objectAtIndex:indexPath.row];
    [cell setDisplayForCell:item];
    [self changeValueFavorites:item];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    CMCMItemModel *item = self.arrayDataTableView[indexPath.row];
    CMCMDetailItemViewController *vc = [[CMCMDetailItemViewController alloc] initWithCodeItem:item];
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MSTTrackTableViewCellDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
        CMCMItemModel *item = self.arrayDataTableView[indexPath.row];
        NSString *titleAction = [self changeValueFavorites:item];

    CGFloat tableViewCellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    UIImage *image = [UIImage imageNamed:@"star"];
    if ([titleAction isEqualToString:@"UnFollow"]) {
        image = [UIImage imageNamed:@"star-selected"];
    }
    
    CGFloat fittingMultiplier = 0.4f;
    CGFloat iOS8PlusFontSize = 18.0f;
    CGFloat underImageFontSize = 13.0f;
    CGFloat marginHorizontaliOS8Plus = 15.0f;
    CGFloat marginVerticalBetweenTextAndImage = 3.0f;
    
    float titleMultiplier = fittingMultiplier;
    
    NSString *titleSpaceString= [@"" stringByPaddingToLength:[titleAction length]*titleMultiplier withString:@"\u3000" startingAtIndex:0];
    
    UITableViewRowAction *rowAction= [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:titleSpaceString handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self addItemToFavorites:item];
    }];
    
    CGSize frameGuess=CGSizeMake((marginHorizontaliOS8Plus*2)+[titleSpaceString boundingRectWithSize:CGSizeMake(MAXFLOAT, tableViewCellHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:iOS8PlusFontSize] } context:nil].size.width, tableViewCellHeight);
    
    CGSize tripleFrame=CGSizeMake(frameGuess.width*3.0f, frameGuess.height*3.0f);
    
    UIGraphicsBeginImageContextWithOptions(tripleFrame, YES, [[UIScreen mainScreen] scale]);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    [sTinColor set];
    CGContextFillRect(context, CGRectMake(0, 0, tripleFrame.width, tripleFrame.height));
    
    CGSize drawnTextSize=[titleAction boundingRectWithSize:CGSizeMake(MAXFLOAT, tableViewCellHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:underImageFontSize] } context:nil].size;
    
    [image drawAtPoint:CGPointMake((frameGuess.width/2.0f)-([image size].width/2.0f), (frameGuess.height/2.0f)-[image size].height-(marginVerticalBetweenTextAndImage/2.0f)+2.0f)];
    
    [titleAction drawInRect:CGRectMake(((frameGuess.width/2.0f)-(drawnTextSize.width/2.0f))*([[UIApplication sharedApplication] userInterfaceLayoutDirection]==UIUserInterfaceLayoutDirectionRightToLeft ? -1 : 1), (frameGuess.height/2.0f)+(marginVerticalBetweenTextAndImage/2.0f)+2.0f, frameGuess.width, frameGuess.height) withAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:underImageFontSize], NSForegroundColorAttributeName: [UIColor whiteColor] }];
    
    [rowAction setBackgroundColor:[UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()]];
    UIGraphicsEndImageContext();
    
    return @[rowAction];
}

- (NSString *)changeValueFavorites:(CMCMItemModel *)model{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *aFavorites = [NSMutableArray new];
    if([userDefaults arrayForKey:@"Favorites"] != nil) {
        [aFavorites addObjectsFromArray:[userDefaults arrayForKey:@"Favorites"]];
    }
    if (aFavorites.count > 0) {
        if (![aFavorites containsObject:model.symbol]) {
            return @"Follow";
        } else {
            return @"UnFollow";
        }
    } else {
        if (![aFavorites containsObject:model.symbol]) {
            return @"Follow";
        } else {
            return @"UnFollow";
        }
    }
}

-(void)addItemToFavorites:(CMCMItemModel *)model{
    self.isAdd = NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *aFavorites = [NSMutableArray new];

    if([userDefaults arrayForKey:@"Favorites"] != nil) {
        [aFavorites addObjectsFromArray:[userDefaults arrayForKey:@"Favorites"]];
    }
    
    if (aFavorites.count > 0) {
        if (![aFavorites containsObject:model.symbol]) {
            [aFavorites addObject:model.symbol];
            self.isAdd = YES;
        } else {
            [aFavorites removeObject:model.symbol];
            self.isAdd = NO;
        }
    } else {
        if (![aFavorites containsObject:model.symbol]) {
            [aFavorites addObject:model.symbol];
            self.isAdd = YES;
        } else {
            [aFavorites removeObject:model.symbol];
            self.isAdd = NO;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEFAVORITES" object:nil];
    
    [userDefaults setObject:aFavorites forKey:@"Favorites"];
    [userDefaults synchronize];
}
-(NSArray *)getFavorites{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults arrayForKey:@"Favorites"];
}


@end
