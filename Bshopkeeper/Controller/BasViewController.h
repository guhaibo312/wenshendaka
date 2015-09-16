//
//  BasViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Configurations.h"


@interface BasViewController : UIViewController<UIGestureRecognizerDelegate>

/**
 *是否要返回键
 */
@property (nonatomic, assign) BOOL isBackButton;

//是否模态返回
@property (nonatomic, assign) BOOL isModelBack;


//调用alertView方法
- (void)showAlertView:(NSString *)message;

- (void)backAction;//返回功能

- (id) initWithQuery:(NSDictionary*) query ;

- (BOOL)WhetherInMemoryOfChild;

- (BOOL)currentIsTopViewController;

/*
 *设置右上角按钮 文字
 **/
- (void)setRightNavigationBarTitle:(NSString *)text color:(UIColor *)normalColor fontSize:(float)font isBold:(BOOL)isBold frame:(CGRect)fframe;

/*设置右上角按钮 图片
 **/

- (void)setRightNavigationBarBackGroundImgName:(NSString*)imageName frame:(CGRect)frame;

/*
 *右上角按钮功能
 **/
- (void)rightNavigationBarAction:(UIButton *)sender;

@end
