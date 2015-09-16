//
//  CompanyInfoItem.h
//  Bshopkeeper
//
//  Created by jinwei on 15/9/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyInfoItem : NSObject

@property (nonatomic, strong) NSNumber *companyId;                      //店铺ID

@property (nonatomic, strong) NSString *address;                        //地址

@property (nonatomic, strong) NSArray *clerkIdList;                     //纹身师列表

@property (nonatomic, strong) NSNumber *hot;                            //人气

@property (nonatomic, strong) NSNumber *ownerId;                        //拥有者

@property (nonatomic, strong) NSNumber *like;                           //赞

@property (nonatomic, strong) NSString *name;                           //店铺名称

@property (nonatomic, strong) NSString *logo;                           //店铺头像

@property (nonatomic, assign) BOOL startJoin;                           //是否开启纹身师加入

- (instancetype)initWithParm:(NSDictionary *)dict;


@end
