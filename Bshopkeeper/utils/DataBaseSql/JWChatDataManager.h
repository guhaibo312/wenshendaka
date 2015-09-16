//
//  JWChatDataManager.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  聊天数据管理

#import <Foundation/Foundation.h>

@interface JWChatDataManager : NSObject


@property (nonatomic, assign) int messageTotalCount;                //消息总条数

@property (nonatomic, strong) NSMutableDictionary *userInfoDict;    //关于用户信息

+ (instancetype)sharedManager;


/** 第一次 加载本地数据库到本地缓存
 */
- (void)onceLoadLocalToCache;


/** 更新 浏览用户
 */
- (void)saveUserToLocal:(NSDictionary *)parm;

/*** 更新用户的消息数字*/

- (void)updataUserMessage:(NSString *)userId  clean:(BOOL) isClear;


@end
