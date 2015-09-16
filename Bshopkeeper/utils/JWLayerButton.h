//
//  JWLayerButton.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWLayerButton : UIButton

@property (nonatomic, strong) UILabel *messageLabel;


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title fontsize:(float)font style:(int) style selectedBgColor:(UIColor *)color titleColor:(UIColor *)titleColor;

//设置正常状态下的背景颜色
- (void)setNormarlBackGroundColor:(UIColor *)color;

//设置正常下的layer的边框
- (void)setLayerWidth:(float)width;


//设置正常下的字体颜色
- (void)setNameLabelTextColor:(UIColor *)tColor backGroundColor:(UIColor *)bColor;


@end
