//
//  BoxBlur.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (BoxBlur)

- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur;

- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;

@end
