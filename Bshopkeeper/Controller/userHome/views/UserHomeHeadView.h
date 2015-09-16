//
//  UserHomeHeadView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasViewController;
@protocol JWSharedManagerDelegate;

@interface UserHomeHeadView : UIView

- (instancetype)initWithOwnerViewController:(UIViewController *)controller;

@property (nonatomic, assign)   UIViewController *superVc;
@property (nonatomic, strong)   UIImageView *backImgView;


/*复值
 */
- (void)changeAction;


/*
 *设置头像点击功能
 **/

- (void)setHeadViewClickAction:(SEL)sel withTarget:(id)target;


/**获取头像
 */
- (UIImage *)getUserHeadImg;

@end

