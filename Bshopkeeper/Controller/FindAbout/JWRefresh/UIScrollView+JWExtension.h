
//
//  UIScrollView+JWExtension.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIScrollView (JWExtension)
@property (assign, nonatomic) CGFloat JW_contentInsetTop;
@property (assign, nonatomic) CGFloat JW_contentInsetBottom;
@property (assign, nonatomic) CGFloat JW_contentInsetLeft;
@property (assign, nonatomic) CGFloat JW_contentInsetRight;

@property (assign, nonatomic) CGFloat JW_contentOffsetX;
@property (assign, nonatomic) CGFloat JW_contentOffsetY;

@property (assign, nonatomic) CGFloat JW_contentSizeWidth;
@property (assign, nonatomic) CGFloat JW_contentSizeHeight;
@end
