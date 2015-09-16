//
//  TJWOperationDB.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  数据库管理

#import "TJWOperationDB.h"
#import "CustomerModel.h"
#import "DataDBManage.h"
#import "OrderModel.h"
#import "CommodityModel.h"
#import "ProductModel.h"
#import "MessageCenterModel.h"
#import "JWChatMessageModel.h"
#import "JWChatMessageFrameModel.h"
#import "OtherUserModel.h"
#import "ShopProductModelObject.h"

@implementation TJWOperationDB

@synthesize db = _db;

static TJWOperationDB *tjwOperation;

+ (instancetype)initWithSqlName:(NSString *)sqlName
{
    if (tjwOperation == nil) {
        tjwOperation = [[TJWOperationDB alloc]init];
        if (tjwOperation) {
            tjwOperation.db = [[DataDBManage initWithDataBaseName:sqlName] dataBase];
        }
    }
    return tjwOperation;
}

#pragma mark ------------创建数据库


- (BOOL)createDataBase:(NSString *)baseName withInfo:(NSDictionary *)listInfo
{
    [_db open];
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",baseName]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    NSArray* keyArray = [listInfo allKeys];

    if (existTable) {
        // 数据库已经存在
        for (int i = 0 ; i <keyArray.count; i++) {
            //判断字段是否存在
            if (![_db columnExists:[keyArray objectAtIndex:i] inTableWithName:baseName]) {
                NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",baseName,[keyArray objectAtIndex:i],[listInfo objectForKey:keyArray[i]]];
                [self.db executeUpdate:sql];
            }

        }
        return YES;
    } else {
        NSMutableString *createSql = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,",baseName];
        for (int i = 0 ; i<keyArray.count ; i++) {
            if (i<keyArray.count-1) {
                [createSql appendFormat:@"%@ %@,",keyArray[i],listInfo[keyArray[i]]];
            }else{
                [createSql appendFormat:@"%@ %@ )",keyArray[i],listInfo[keyArray[i]]];
            }
        }
        BOOL res = [_db executeUpdate:createSql];
        if (!res) {
            //数据库创建失败
            NSLog(@"创建数据库失败");
            
        } else {
            //数据库创建成功
            NSLog(@"创建数据库成功");
            return YES;
        }
    }
    [_db close];
    return NO;
}

/*
 *@brief 插入一条信息
 *@param tabName  数据库名称
 *@param cObject  所插入对象
 */
- (void)insertObjectObject:(DataBaseObject *)cObject fromeTable:(NSString *)tableName
{
    [_db open];
    NSMutableString * query = [NSMutableString stringWithFormat:@"INSERT INTO %@",tableName];
    
    NSMutableDictionary *dict = [cObject dataInitialization];
    NSMutableString *keys = [NSMutableString stringWithFormat:@"%@",dict[@"keys"]];
    NSMutableString *values = [NSMutableString stringWithFormat:@"%@",dict[@"values"]];
    [keys appendString:@")"];
    [values appendString:@")"];
    [query appendFormat:@" %@ VALUES%@",
     [keys stringByReplacingOccurrencesOfString:@",)" withString:@")"],
     [values stringByReplacingOccurrencesOfString:@",)" withString:@")"]];
    if ([_db executeUpdate:query]== NO) {
        NSLog(@"插入数据失败");
    }
   
    [_db close];
}

/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (void) delegateObjectFromeTable:(NSString *) uid fromeTable:(NSString *)tableName
{
    [_db open];
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE _id = '%@'",tableName, uid];
    if (![_db executeUpdate:query]) {
        NSLog(@"删除失败");
    };
    [_db close];
}

/**
 * @brief 修改某条的信息
 *
 * @param object 需要修改的用户信息
 */
- (void) upDataObjectInfo:(DataBaseObject *) object fromTable:(NSString *)tableName
{
    [_db open];
    NSString * query = [NSString stringWithFormat:@"UPDATE %@ SET ",tableName ];
    NSString *result =[query stringByAppendingString:[object upDataObjectInfo]];
    if ([_db executeUpdate:result] == NO) {
        NSLog(@"更新数据失败");
    };
    [_db close];
}

/**
 * @brief 修改某条的信息
 *
 * @param object 需要修改的用户信息
 */
- (void) upDataObjectWithSql:(NSString *)query
{
    if (!query) return;
    
    [_db open];
    if ([_db executeUpdate:query] == NO) {
        NSLog(@"更新数据失败");
    };
    [_db close];
}


/*
 *查询所有
 **/
- (NSArray *)findAllFromType:(int)type fromeTable:(NSString *)tableName
{
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY uid DESC",tableName];
    return [self startSearchWithString:query withType:type];
}

/*
 查询联系人信息同时查询消费信息
 **/
