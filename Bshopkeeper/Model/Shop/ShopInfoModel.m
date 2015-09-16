//
//  ShopInfoModel.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopInfoModel.h"
#import "MJExtension.h"
#import "ShopProductModelObject.h"
#import "ShopUser.h"

@implementation ShopInfoModel

MJCodingImplementation

- (NSDictionary *)objectClassInArray{
    return @{@"productList" : [ShopProductModelObject class],
             @"userList" : [ShopUser class]
             };
}

@end
