//
//  StoryInfoItem.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryInfoItem : NSObject
@property (nonatomic, strong) NSString *storeId;            //id
@property (nonatomic, strong) NSString *storeName;          //店名
@property (nonatomic, strong) NSString *topBanner;          //店铺顶部背景图案的url
@property (nonatomic, strong) NSString *createdTime;        //创建店铺的时间戳
@property (nonatomic, strong) NSString *storeType;          //店铺类型 0 个人 1 企业
@property (nonatomic, strong) NSString *banned;             //是不是封号 0 正常 1 七天 2 永久
@property (nonatomic, strong) NSString *storeNum;           //美掌柜
@property (nonatomic, strong) NSString *serviceInStore;     //到店服务
@property (nonatomic, strong) NSString *serviceToHome;      //上门
@property (nonatomic, strong) NSString *cdescription;        //描述
@property (nonatomic, strong) NSString *serviceArea;         //服务区域
@property (nonatomic, strong) NSString *sector;              //行业
@property (nonatomic, strong) NSNumber *like;                //赞
@property (nonatomic, strong) NSString *hotRankCountry;       //排名
@property (nonatomic, strong) NSString *hot;                //人气
@property (nonatomic, strong) NSString *city;               //省
@property (nonatomic, strong) NSString *province;           //市
@property (nonatomic, strong) NSString *area;               //区县
//10=>"美甲",
//20=>"美发",
//30=>"纹身",
//40=>"摄影",
//50=>"美容",

@property (nonatomic, strong) NSDictionary *userInfo;        //个人信息
@property (nonatomic, strong) NSString *openTime;           //字符串，营业时间 例：“09:10-20:00”
@property (nonatomic, strong) NSString *orderNotice;        //字符串，预约须知，长度<=60
@property (nonatomic, strong) NSString *visitCount;         //访问量
- (void)setValuesForSlef:(NSDictionary *)dict;


@end
