//
//  TJWOperationDB.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseObject.h"

@interface TJWOperationDB : NSObject
{
    FMDatabase * _db;
    NSString *_name;
}
/*
 *@brief 初始化操作
 *@param sqlName 数据库的表名称
 */
@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)initWithSqlName:(NSString *)sqlName;

/*
 *@brief 创建数据库
 *@param  baseName 数据库名称
 *@param  listInfo 表单信息
 *@return yes 存在  no 不存在
 */
- (BOOL)createDataBase:(NSString *)baseName withInfo:(NSDictionary *) listInfo;

/*
 *@brief 插入一条信息
 *@param tabName  数据库名称
 *@param cObject  所插入对象
 */
- (void)insertObjectObject:(DataBaseObject *)cObject fromeTable:(NSString *)tableName;


/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (void) delegateObjectFromeTable:(NSString *) uid fromeTable:(NSString *)tableName;


/**
 * @brief 修改某条的信息
 *
 * @param object 需要修改的用户信息
 */
- (void) upDataObjectInfo:(DataBaseObject *) object fromTable:(NSString *)tableName;


/**
 * @brief 修改某条的信息
 *
 * @param object 需要修改的用户信息
 */
- (void) upDataObjectWithSql:(NSString *)query;


/*
 *查询所有
 **/
- (NSArray *)findAllFromType:(int)type fromeTable:(NSString *)tableName;

/*
 *查询关于某个id的相关信息
 **/
- (NSArray *)findWithClassType:(int)type fromid:(NSString *)fromid keyName:(NSString *)keyName fromeTable:(NSString*)tableName;

/*
 *查询所有 按照key 排序
 */
- (NSArray *)findAllFromType:(int)type whereFromKeyDes:(NSString *)key fromeTable:(NSString *)tableName;

/*
 *删除某张表
 **/
- (void)deleteAllFromTable:(NSString *)table;

/**查询是否有这条数据有 就更新没有就添加
 **/
- (BOOL)theTableIsHavetheData:(NSString *)uid fromeTable:(NSString *)tableName;

/**查询联系人信息同时查询消费信息
 **/
- (NSArray *)findAllFromType:(int)type withAccountName:(NSString *)accountName fromTableName:(NSString *)fromTable;

/**判断有没有 列 没有就增加
 **/
- (void)searchTable:(NSString *)tableName haveKeys:(NSDictionary *)dict;


/**查询有多少条数据
 */
- (int)searchMuchOfDataFromTable:(NSString *)tableName;


//创建所有数据库
- (void)createdAllDataBase;

/*开始查询
 */
- (NSArray *)startSearchWithString:(NSString *)query withType:(int)type;

/**查询有多少条数据 参数是sqlite语句
 */
- (int)searchAllCountWithsql:(NSString *)sql;


/**自定义查询相关
 */
- (NSMutableDictionary *)customQueryParameters:(NSString *)query parm:(NSDictionary *)parm;


@end
