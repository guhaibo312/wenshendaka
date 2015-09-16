//
//  MessageCenterModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "MessageCenterModel.h"
#import "Configurations.h"

@implementation MessageCenterModel
- (id)initWithFMResult:(FMResultSet *)rt
{
    self =  [super initWithFMResult:rt];
    if (self) {
        self._id = [rt stringForColumn:@"_id"];
        self.userInfoId = [rt stringForColumn:@"userInfoId"];
        self.userInfoName = [rt stringForColumn:@"userInfoName"];
        self.userInfoAvatar = [rt stringForColumn:@"userInfoAvatar"];
        self.createdTime = [rt stringForColumn:@"createdTime"];
        self.own = [rt stringForColumn:@"own"];
        self.type = [rt stringForColumn:@"type"];
        self.url = [rt stringForColumn:@"url"];
        self.content = [rt stringForColumn:@"content"];
        self.updateTime = [rt stringForColumn:@"updateTime"];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSDictionary *parm = [UIUtils filtrationEmptyString:dict];
        [self setValuesForKeysWithDictionary:parm];
        
        if (parm[@"userInfo"]) {
            self.userInfoId = [NSString stringWithFormat:@"%@",[parm[@"userInfo"] objectForKey:@"userId"]];
            self.userInfoName = [NSString stringWithFormat:@"%@",[parm[@"userInfo"] objectForKey:@"name"]];
            self.userInfoAvatar = [NSString stringWithFormat:@"%@",[parm[@"userInfo"] objectForKey:@"avatar"]];
        }
        
    }
    return self;
}



- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (NSMutableDictionary *)dataInitialization
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    if (self.userInfoId) {
        [keys appendString:@"userInfoId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.userInfoId]];
    }
    if (self.userInfoName ) {
        [keys appendString:@"userInfoName,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.userInfoName]];
    }
    
    if (self.userInfoAvatar ) {
        [keys appendString:@"userInfoAvatar,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.userInfoAvatar]];
    }
    
    if (self.createdTime ) {
        [keys appendString:@"createdTime,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.createdTime]];
    }
    
    if (self.own ) {
        [keys appendString:@"own,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.own]];
    }
    if (self.type ) {
        [keys appendString:@"type,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.type]];
    }
    if (self.url ) {
        [keys appendString:@"url,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.url]];
    }
    if (self.content ) {
        [keys appendString:@"content,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.content]];
    }
    if (self.updateTime ) {
        [keys appendString:@"updateTime,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.updateTime]];
    }
    
    if (self._id) {
        [keys appendString:@"_id,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self._id]];
    }
    
    [dict setObject:keys forKey:@"keys"];
    [dict setObject:values forKey:@"values"];
    return dict;
}

- (NSString *)upDataObjectInfo
{
    NSMutableString *string = [NSMutableString string];
    if (self.userInfoId) {
        [string appendFormat:@" userInfoId = '%@',",self.userInfoId];
    }else{
        [string appendFormat:@" userInfoId = '%@',",@""];
    }
    
    if (self.userInfoName) {
        [string appendFormat:@" userInfoName = '%@',",self.userInfoName];
    }else{
        [string appendFormat:@" userInfoName = '%@',",@""];
    }
    
    if (self.userInfoAvatar) {
        [string appendFormat:@" userInfoAvatar = '%@',",self.userInfoAvatar];
    }else{
        [string appendFormat:@" userInfoAvatar = '%@',",@""];
    }
    
    if (self.createdTime) {
        [string appendFormat:@" createdTime = '%@',",self.createdTime];
    }else{
        [string appendFormat:@" createdTime = '%@',",@""];
    }
    
    if (self.own) {
        [string appendFormat:@" own = '%@',",self.own];
    }else{
        [string appendFormat:@" own = '%@',",@""];
    }
    
    if (self.type) {
        [string appendFormat:@" type = '%@',",self.type];
    }else{
        [string appendFormat:@" type = '%@',",@""];
    }
    
    if (self.url) {
        [string appendFormat:@" url = '%@',",self.url];
    }else{
        [string appendFormat:@" url = '%@',",@""];
    }
    
    if (self.content) {
        [string appendFormat:@" content = '%@',",self.content];
    }else{
        [string appendFormat:@" content = '%@',",@""];
    }
    
    if (self.updateTime) {
        [string appendFormat:@" updateTime = '%@',",self.updateTime];
    }else{
        [string appendFormat:@" updateTime = '%@',",@""];
        
    }
    if (self._id) {
        [string appendFormat:@" _id = '%@'",self._id];
        
    }
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ WHERE _id = '%@'",string,self._id];
    return resultStr;
}
//更新操作

- (void)upDataFromDict:(NSDictionary *)dict
{
    if (!dict){
        return;
    }
    NSDictionary *parm = [UIUtils filtrationEmptyString:dict];
    [self setValuesForKeysWithDictionary:parm];
    
    if (parm[@"userInfo"]) {
        self.userInfoId = [NSString stringWithFormat:@"%@",[parm[@"userInfo"] objectForKey:@"userId"]];
        self.userInfoName = [NSString stringWithFormat:@"%@",[parm[@"userInfo"] objectForKey:@"name"]];
        self.userInfoAvatar = [NSString stringWithFormat:@"%@",[parm[@"userInfo"] objectForKey:@"avatar"]];
    }
}


@end
