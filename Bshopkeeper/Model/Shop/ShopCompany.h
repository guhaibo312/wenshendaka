//
//  ShopCompany.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCompany : NSObject

@property (nonatomic,copy) NSString *ownerId;

@property (nonatomic,copy) NSString *companyId;

@property (nonatomic,strong) NSArray *adminIdList;

@property (nonatomic,strong) NSArray *topBanner;

@end