- (NSArray *)findAllFromType:(int)type withAccountName:(NSString *)accountName fromTableName:(NSString *)fromTable
{
    NSString *query = [NSString stringWithFormat:@"SELECT * ,case when pay>0 then pay else 0 end respay FROM %@ left join (select sum(payment)pay,customerInfoId from %@ group by customerInfoId) as account on %@._id = account.customerInfoId ORDER BY uid DESC",fromTable,accountName,fromTable];
    return [self startSearchWithString:query withType:type];
}


/*
*查询所有 按照key 排序
*/
- (NSArray *)findAllFromType:(int)type whereFromKeyDes:(NSString *)key fromeTable:(NSString *)tableName
{
    
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    query = [query stringByAppendingFormat:@" ORDER BY %@ DESC ",key];
    return [self startSearchWithString:query withType:type];

}

/*根据key 去查询
 */

- (NSArray *)findWithClassType:(int)type fromid:(NSString *)fromid keyName:(NSString *)keyName fromeTable:(NSString*)tableName
{
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    query = [query stringByAppendingFormat:@" WHERE %@='%@' ORDER BY uid DESC ",keyName,fromid];
    
    return [self startSearchWithString:query withType:type];
}


/*开始查询
 */
- (NSArray *)startSearchWithString:(NSString *)query withType:(int)type
{

    [_db open];
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        if (type == 1) {
            CustomerModel *model = [[CustomerModel alloc]initWithFMResult:rs];
            [array addObject:model];
        }else if(type == 3){
            OrderModel *model = [[OrderModel alloc]initWithFMResult:rs];
            [array addObject:model];
        }else if(type == 4){
            CommodityModel *model = [[CommodityModel alloc]initWithFMResult:rs];
            [array addObject:model];
        }else if (type == 5){
            ProductModel *model = [[ProductModel alloc]initWithFMResult:rs];
            [model judgeProductHeight];
            [array addObject:model];
        }else if (type == 9){
            MessageCenterModel *model = [[MessageCenterModel alloc]initWithFMResult:rs];
            [array addObject:model];
        }else if (type == 10){
            JWChatMessageModel *model = [[JWChatMessageModel alloc]initWithFMResult:rs];
            JWChatMessageFrameModel *frameModel = [[JWChatMessageFrameModel alloc]init];
            [frameModel setMessage:model];
            [array addObject:frameModel];
        }else if (type == 11){
            OtherUserModel *model = [[OtherUserModel alloc]initWithFMResult:rs];
            [array addObject:model];
        }else if (type == 12){
            ShopProductModelObject *model = [[ShopProductModelObject alloc]initWithFMResult:rs];
            [model judgeProductHeight];
            [array addObject:model];
        }
        
    }
    [rs close];
    [_db close];
    return array;

}
/**查询有多少条数据 参数是sqlite语句
 */
- (int)searchAllCountWithsql:(NSString *)sql
{
    if (![NSObject nulldata:sql]) {
        return 0;
    }
    [_db open];
    FMResultSet * rs = [_db executeQuery:sql];
    int number = 0;
    while ([rs next]) {
        number = [rs intForColumn:@"number"];
    }
    [rs close];
    [_db close];
    return number;
    return [rs columnCount];
    
}
/*
 *删除某个表
 **/
- (void)deleteAllFromTable:(NSString *)table
{
   
    [_db open];
    NSString * query = [NSString stringWithFormat:@"DELETE  %@",table];
    [_db executeUpdate:query];
    [_db close];
    
    

}
/*
 *查询是否有这条数据有 就更新没有就添加
 **/
- (BOOL)theTableIsHavetheData:(NSString *)uid fromeTable:(NSString *)tableName
{
    [_db open];
    BOOL result = NO;
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE _id='%@'",tableName,uid];
    FMResultSet * rs = [_db executeQuery:query];
    if (rs != nil) {
        if ([rs next]) {
            result = YES;
        }
    }
    [rs close];
    [_db close];
    return result;
}

/**查询有多少条数据
 */
- (int)searchMuchOfDataFromTable:(NSString *)tableName
{
    [_db open];
    NSString *query = [NSString stringWithFormat:@"SELECT COUNT(*) number FROM %@",tableName];
    FMResultSet *rs = [_db executeQuery:query];
    int number = 0;
    while ([rs next]) {
        number = [rs intForColumn:@"number"];
    }
    [rs close];
    [_db close];
    return number;
    
    
}
/*判断有没有 列 没有就增加
 ***/
