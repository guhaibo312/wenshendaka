//
//  OrderModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/23.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"

@interface OrderModel : DataBaseObject

@property (nonatomic, strong) NSString *_id;          //预约id
@property (nonatomic, strong) NSString *remark;       //备注
@property (nonatomic, strong) NSString *servicePlace; //服务方式 10 到店20 上门
@property (nonatomic, strong) NSString *orderTime;    //预约时间 到分钟 时间戳
@property (nonatomic, strong) NSString *serviceType;  //服务内容
@property (nonatomic, strong) NSString *orderAddress; //订单地址
@property (nonatomic, strong) NSString *createdTime;  //创建时间
@property (nonatomic, strong) NSString *updateTime;   //更新时间
@property (nonatomic, strong) NSString *orderFrom;    //来源 11:'微信邀约',12:'短信邀约',21:'顾客微信发起',22:'顾客web发起',31:'商家生成
@property (nonatomic, strong) NSString *orderStatus;  //预约状态，1:用户点取消;2:商家点取消;4:等用户确认;7:等用商家确认;10:已确认11:商家强行确认;20:已完成
@property (nonatomic, strong) NSString *customerInfoId;     //客户id
@property (nonatomic, strong) NSString *customerInfoName;   //客户名字
@property (nonatomic, strong) NSString *customerInfoPhonenum;//客户手机号
@property (nonatomic, strong) NSString *customerInfoGender;  //客户男女
@property (nonatomic, strong) NSString *custoemrInfoWxNum;   //客户微信号

@property (nonatomic, strong) NSString *commodityInfoId;      //商品信息
@property (nonatomic, assign) NSInteger recycle;              //是否放入回收站
@property (nonatomic, strong) NSString *billId;               //支付订单号
@property (nonatomic, assign) NSInteger deposit;              //定金

//退款状态 0 未退款 1  退款中 2 退款成功 －1 退款失败
@property (nonatomic, assign) NSInteger refunded;

//临时用的
@property (nonatomic, strong) NSString *resultname;
@property (nonatomic, strong) NSString *resultphone;
@property (nonatomic, strong) NSString *imgUrl;

//初始化
- (id)initWithDictionary:(NSDictionary *)dict;

/*
 *更新操作
 **/
- (void)upDataFromDict:(NSDictionary *)dict;
@end
