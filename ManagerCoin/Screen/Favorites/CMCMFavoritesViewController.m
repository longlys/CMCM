//
//  CMCMFavoritesViewController.m
//  ManagerCoin
//
//  Created by LongLy on 09/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMFavoritesViewController.h"
#import "CMCMAPI.h"
#import "CMCMHomeTableViewCell.h"
#import "CMCMDetailItemViewController.h"

#define cItemTableViewCell @"ItemTableViewCell"

@interface CMCMFavoritesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *arrayDataTableView;
@property (nonatomic) NSArray *arrayFavorites;
@property (nonatomic) CMCMAPI *api;

@end

@implementation CMCMFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Favorites";
    self.arrayFavorites = [NSArray new];
    [self.view setBackgroundColor:[UIColor orangeColor]];
    self.api = [[CMCMAPI alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view setBackgroundColor:sBackgroundColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundColor:sBackgroundColor];
    self.arrayDataTableView = [NSArray new];
    [self updateFavorites];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFavorites) name:@"UPDATEFAVORITES" object:nil];
    
}


-(NSArray *)getArrayFavorites{
    NSArray *arr = [NSArray new];
    if([[NSUserDefaults standardUserDefaults] arrayForKey:@"Favorites"] != nil) {
        arr = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Favorites"];
    }
    return arr;
}
-(void)updateFavorites{
    weakify(self);
    [self_weak_ getDataApiWithIsLoadmore:NO complete:^(NSArray *resul) {
        NSMutableArray *arraycompre = [NSMutableArray new];
        for (CMCMItemModel *item in resul) {
            if ([[self_weak_ getArrayFavorites] containsObject:item.symbol]) {
                [arraycompre addObject:item];
            }
        }
        self_weak_.arrayDataTableView = arraycompre;
        [self_weak_.tableView reloadData];
    }];
}

-(void)getDataApiWithIsLoadmore:(BOOL)isLoadmore complete:(void (^)(NSArray *resul))completionBlock{
    NSInteger numberStart = 0;
    if (isLoadmore) {
        numberStart = self.arrayDataTableView.count;
    }
    [self.api loadmoreListCoinWithStart:numberStart complete:^(NSArray *resul, NSError *error) {
        if (error == nil) {
            if (completionBlock) {
                completionBlock(resul);
            }
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
    cell.layer.zPosition = -1;
    [cell setDisplayForCell:[self.arrayDataTableView objectAtIndex:indexPath.row]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    CMCMItemModel *item = self.arrayDataTableView[indexPath.row];
    CMCMDetailItemViewController *vc = [[CMCMDetailItemViewController alloc] initWithCodeItem:item];
    if (![sAdsManager getIspro]) {
        [sAdsManager showAdBanner];
    }
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    CMCMItemModel *item = self.arrayDataTableView[indexPath.row];
    NSString *titleAction = @"UnFollow";
    
    CGFloat tableViewCellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    UIImage *image = [UIImage imageNamed:@"star-selected"];
    
    CGFloat fittingMultiplier = 0.4f;
    CGFloat iOS8PlusFontSize = 18.0f;
    CGFloat underImageFontSize = 13.0f;
    CGFloat marginHorizontaliOS8Plus = 15.0f;
    CGFloat marginVerticalBetweenTextAndImage = 3.0f;
    
    float titleMultiplier = fittingMultiplier;
    
    NSString *titleSpaceString= [@"" stringByPaddingToLength:[titleAction length]*titleMultiplier withString:@"\u3000" startingAtIndex:0];
    
    UITableViewRowAction *rowAction= [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:titleSpaceString handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self removeItemToFavorites:item];
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

#pragma mark - MSTTrackTableViewCellDelegate

-(void)removeItemToFavorites:(CMCMItemModel *)model{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *aFavorites = [NSMutableArray new];
    
    if([userDefaults arrayForKey:@"Favorites"] != nil) {
        [aFavorites addObjectsFromArray:[userDefaults arrayForKey:@"Favorites"]];
    }
    
    if (aFavorites.count > 0) {
        if ([aFavorites containsObject:model.symbol]) {
            [aFavorites removeObject:model.symbol];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATEFAVORITES" object:nil];
    
    [userDefaults setObject:aFavorites forKey:@"Favorites"];
    [userDefaults synchronize];
}



@end
