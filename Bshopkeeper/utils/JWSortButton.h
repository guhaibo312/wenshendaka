//
//  JWSortButton.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWSortButton : UIButton
{
    UILabel *_nameLabel;
    UIImageView *_upImg;
    UIImageView *_downImg;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title fontSize:(float)font;

/*
 *设置显示方式
 * status 1 向上 0为向下 其他为默认
 */
- (void)setCurrentShowStatus:(int)status;

@end
