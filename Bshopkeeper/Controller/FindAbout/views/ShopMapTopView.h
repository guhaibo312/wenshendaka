//
//  ShopMapTopView.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopModel;

@interface ShopMapTopView : UIView

+ (instancetype)shopMapTopView;

@property (nonatomic,strong) ShopModel *shopModel;

@end
