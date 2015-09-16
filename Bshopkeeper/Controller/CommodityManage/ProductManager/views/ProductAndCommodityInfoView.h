//
//  ProductAndCommodityInfoView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareInfoDetailHead.h"

@interface ProductAndCommodityInfoView : UIView
{
    UILabel *titleLabel;                    //标题
    UILabel *priceLabel;                    //价格
    UILabel *desLabel;                      //描述
    
    SquareInfoDetailTag *tagView;           //标签
    UIImageView *headImgView;               //头像
    UILabel     *wgwNameLabel;              //官网名称
    UILabel     *wxLabel;                   //微信号
}
- (instancetype)initWithFrame:(CGRect)frame target:(id)target;

- (void)setValueFrom:(id)model;

@end
