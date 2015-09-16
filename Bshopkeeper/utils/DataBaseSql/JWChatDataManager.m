//
//  JWChatDataManager.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatDataManager.h"
#import "OtherUserModel.h"
#import "Configurations.h"
#import "TJWOperationDB.h"

@implementation JWChatDataManager


+ (instancetype)sharedManager
{
    static JWChatDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JWChatDataManager alloc]init];
        manager.messageTotalCount=  0;
        manager.userInfoDict = [[NSMutableDictionary alloc]init];
    });
    return manager;
}

- (void)saveUserToLocal:(NSDictionary *)parm
{
    if (!parm) return;
    
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",[User defaultUser].item]];
    
    NSString *tableName= [NSString stringWithFormat:@"%@%@",ChatManageTableName,[User defaultUser].item.userId];

    OtherUserModel *item = [[OtherUserModel alloc]initWithDictionary:parm];
    
    NSString *userId = [NSString stringWithFormat:@"%@",item.userId];
   
    //判断数据库有数据就更新 没有就添加
    if ([operationDB searchAllCountWithsql:[NSString stringWithFormat:@"select count(*)number from %@ where userId = '%@'",tableName,item.userId]]>0) {
        [operationDB upDataObjectInfo:item fromTable:tableName];
    }else{
        [operationDB insertObjectObject:item fromeTable:tableName];
    }
    
    if ([self.userInfoDict.allKeys containsObject:userId]) {
        OtherUserModel *tempModel = (OtherUserModel *)[self.userInfoDict objectForKey:userId];
        if (tempModel) {
            item.messagenum = tempModel.messagenum;
        }
    }
    [self.userInfoDict setObject:item forKey:userId];

}

- (void)onceLoadLocalToCache
{

    
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",[User defaultUser].item]];
    
    NSString *tableName= [NSString stringWithFormat:@"%@%@",ChatManageTableName,[User defaultUser].item.userId];
    
    NSArray *resultArray = [operationDB findAllFromType:11 fromeTable:tableName];
    if (resultArray.count >0) {
        for (int i = 0 ; i< resultArray.count; i++) {
            OtherUserModel *model = resultArray[i];
            if (model) {
                [self.userInfoDict setObject:model forKey:model.userId];
            }
        }
    }
    
}

- (void)updataUserMessage:(NSString *)userId clean:(BOOL)isClear
{
    if (!userId) return;
    userId = [NSString stringWithFormat:@"%@",userId];
    
    TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",[User defaultUser].item]];
    
    NSString *tableName= [NSString stringWithFormat:@"%@%@",ChatManageTableName,[User defaultUser].item.userId];
    
    OtherUserModel *tempModel = (OtherUserModel *)[self.userInfoDict objectForKey:userId];
    if (tempModel) {
        tempModel.messagenum ++;
    }else{
        OtherUserModel *insertModel = [[OtherUserModel alloc]init];
        insertModel.userId = userId;
        insertModel.messagenum = 1;
        [operationDB insertObjectObject:insertModel fromeTable:tableName];
        [self.userInfoDict setObject:insertModel forKey:insertModel.userId];
        return;
    }
    
    if (isClear) {
        [operationDB upDataObjectWithSql:[NSString stringWithFormat:@"UPDATE %@ SET messagenum = 0 where userId = %@", tableName,userId]];
        if (tempModel) {
            tempModel.messagenum = 0 ;
        }
    }else{
        NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET messagenum = %d where userId = %@", tableName,tempModel?tempModel.messagenum:0,userId];
        [operationDB upDataObjectWithSql:query];
    }
    
}



@end