- (void)searchTable:(NSString *)tableName haveKeys:(NSDictionary *)dict
{
    if (tableName == nil || dict == nil) {
        return;
    }
    [_db open];
    NSArray *allKeys = [dict allKeys];
    for (int i = 0 ; i< allKeys.count; i++) {
        
        //判断字段是否存在
        if (![_db columnExists:[allKeys objectAtIndex:i] inTableWithName:tableName]) {
            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",tableName,[allKeys objectAtIndex:i],[dict objectForKey:allKeys[i]]];
            [self.db executeUpdate:sql];
        }
    }
    [_db close];
}

/**自定义查询相关
 */
- (NSMutableDictionary *)customQueryParameters:(NSString *)query parm:(NSDictionary *)parm
{
    if (!query || self == NULL || parm == NULL) return nil;
    
    [_db open];
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc]initWithDictionary:parm];
    FMResultSet *rs = [_db executeQuery:query];
    NSArray *keyArray = parm.allKeys;
    while ([rs next]) {
        for (int i = 0 ; i< keyArray.count ; i++) {
            if ([rs stringForColumn:keyArray[i]]) {
                [result setObject:[rs stringForColumn:keyArray[i]] forKey:keyArray[i]];
            }
        }
    }
    [rs close];
    [_db close];
    return result;
}



//创建所有数据库
- (void)createdAllDataBase
{
    
    
    NSString *userId = [User defaultUser].item.userId;
    if (userId) {
        
        //联系人的数据库
        NSString *tableName1 = [NSString stringWithFormat:@"%@%@",CUSTOMERTABLENAME,userId];
        [self createDataBase:tableName1 withInfo:@{@"_id":@"text",@"name":@"text", @"phonenum": @"text", @"birthYear": @"text",@"birthMonth" :@"text" ,@"birthDay":@"text" ,@"gender" :@"text",@"wxNum" :@"text",@"qq":@"text", @"remark": @"text",@"agestagemin" :@"INTEGER",@"agestagemax": @"INTEGER", @"isLunar":@"text", @"groupx":@"text"}];
        
        //订单的数据库
        NSString *tableName2 = [NSString stringWithFormat:@"%@%@",ORDERTABNAME,userId];
        [self createDataBase:tableName2 withInfo:@{@"_id":@"text",@"remark": @"text", @"orderTime" :@"text",@"orderStatus":@"text",@"orderFrom":@"text",@"serviceType" :@"text" ,@"servicePlace": @"text" ,@"orderAddress": @"text" ,@"createdTime": @"text", @"commodityInfoId" :@"text" ,@"customerInfoName" :@"text" ,@"customerInfoId": @"text" , @"customerInfoPhonenum":@"text",@"customerInfoGender":@"text", @"customerInfoWxNum" :@"text",@"updateTime":@"text",@"billId":@"text",@"refunded":@"Integer",@"recycle":@"Integer",@"deposit":@"Integer"}];
        
        //作品的数据库
        NSString *tableName4 = [NSString stringWithFormat:@"%@%@",PRODUCTNAME,userId];
        [self createDataBase:tableName4 withInfo:@{@"_id" :@"text",@"title": @"text", @"des":@"text",@"createdTime":@"text" ,@"category":@"text" ,@"itag" :@"text", @"images":@"varchar",@"customerInfoId":@"text",@"share":@"Integer"}];
 
        //消息中心
        NSString *tableName8 = [NSString stringWithFormat:@"%@%@",MESSAGECENTERNAME,userId];
        [self createDataBase:tableName8 withInfo: @{@"_id":@"text",@"userInfoId":@"text",@"userInfoName":@"text",@"userInfoAvatar":@"text",@"createdTime":@"text", @"own":@"text",@"type":@"text",@"url":@"text" ,@"content":@"text", @"updateTime":@"text"}];
        
        //聊天记录
        NSString *tableName10 = [NSString stringWithFormat:@"%@%@",ChatDataTableName,userId];
        [self createDataBase:tableName10 withInfo: @{@"_id":@"text",@"title":@"text",@"text":@"text",@"images":@"text",@"fromId":@"text", @"url":@"text",@"type":@"Integer",@"otherId":@"text" ,@"time":@"text"}];
        
        //浏览过的其他人信息
        
        NSString *tableName11 = [NSString stringWithFormat:@"%@%@",ChatManageTableName,userId];
        [self createDataBase:tableName11 withInfo: @{@"userId":@"text",@"nickname":@"text",@"avatar":@"text",@"messagenum":@"Integer"}];
        
        //店铺作品的数据库  暂时没用
//        NSString *tableName12 = [NSString stringWithFormat:@"%@%@",ShopProductTableName,userId];
//        [self createDataBase:tableName12 withInfo: @{@"_id":@"text",@"title":@"text",@"des":@"text",@"images":@"text",@"createdTime":@"text",@"itag":@"text",@"storeId":@"Integer",@"share":@"Integer" ,@"clerks":@"text"}];

    }
}



@end

