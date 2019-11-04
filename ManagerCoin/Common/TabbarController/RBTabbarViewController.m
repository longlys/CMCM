//
//  RBTabbarViewController.m
//  MusicNew
//
//  Created by hdapps on 9/16/17.
//  Copyright © 2017 MusicNew. All rights reserved.
//

#import "RBTabbarViewController.h"
#import "RBTabbarItem.h"

@interface RBTabBar()<RBTabbarItemDelegate>

@property (nonatomic, strong) NSMutableArray *pmn_buttonsArray;

@end

@implementation RBTabBar

- (void)didMoveToWindow{
    [super didMoveToWindow];
    [self fmn_redrawUI];
    if (!self.pmn_selectedItem) {
        [self setSelectedItem:[self.pmn_items firstObject]];
    }else{
        [self setSelectedItem:self.pmn_selectedItem];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self fmn_updateLayout];
}

#pragma mark - Private

- (void)fmn_redrawUI {
    //init arraybutton
    [self.pmn_buttonsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.pmn_buttonsArray) {
        [self.pmn_buttonsArray removeAllObjects];
    }else{
        self.pmn_buttonsArray = [NSMutableArray new];
    }
    
    NSUInteger itemCount = self.pmn_items.count;
    for (NSUInteger index = 0; index < itemCount; index ++) {
        UITabBarItem *tabItem = self.pmn_items[index];
        UIImage *image = [tabItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        RBTabbarItem *button = [[RBTabbarItem alloc] initWithImage:image];
        button.delegate = self;
        button.tag = index;
        
        [self.pmn_buttonsArray addObject:button];
        [self insertSubview:button atIndex:0];
    }
}

- (void)fmn_updateLayout {
    
    NSUInteger itemCount = self.pmn_items.count;
    float width = floorf(self.frame.size.width/(float)itemCount);
    float height = self.frame.size.height;
    for (NSUInteger index = 0; index < itemCount;  index++) {
        CGRect rect = CGRectMake(index*width, 0, width, height);
        rect.size.width = width + 1;
        if (index == itemCount - 1) {
            rect.size.width = width + 4;
        }
        UIView *view = self.pmn_buttonsArray[index];
        view.frame = rect;
    }
}

#pragma mark - Property

- (void)setItems:(NSArray *)items {
    
    _pmn_items = items;
    if (self.window) {
        [self fmn_redrawUI];
    }
    if (!self.pmn_selectedItem) {
        [self setSelectedItem:[self.pmn_items firstObject]];
    }else{
        [self setSelectedItem:self.pmn_selectedItem];
    }
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    
    _pmn_selectedItem = selectedItem;
    NSUInteger index = [self.pmn_items indexOfObject:selectedItem];
    NSUInteger itemCount = self.pmn_items.count;
    for (NSUInteger i = 0; i < itemCount; i++) {
        UIView *viewItem = self.pmn_buttonsArray[i];
        if (i == index) {
            viewItem.tintColor = self.pmn_tinSelectedColor;
        }else{
            viewItem.tintColor = self.pmn_tintColor;
        }
    }
}

#pragma mark - RBTabbarItemDelegate

- (void)fmn_didTouchTabbarItem:(RBTabbarItem *)sender {
    
    NSInteger index = [self.pmn_buttonsArray indexOfObject:sender];
    UITabBarItem *item = self.pmn_items[index];
    [self setSelectedItem:item];
    if (self.delegate) {
        [self.delegate fmn_tabBar:self didSelectItem:item];
    }
}

@end

/**
 *  **************************************************************
 */

#pragma mark - Tabbar Controller

@interface RBTabbarViewController () <RBTabBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet RBTabBar *tabbar;

@property (strong, nonatomic) NSArray *pmn_viewControllers;
@property (strong, nonatomic) UIViewController *pmn_selectedViewController;
@property (nonatomic) NSUInteger pmn_selectedIndex;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabbarHeightContraints;

@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerHeightContraints;

@property (weak, nonatomic) IBOutlet UIView *miniplayerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miniPlayerHeightContraints;

@property (nonatomic) BOOL hiddenTabbar;
@property (nonatomic) BOOL didReceiveAds;

@end

#define kToolbarHeight 70

@implementation RBTabbarViewController

- (instancetype)initWithTabbarHidden:(BOOL)hidden
{
    self = [super init];
    if (self) {
        self.hiddenTabbar = hidden;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tabbar.delegate = self;
    // If this TabbarController had viewcontrollers, we need set tabbar items for tabbar
    [self fmn_drawTabbarItemsForTabbar];
    
    [self fmn_setupColorForTabbarController];
    
    [self fmn_setSelectedViewControllerAtIndex:self.pmn_selectedIndex];
//    [self addBanner];
    if (self.hiddenTabbar) {
        //hidden tabbar : no tabbar, no baner ads
        [self fmn_showTabbar:NO animated:NO];

    } else {
        [self fmn_showTabbar:YES animated:NO];
    }
    [self addBanner];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatebanner)
                                                 name:@"INAPPREMOVEADS"
                                               object:nil];

}
-(void)updatebanner{
    if(![sAdsManager getIspro]){
        [self fmn_showBanner:YES animated:NO];
    } else {
        [self fmn_showBanner:NO animated:NO];
    }
}
- (void)addBanner{
    UIView *bannerAds = [sAdsManager showAdBanner];
    [bannerAds setBackgroundColor:[UIColor clearColor]];
    CGRect adsFrame = self.bannerView.frame;
    adsFrame.size.height = bannerAds.bounds.size.height;
    self.bannerView.frame = adsFrame;
    [self.bannerView addSubview:bannerAds];
    self.didReceiveAds = YES;
    [self.bannerView setBackgroundColor:[UIColor clearColor]];
    if(![sAdsManager getIspro]){
        [self fmn_showBanner:YES animated:NO];
    } else {
        [self fmn_showBanner:NO animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public

- (void)fmn_setViewControllers:(NSArray *)viewControllers {
    
    // set viewcontrollers array for this tabbarcontroller
    _pmn_viewControllers = viewControllers;
    
    // If this tabbarcontroller was loaded, set tabbaritems for tabbar
    [self fmn_drawTabbarItemsForTabbar];
}

- (void)fmn_setSelectedViewControllerAtIndex:(NSUInteger)index {
    
    // If this viewcontroller wasn't loaded, we save this index to display after it will be loaded
    _pmn_selectedIndex = index;
    
    // Display Viewcontroller at selectedIndex
    if (self.pmn_viewControllers) {
        UIViewController *selectedViewController = [self.pmn_viewControllers objectAtIndex:index];
        [self fmn_selectViewController:selectedViewController];
        
        UITabBarItem *tabItem = self.pmn_selectedViewController.tabBarItem;
        [self.tabbar setSelectedItem:tabItem];
    }
    
}

#pragma mark - Private
- (void)fmn_selectViewController:(UIViewController * _Nonnull)viewController {
    
    // First, Remove old viewcontroller
    [self.pmn_selectedViewController removeFromParentViewController];
    [self.pmn_selectedViewController didMoveToParentViewController:nil];
    [self.pmn_selectedViewController.view removeFromSuperview];
    
    // Set new selected viewcontroller and display it
    self.pmn_selectedViewController = viewController;
    [self addChildViewController:self.pmn_selectedViewController];
    [self.pmn_selectedViewController didMoveToParentViewController:self];
    self.pmn_selectedViewController.view.frame = self.contentView.bounds;
    self.pmn_selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView insertSubview:self.pmn_selectedViewController.view atIndex:0];
}

- (void)fmn_drawTabbarItemsForTabbar {
    
    // Get tabbar items of viewcontrollers and set items for 
    NSMutableArray *tabbarItems = [NSMutableArray new];
    for (UIViewController *controller in self.pmn_viewControllers) {
        [tabbarItems addObject:controller.tabBarItem];
    }
    UITabBarItem *tabItem = self.pmn_selectedViewController.tabBarItem;
    [self.tabbar setItems:tabbarItems];
    [self.tabbar setSelectedItem:tabItem];
}

- (void)fmn_setupColorForTabbarController {
    self.tabbar.backgroundColor = sBackgroundColor2;
    self.tabbar.pmn_tintColor = sTitleColor;
    self.tabbar.pmn_tinSelectedColor = sTinColor;
}

-(void)fmn_showTabbar:(BOOL)isShow animated:(BOOL)animated {
    self.tabbarHeightContraints.constant = isShow ? 49.0 : 0.1;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}

-(void)fmn_showBanner:(BOOL)isShow animated:(BOOL)animated {
    self.bannerHeightContraints.constant = isShow ? self.bannerView.bounds.size.height : 0.0;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - RBTabbarItemDelegate

- (void)fmn_tabBar:(RBTabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if(![sAdsManager getIspro]){
        [sAdsManager showInterstitial:self];
    }
    NSUInteger index = [self.tabbar.pmn_items indexOfObject:item];
    if (index != NSNotFound) {
        UINavigationController *selectedViewController = [self.pmn_viewControllers objectAtIndex:index];
        if (selectedViewController == self.pmn_selectedViewController && [selectedViewController isKindOfClass:[UINavigationController class]]) {
            // If touch on current selected tabbar item, we pop to root viewcontroller at that tab
            [selectedViewController popToRootViewControllerAnimated:YES];
            
        } else {
            [self fmn_selectViewController:selectedViewController];
        }
        
    } else {
        // Some error
        [tabBar setSelectedItem:nil];
    }
}

@end
