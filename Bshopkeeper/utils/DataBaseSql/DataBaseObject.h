//
//  DataBaseObject.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface DataBaseObject : NSObject




//插入一条数据
- (NSMutableDictionary *)dataInitialization;

//更新一条数据
- (NSString *)upDataObjectInfo;

//绑定数据的数据化方法
- (id)initWithFMResult:(FMResultSet *)rt;

@end
