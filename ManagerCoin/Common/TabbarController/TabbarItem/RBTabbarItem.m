//
//  RBTabbarItem.m
//  MusicNew
//
//  Created by hdapps on 10/13/17.
//  Copyright © 2017 MusicNew. All rights reserved.
//

#import "RBTabbarItem.h"

@interface RBTabbarItem ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation RBTabbarItem

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RBTabbarItem" owner:self options:nil] objectAtIndex:0];
        self.iconView.image = image;
    }
    return self;
}

- (IBAction)touchUpInsideActionButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(fmn_didTouchTabbarItem:)]) {
        [self.delegate fmn_didTouchTabbarItem:self];
    }
}

@end
