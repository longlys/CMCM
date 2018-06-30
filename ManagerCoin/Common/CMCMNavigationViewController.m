//
//  CMCMNavigationViewController.m
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMNavigationViewController.h"
#import "UIImage+MSTImage.h"

@interface CMCMNavigationViewController () <UINavigationControllerDelegate>
@property (nonatomic,strong) UIBarButtonItem *backButton;

@end

@implementation CMCMNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.translucent = NO;
    [self updateColor];
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.backButton setTintColor:sTitleColor];
}
-(void)updateColor {
    self.view.backgroundColor = sNavBackgroundColor;
    self.navigationBar.barTintColor = sTitleColor;
    self.navigationBar.tintColor = sTinColor;
    [self.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:sTinColor,NSFontAttributeName: [UIFont systemFontOfSize:20]}];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:sNavBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColorWithScaleRatio:sNavBackgroundColor]];
    [self.toolbar setBarTintColor:sTinColor];
    self.toolbar.translucent = NO;
    [self.toolbar setTintColor:sTinColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.navigationItem.backBarButtonItem != self.backButton) {
        viewController.navigationItem.backBarButtonItem = self.backButton;
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self setToolbarHidden:!editing animated:animated];
}


@end
