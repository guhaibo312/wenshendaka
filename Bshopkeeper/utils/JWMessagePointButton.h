//
//  JWMessagePointButton.h
//  Bshopkeeper
//
//  Created by jinwei on 15/9/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWMessagePointButton : UIButton


- (instancetype)initWithFrame:(CGRect)frame BackImage:(UIImage *)backImg;


@property (nonatomic, strong)   UILabel *messageLabel;



@end
