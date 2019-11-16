//
//  RBAdsManager.m
//  ReadBook
//
//  Created by Lý Long on 10/28/19.
//  Copyright © 2019 Lý Long. All rights reserved.
//

#import "RBAdsManager.h"

@interface RBAdsManager ()<GADInterstitialDelegate, GADBannerViewDelegate>

@end

@implementation RBAdsManager

- (id)init{
    self = [super init];
    if (self) {
        self.interstitial = [self createAndLoadInterstitial];
    }
    return self;
}
-(void)setIsPro:(BOOL)isPro{
    [[NSUserDefaults standardUserDefaults] setBool:isPro forKey:@"ISPROX"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)getIspro{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ISPROX"];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:idinterstitial];
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [interstitial loadRequest:request];
    return interstitial;
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

-(void)showInterstitial:(UIViewController *)vc{
    NSInteger dem = [self getNumberShow]+1;
    if (dem == 3) {
        if (self.interstitial.isReady) {
            [self.interstitial presentFromRootViewController:vc];
            [self setNumberShow:dem];
        } else {
            NSLog(@"Ad wasn't ready");
        }
        [self createAndLoadInterstitial];
    } else {
        if (dem>3) {
            [self setNumberShow:0];
        } else {
            [self setNumberShow:dem];
        }
    }
}

-(void)setNumberShow:(NSInteger )dem{
    [[NSUserDefaults standardUserDefaults] setInteger:dem forKey:@"NumberShowInterstitial"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger )getNumberShow{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"NumberShowInterstitial"];
}

//banner
- (UIView *)showAdBanner {
    
    UIViewController *vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (vc.parentViewController) {
        vc = vc.parentViewController;
    }
    
    [self showAdsBannerWithAdUnitID:idBanner viewController:vc];
    return self.bannerView;
}

- (void)removeAdsBanner {
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}
- (void)showAdsBannerWithAdUnitID:(NSString *)adUnitID viewController:(UIViewController *)viewController {
    
    if (!self.bannerView) {
        self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        self.bannerView.delegate = self;
    }
    self.bannerView.adUnitID = adUnitID;
    self.bannerView.rootViewController = viewController;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];

    [self.bannerView loadRequest:request];
}

#pragma mark - GADBannerViewDelegate

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDAdsManagerFailBannerAdsNotification" object:self];
    NSLog(@"%@", error);
}

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:view, @"adsbanner", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HDAdsManagerDidReceiveBannerAdsNotification" object:nil userInfo:userInfo];
}


@end
