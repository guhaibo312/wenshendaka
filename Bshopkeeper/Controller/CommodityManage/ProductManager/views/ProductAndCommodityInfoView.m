//
//  ProductAndCommodityInfoView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ProductAndCommodityInfoView.h"
#import "Configurations.h"
#import "ProductModel.h"
#import "CommodityModel.h"
#import "NSString+Extension.h"
#import "NSString+BG.h"
#import "UIImageView+WebCache.h"


@interface ProductAndCommodityInfoView ()
{
    UIView *grayView;
}

@end
@implementation ProductAndCommodityInfoView

- (instancetype)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        //标题
        titleLabel = [UILabel labelWithFrame:CGRectMake(10, 10, SCREENWIDTH/2+40, 22) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        [self addSubview:titleLabel];
        
        //价格
        priceLabel = [UILabel labelWithFrame:CGRectMake(SCREENWIDTH-120, 10, 110, 22) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLabel];
        
        //描述
        desLabel = [UILabel labelWithFrame:CGRectMake(10, titleLabel.bottom+20, SCREENWIDTH-20, 100) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        desLabel.numberOfLines = 0;
        [self addSubview:desLabel];
        
        //标签
        tagView = [[SquareInfoDetailTag alloc]initWithFrame:CGRectMake(0, desLabel.bottom+20, SCREENWIDTH, 40)];
        [self addSubview:tagView];
        
        //灰色分割
        grayView = [[UIView alloc]initWithFrame:CGRectMake(0, tagView.bottom+20, SCREENWIDTH, 108)];
        grayView.backgroundColor = VIEWBACKGROUNDCOLOR;
        [self addSubview:grayView];
        
        UIButton *whiteBtn = [[UIButton alloc]initWithFrame:CGRectMake(-44, 10, SCREENWIDTH-30+44, 88)];
        whiteBtn.backgroundColor = [UIColor whiteColor];
        
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                                       byRoundingCorners: UIRectCornerBottomRight |UIRectCornerTopRight
//                                                             cornerRadii:CGSizeMake(44,44)];
//        CAShapeLayer * maskLayer = [CAShapeLayer layer];
//        maskLayer.frame         = whiteBtn.bounds;
//        maskLayer.cornerRadius  = 44;
//        maskLayer.fillColor     = [UIColor whiteColor].CGColor;
//        maskLayer.path          = maskPath.CGPath;
//        [whiteBtn.layer  addSublayer: maskLayer];
//        whiteBtn.layer.backgroundColor = [UIColor clearColor].CGColor;
//        whiteBtn.layer.masksToBounds = YES;
        whiteBtn.layer.cornerRadius = 44;
        whiteBtn.clipsToBounds = YES;
        [whiteBtn addTarget:target action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [grayView addSubview:whiteBtn];
        
        headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+44, 10, 68, 68)];
        headImgView.clipsToBounds = YES;
        headImgView.contentMode = UIViewContentModeScaleAspectFill;
        headImgView.layer.cornerRadius=  34;
        [whiteBtn addSubview:headImgView];
        
        wgwNameLabel = [UILabel labelWithFrame:CGRectMake(headImgView.right+10, 20, 180, 22) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        [whiteBtn addSubview:wgwNameLabel];
        
        wxLabel = [UILabel labelWithFrame:CGRectMake(headImgView.right+10, 50, 180, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        [whiteBtn addSubview:wxLabel];
        
        UIImageView *rightPoint = [[UIImageView alloc]initWithFrame:CGRectMake(whiteBtn.width-44-10, whiteBtn.height/2-5, 6, 10)];
        rightPoint.image = [UIImage imageNamed:@"icon_right_img.png"];
        [whiteBtn addSubview:rightPoint];
        
        self.height = grayView.bottom;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setValueFrom:(id)model
{
    if (!model) return;
    NSString *titleStr;
    NSString *priceStr;
    NSString *desStr;
    NSString *tagStr;
    NSString *quitStr;
    if ([model isKindOfClass:[ProductModel class]]) {
        ProductModel *dataSource = (ProductModel *)model;
        titleStr = dataSource.title;
        desStr = dataSource.des;
        tagStr = dataSource.itag;
    }else{
        CommodityModel *dataSource = (CommodityModel *)model;
        titleStr = dataSource.title;
        desStr = dataSource.des;
        priceStr = [NSString stringWithFormat:@"%@",dataSource.price];
        tagStr = dataSource.itag;
        quitStr = dataSource.quantifier;
    }
    
    titleLabel.text = titleStr;
    if ([NSObject nulldata:priceStr ]) {
        priceLabel.hidden = NO;
        
        NSString *priceQuit = [UIUtils getQuitFrom:[quitStr intValue]];
        priceLabel.text = [NSString stringWithFormat:@"¥:%@ %@",priceStr,priceQuit];
    }else{
        priceLabel.hidden = YES;
    }
    
    if ([NSObject nulldata:desStr ]) {
        float desHeight = [desStr sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREENWIDTH-20, 1000)].height;
        desLabel.height = desHeight+10;
        desLabel.text = desStr;
    }else{
        desLabel.top = titleLabel.bottom;
        desLabel.height = 0;
    }
    
    tagView.top = desLabel.bottom+20;
    [tagView setTagStr:tagStr];
    
    grayView.top = tagView.bottom+20;
    
    NSString *headStrURL = [User defaultUser].item.avatar;
    if ([NSObject nulldata:headStrURL]) {
        [headImgView sd_setImageWithURL:[NSURL URLWithString:[headStrURL getQiNiuImgWithWidth:100]] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
    }
    if ([NSObject nulldata:[User defaultUser].item.nickname]) {
        wgwNameLabel.text = [User defaultUser].item.nickname;

    }
    
    NSString *wxStr = [User defaultUser].item.wxNum;
    if (![wxStr isKindOfClass:[NSNull class]] && wxStr != NULL) {
        wxLabel.text = [NSString stringWithFormat:@"微信号：%@",wxStr];
    }else{
        wxLabel.text = @"微信号：";
    }
    self.height = grayView.bottom;
    
}

@end
