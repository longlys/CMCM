//
//  CMCMSegmentedViewController.m
//  ManagerCoin
//
//  Created by LongLy on 16/05/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "CMCMSegmentedViewController.h"
#import "CMCMHomeViewController.h"
#import "CMCMFavoritesViewController.h"

@interface CMCMSegmentedViewController ()

@property (nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic,retain)CMCMHomeViewController *homeVC;
@property (nonatomic,retain)CMCMFavoritesViewController *favoritesVC;
@end

@implementation CMCMSegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGRect f = self.view.frame;
//    f.size.height = f.size.height - self.navigationController.navigationBar.frame.size.height;
//    f.origin.y = self.navigationController.navigationBar.frame.size.height;
    self.navigationItem.titleView = self.segmentedControl;

    [self.view setBackgroundColor:sBackgroundColor];
//    [self.navigationController.navigationBar setBackgroundColor:sBackgroundColor];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backButton;
    
    self.homeVC = [[CMCMHomeViewController alloc] init];
    [self addChildViewController:self.homeVC];
    self.homeVC.view.frame = self.view.frame;
    [self.view addSubview:self.homeVC.view];

    self.favoritesVC = [[CMCMFavoritesViewController alloc] init];
    self.favoritesVC.view.frame = self.view.frame;
    [self.view addSubview:self.favoritesVC.view];
    [self addChildViewController:self.favoritesVC];
    [self.favoritesVC.view setHidden:YES];
    [self.segmentedControl setTitle:@"Home" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"Favorites" forSegmentAtIndex:1];
    [self.segmentedControl setTintColor:sTinColor];
    [self.segmentedControl setBackgroundColor:[UIColor clearColor]];

}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FooViewController"];
            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BarViewController"];
            break;
    }
    return vc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) segmentedControlIndexChanged{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.homeVC.view setHidden:NO];
            [self.favoritesVC.view setHidden:YES];
            break;
        case 1:
            [self.favoritesVC.view setHidden:NO];
            [self.homeVC.view setHidden:YES];
            break;
            
        default:
            break;
    }
    
}


@end
