//
//  ShopAppointment.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopAppointment.h"
#import "ShopProductModelObject.h"

@implementation ShopAppointment

- (NSDictionary *)objectClassInArray{
    return @{@"products" : [ShopProductModelObject class]
             };
}

@end
