//
//  DataDBManage.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"


@interface DataDBManage : NSObject

@property (nonatomic, retain) FMDatabase * dataBase;  // 数据库操作对象

/**
 * @brief 初始化数据库操作
 * @param name 数据库名称
 */
+ (id)initWithDataBaseName:(NSString *)name;

@end
