//
//  ShopModel.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/7.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

//body:
//city
//province
//name
//address
//regLogo
//businessLicense
//location   格式： x|y

@property (nonatomic,copy) NSString *citycode;

@property (nonatomic,copy) NSString *province;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *area;

@property (nonatomic,copy) NSString *businessLicense;

@property (nonatomic,copy) NSString *location;

@property (nonatomic,copy) NSString *cityname;


@end
