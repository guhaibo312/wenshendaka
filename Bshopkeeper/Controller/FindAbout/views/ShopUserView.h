//
//  ShopUserView.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopUser,ShopCompany;

@interface ShopUserView : UIView

+ (instancetype)shopUserView;

@property (nonatomic,strong) ShopUser *user;

@property (nonatomic,strong) ShopCompany *company;

@end
