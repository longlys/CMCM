//
//  RBTabbarItemViewController.h
//  MusicNew
//
//  Created by hdapps on 9/16/17.
//  Copyright © 2017 MusicNew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RBTabBar;

@protocol RBTabBarDelegate<NSObject>

@optional

- (void)fmn_tabBar:(RBTabBar *_Nonnull)tabBar didSelectItem:(UITabBarItem *_Nonnull)item;

@end

@interface RBTabBar : UIView

@property(nonatomic,assign) _Nullable id<RBTabBarDelegate> delegate;
@property(nonatomic,strong) NSArray * _Nullable pmn_items;
@property(nonatomic,weak) UITabBarItem * _Nullable pmn_selectedItem;

@property(nonatomic,retain) IBInspectable UIColor * _Nullable pmn_tintColor;
@property(nonatomic,retain) IBInspectable UIColor * _Nullable pmn_tinSelectedColor;

@end

@interface RBTabbarViewController : UIViewController

#pragma mark - Public

- (instancetype _Nonnull )initWithTabbarHidden:(BOOL)hidden;

- (void)fmn_setViewControllers:(NSArray * _Nonnull)viewControllers;

- (void)fmn_setSelectedViewControllerAtIndex:(NSUInteger)index;


#pragma mark - Private

- (void)fmn_selectViewController:(UIViewController * _Nonnull)viewController;

- (void)fmn_drawTabbarItemsForTabbar;

- (void)fmn_setupColorForTabbarController;

-(void)fmn_showTabbar:(BOOL)isShow animated:(BOOL)animated;

@end
