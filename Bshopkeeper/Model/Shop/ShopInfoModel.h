//
//  ShopInfoModel.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCompany.h"

@interface ShopInfoModel : NSObject<NSCoding>

@property (nonatomic,strong) NSArray *productList;

@property (nonatomic,strong) NSArray *userList;

@property (nonatomic,strong) ShopCompany *company;

@end
