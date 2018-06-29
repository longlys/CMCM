//
//  UIImage+MSTImage.h
//  ManagerCoin
//
//  Created by LongLy on 28/06/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MSTImage)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

- (UIImage*)imageWithColorOvelay:(UIColor *)color1;

- (UIImage*)imageWithColorOvelay:(UIColor *)color1 replace:(UIColor*) color2;

- (UIImage*)imageWithColor:(UIColor*) color replaceInMask:(UIImage*)mask;

- (UIImage*)imageWithMask:(UIImage*)mask;

- (UIImage*)imagePlusImage:(UIImage*)image2;

- (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+ (UIImage *)imageWithColorWithScaleRatio:(UIColor *)color;

@end

