//
//  TitleImageButton.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "TitleImageButton.h"

@implementation TitleImageButton


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)text fontSize:(float)font ImageName:(NSString *)unSelectedImage SelectedImage:(NSString *)selectedImg
{
    self = [super initWithFrame:frame];
    if (self) {
        if (text) {
            [self setTitle:text forState:UIControlStateNormal];
            [self setTitle:text forState:UIControlStateSelected];
            [self setTitle:text forState:UIControlStateHighlighted];
        }
        if (font) {
            self.titleLabel.font = [UIFont systemFontOfSize:font];
        }
    
        if (unSelectedImage) {
            [self setImage:[UIImage imageNamed:unSelectedImage] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:unSelectedImage] forState:UIControlStateSelected];
            [self setImage:[UIImage imageNamed:unSelectedImage] forState:UIControlStateHighlighted];
        }

        if (selectedImg) {
            [self setImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
        }
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    return self;
}

+ (instancetype)buttonWithFrame:(CGRect)frame imageName:(NSString *)unSelectedImage seletedImage:(NSString *)seletedImg
{
    TitleImageButton *button = [TitleImageButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (unSelectedImage) {
        [button setBackgroundImage:[UIImage imageNamed:unSelectedImage] forState:UIControlStateNormal];
    }
    if (seletedImg) {
        [button setBackgroundImage:[UIImage imageNamed:seletedImg] forState:UIControlStateHighlighted];

    }
    button.backgroundColor = [UIColor whiteColor];
    return button;
}

+ (instancetype)buttonWithFrame:(CGRect)frame imageName:(NSString *)unSelectedImage title:(NSString *)title
{
    TitleImageButton *button = [TitleImageButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = frame;
    if (unSelectedImage) {
        [button setBackgroundImage:[UIImage imageNamed:unSelectedImage] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:unSelectedImage] forState:UIControlStateHighlighted];
    }
    button.backgroundColor = [UIColor whiteColor];
    return button;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
