//
//  SquareLikeButton.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/3.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareLikeButton : UIButton


@property (nonatomic,strong)UIColor *hightColor;

@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UILabel *contentLabel;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title imageName:(NSString *)imageName;

@end
