//
//  RBAdsManager.h
//  ReadBook
//
//  Created by Lý Long on 10/28/19.
//  Copyright © 2019 Lý Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GoogleMobileAds;

NS_ASSUME_NONNULL_BEGIN

@interface RBAdsManager : NSObject

@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;

-(void)showInterstitial:(UIViewController *)vc;
- (UIView *)showAdBanner;
-(void)setIsPro:(BOOL)isPro;
-(BOOL)getIspro;
@end

NS_ASSUME_NONNULL_END
