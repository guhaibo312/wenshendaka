//
//  CustomerModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"
#import "Configurations.h"

@interface CustomerModel : DataBaseObject

@property (nonatomic, strong) NSString *_id;       //客户id
@property (nonatomic, strong) NSString *name ;     // 客户名称
@property (nonatomic, strong) NSString *phonenum;  //手机号
@property (nonatomic, strong) NSString *birthYear; //生日 年
@property (nonatomic, strong) NSString *birthMonth;//生日 月
@property (nonatomic, strong) NSString *birthDay;  //生日 日
@property (nonatomic, strong) NSString *gender;    //性别
@property (nonatomic, strong) NSString *wxNum;     //微信号
@property (nonatomic, strong) NSString *qq;        //qq
@property (nonatomic, strong) NSString *remark;    //备注
@property (nonatomic, strong) NSString *group;      //分组
@property (nonatomic, assign) BOOL  isLunar;        //0 阳历 1 阴历
@property (nonatomic, assign) int  ageStageMin;     //年龄范围下限
@property (nonatomic, assign) int  ageStageMax;     //年龄上限
@property (nonatomic, strong) NSString * pay;       //总的消费

//初始化
- (id)initWithDictionary:(NSDictionary *)dict;

/*
 *更新操作
 **/
- (void)upDataFromDict:(NSDictionary *)dict;

@end
