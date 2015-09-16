//
//  ShopMapTopView.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopMapTopView.h"
#import "ShopModel.h"

@interface ShopMapTopView()

@property (weak, nonatomic) IBOutlet UIView *bjView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation ShopMapTopView

+ (instancetype)shopMapTopView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ShopMapTopView" owner:nil options:nil] firstObject];
}

- (void)setShopModel:(ShopModel *)shopModel
{
    _shopModel = shopModel;
    
    self.descriptionText.text = self.shopModel.name;
    self.address.text = self.shopModel.address;
}

- (void)awakeFromNib
{
    self.bjView.layer.cornerRadius = 8;
    self.bjView.layer.masksToBounds = YES;
}


@end
