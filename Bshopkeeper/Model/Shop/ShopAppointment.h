//
//  ShopAppointment.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopAppointment : NSObject

@property (nonatomic,copy) NSString *nickname;

@property (nonatomic,copy) NSString *hot;

@property (nonatomic,copy) NSString *avatar;

@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy) NSString *companyId;

@property (nonatomic,strong) NSArray *products;

@end
