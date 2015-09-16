//
//  UserInfoItem.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoryInfoItem.h"

@interface UserInfoItem : NSObject

@property (nonatomic, retain) NSString *userId;             //  用户id
@property (nonatomic, retain) NSString *phonenum;           //  用户手机号
@property (nonatomic, retain) NSString *secPhonenum;        //加密后的手机号
@property (nonatomic, retain) NSString *nickname;           //  用户惯用名
@property (nonatomic, retain) NSString *name;               //  用户姓名
@property (nonatomic, retain) NSString *avatar;             //  头像的url地址
@property (nonatomic, retain) NSString *birthYear;          //  年份（生日）
@property (nonatomic, retain) NSString *birthMonth;         //  月份（生日）
@property (nonatomic, retain) NSString *birthDay;           //  日  （生日）
@property (nonatomic, retain) NSString *faith;              //  签名
@property (nonatomic, retain) NSString *gender;             //  性别 －1 未知 0 女 1 男
@property (nonatomic, retain) NSString *sinaOpenId;         //  新浪的id
@property (nonatomic, retain) NSString *wxNum;              //  微信号
@property (nonatomic, retain) NSString *wxOpenId;           //  微信id
@property (nonatomic, retain) NSString *role;               //  权限（0普通用户，110 普通管理员 120 c超级管理员）
@property (nonatomic, retain) NSString *banned;             //  是否封号（0 正常，1 七天 2永久）
@property (nonatomic, retain) NSString *storeId;            //  关联的店铺id
@property (nonatomic, retain) NSString *storeName;          //  关联的店铺名称
@property (nonatomic, retain) NSString *storeNum;           //  美掌柜号
@property (nonatomic, retain) NSString *sector;             //行业
@property (nonatomic, assign) BOOL showDetailsInSocial;     //是否在圈子中公开
@property (nonatomic, strong) NSString *v;                  //实名状态

@property (nonatomic, retain) NSDictionary *company;            //  公司
@property (nonatomic, strong) NSDictionary *bankcard;           //银行卡信息

@property (nonatomic, strong) NSString *city;               //省
@property (nonatomic, strong) NSString *province;           //市
@property (nonatomic, strong) NSString *area;               //区县

@property (nonatomic, assign) double lat;                   //lat 纬度
@property (nonatomic, assign) double lon;                   //lon 经度

@property (nonatomic,copy) NSString *companyId;

//默认的初始化
- (void)initWithParm:(NSDictionary *)dict;

@end

@interface User : NSObject

@property (nonatomic, assign) BOOL cannotChat;          //是否支持聊天

@property (nonatomic, retain) UserInfoItem *item;       //个人信息
@property (nonatomic, retain) StoryInfoItem *storeItem; //店铺信息

@property (nonatomic, assign) BOOL isLogIn;             //是否登陆

@property (nonatomic, strong) NSString *rongcloudToken; //容云token

@property (nonatomic, strong) NSString *kefuNum;        //客服id

@property (nonatomic, strong) NSString *kefuName;       //客服名称

@property (nonatomic, strong) NSString *kefuHeadURL;

@property (nonatomic, assign) BOOL supportRongyun;      //是否支持容云


@property (nonatomic, strong)  NSDictionary *messageInfo;   //消息内容

@property (nonatomic, strong) NSArray *galleryBanner;
@property (nonatomic, strong) NSArray *squareBanner;

@property (nonatomic, strong) NSMutableDictionary *followingDict;


+ (instancetype)defaultUser;

/**初始化登录负值
 */
- (void)logInSucessSaveInfo:(NSDictionary *)result;

//修改数据后对应的item也应该修改
- (void)changeUserInfo:(NSDictionary *)idict storeInf:(NSDictionary *)sdict;


//登录成功获取新增数据
- (void)getNewDataFromServer;



@end
