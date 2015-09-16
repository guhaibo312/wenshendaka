//
//  OtherUserModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"

@interface OtherUserModel : DataBaseObject

@property(nonatomic, strong) NSString * userId;            // 用户id
@property(nonatomic, strong) NSString *nickname;           // 用户名称
@property(nonatomic, strong) NSString * avatar;       // 用户头像地址
@property (nonatomic, assign) int messagenum;              // 未读消息条数


//初始化
- (id)initWithDictionary:(NSDictionary *)dict;


- (void)upDataFromDict:(NSDictionary *)dict;

@end
