//
//  RBTabbarItem.h
//  MusicNew
//
//  Created by hdapps on 10/13/17.
//  Copyright © 2017 MusicNew. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RBTabbarItem;

@protocol RBTabbarItemDelegate <NSObject>

- (void)fmn_didTouchTabbarItem:(RBTabbarItem *)sender;

@end

@interface RBTabbarItem : UIView

@property (weak, nonatomic) id<RBTabbarItemDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;

@end
