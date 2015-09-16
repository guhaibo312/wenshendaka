//
//  CommodityModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"
#import "Configurations.h"
#import <Foundation/Foundation.h>

@interface CommodityModel : DataBaseObject

@property(nonatomic, strong) NSString * _id;            //商品id
@property(nonatomic, strong) NSString *title;           //title:字符串，商品名，长度<=16
@property(nonatomic, strong) NSString * des;            //description:字符串，介绍，长度<=128
@property(nonatomic, strong) NSString * createdTime;    //createdTime:数字，创建时间戳,

@property(nonatomic, strong) NSArray *images;           //images:字符串数组，图片列表的url
@property(nonatomic, strong) NSString * storeId;        //storeId;
@property(nonatomic, strong) NSString * price;          //price:数字，价格，-1:无价格;0<=v<=1000000
@property(nonatomic, strong) NSString * top;            //top:布尔，是否置顶;
@property(nonatomic, strong) NSString *show;            // 布尔，是否上架
@property(nonatomic, strong) NSString * serviceToHome;  //serviceToHome:布尔，是否上门服务;
@property(nonatomic, strong) NSString * serviceInStore; //serviceInStore:布尔，是否到店服务;
@property(nonatomic, strong) NSString * updataTime;     //updateTime;
@property(nonatomic, strong) NSString * saleCount;      //saleCount = 销售数量;
@property(nonatomic, strong) NSString * category;       //所属分类 分类的id
@property(nonatomic, strong) NSString * clerks;         //关联的店员
@property(nonatomic, strong) NSString * itag;            //字符串标签
@property(nonatomic, strong) NSArray * priceList;       //priceList:（价目表）
@property(nonatomic, strong) NSString * quantifier;      //数字，所属分类，价格单位，0:'元',1:'元/套',2:'元/天',3:'元/次',4:'元/张'
@property(nonatomic, assign) NSInteger deposit;         //定金金额


@property (nonatomic, assign) float commodityListHeight;

//初始化
- (id)initWithDictionary:(NSDictionary *)dict;

/*
 *更新操作
 **/
- (void)upDataFromDict:(NSDictionary *)dict;

/**计算作品集的高度
 */
- (void)judgeCommodityListHeight;

@end
