//
//  TitleImageButton.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleImageButton : UIButton

/*
 *带文字和图片的
 **/
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)text fontSize:(float)font ImageName:(NSString *)unSelectedImage SelectedImage:(NSString *)selectedImg;

/*
 *带背景和选中效果的
 **/
+ (instancetype)buttonWithFrame:(CGRect)frame imageName:(NSString *)unSelectedImage seletedImage:(NSString *)seletedImg;

/*
 *带文字 和背景的
 **/

+ (instancetype)buttonWithFrame:(CGRect)frame imageName:(NSString *)unSelectedImage title:(NSString *)title;
@end
