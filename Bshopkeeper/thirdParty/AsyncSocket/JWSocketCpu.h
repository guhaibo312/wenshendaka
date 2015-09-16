//
//  JWSocketCpu.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JWChatMessageModel;

@interface JWSocketCpu : NSObject

/**单例初始化
 */
+ (instancetype)sharedInstance;

/** socket 发送数据实体
 * commentCode 命令编码   parm 参数数据      targetobject 实体对象
 */
- (void)writeActionWithcommand:(NSInteger)commendCode UserParm:(NSMutableDictionary *)parm;


- (void)writeActionWithcommand:(NSInteger)commendCode UserParm:(NSMutableDictionary *)parm withModel:(JWChatMessageModel *)model;


/**socket 读取数据实例
 */
- (void)readDataFrom:(NSData *)data;


@end
