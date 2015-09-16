//
//  MessageCenterModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"

@interface MessageCenterModel : DataBaseObject
//_id ;
//userInfo:{当是自己发送的消息时不读取该字段，使用自己的数据代替
//    userId = null;
//name:字符串，代金券名称，长度小于20，
//avatar:字符串，头像url地址,长度<=200,
//}
//createdTime;
//own:布尔，是否是自己发送的消息
//type:数字，类型，1:普通消息
//url:字符串，用于跳转的链接，若不为空则点击可以跳转
//content:
//deletedTime;
//updateTime;

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *userInfoId;
@property (nonatomic, strong) NSString *userInfoName;
@property (nonatomic, strong) NSString *userInfoAvatar;
@property (nonatomic, strong) NSString *createdTime;
@property (nonatomic, strong) NSString *own;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *updateTime;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
