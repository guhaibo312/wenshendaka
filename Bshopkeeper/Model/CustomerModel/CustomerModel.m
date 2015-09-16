//
//  CustomerModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CustomerModel.h"

@implementation CustomerModel

- (id)initWithFMResult:(FMResultSet *)rt
{
    self =  [super initWithFMResult:rt];
    if (self) {
        self.phonenum = [rt stringForColumn:@"phonenum"];
        self.name = [rt stringForColumn:@"name"];
        self.birthYear = [rt stringForColumn:@"birthYear"];
        self.birthMonth = [rt stringForColumn:@"birthMonth"];
        self.birthDay = [rt stringForColumn:@"birthDay"];
        self.gender = [rt stringForColumn:@"gender"];
        self.wxNum = [rt stringForColumn:@"wxNum"];
        self.remark = [rt stringForColumn:@"remark"];
        if ([rt.columnNameToIndexMap.allKeys containsObject:@"respay"]) {
            self.pay = [rt stringForColumn:@"respay"];
        }
        self._id = [rt stringForColumn:@"_id"];
        self.isLunar = [[rt stringForColumn:@"isLunar"]boolValue];
        self.ageStageMin = [rt intForColumn:@"ageStageMin"];
        self.ageStageMax = [rt intForColumn:@"ageStageMax"];
        self.group = [rt stringForColumn:@"groupx"];
        self.qq = [rt stringForColumn:@"qq"];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSDictionary *parm = [UIUtils filtrationEmptyString:dict];
        [self setValuesForKeysWithDictionary:parm];
        self.isLunar = [[parm objectForKey:@"isLunar"] boolValue];
        self.ageStageMax = [[parm objectForKey:@"ageStageMax"]intValue];
        self.ageStageMin = [[parm objectForKey:@"ageStageMin"]intValue];
        
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
    if (self.name) {
        [keys appendString:@"name,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.name]];
    }
    if (self.group) {
        [keys appendString:@"groupx,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.group]];
    }
    
    if (self.isLunar) {
        [keys appendString:@"isLunar,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.isLunar?@"1":@"0"]];
    }
    if (self.ageStageMin) {
        [keys appendString:@"ageStageMin,"];
        [values appendString:[NSString stringWithFormat:@"'%d',",self.ageStageMin]];
    }
    if (self.ageStageMax) {
        [keys appendString:@"ageStageMax,"];
        [values appendString:[NSString stringWithFormat:@"'%d',",self.ageStageMax]];
    }
    if (self.qq) {
        [keys appendString:@"qq,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.qq]];
    }
    
    if (self._id) {
        [keys appendString:@"_id,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self._id]];
    }
    if (self.phonenum) {
        [keys appendString:@"phonenum,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.phonenum]];
    }
    if ([self.birthYear intValue] >0 ) {
        [keys appendString:@"birthYear,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.birthYear]];
    }
    if ([self.birthMonth intValue] >0) {
        [keys appendString:@"birthMonth,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.birthMonth]];
    }
    if ([self.birthDay intValue] >0) {
        [keys appendString:@"birthDay,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.birthDay]];
    }
    
    if ([self.gender integerValue] > -2) {
        [keys appendString:@"gender,"];
        [values appendString:[NSString stringWithFormat:@"'%d',",[self.gender intValue]]];
    }else{
        [keys appendString:@"gender,"];
        [values appendString:[NSString stringWithFormat:@"'-1',"]];
    }
    
    if (self.wxNum && ![self.wxNum isKindOfClass:[NSNull class]]) {
        [keys appendString:@"wxNum,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.wxNum]];
    }
    if (self.remark && ![self.birthMonth isKindOfClass:[NSNull class]]) {
        [keys appendString:@"remark,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.remark]];
    }
    [dict setObject:keys forKey:@"keys"];
    [dict setObject:values forKey:@"values"];
    return dict;
}

- (NSString *)upDataObjectInfo
{
    NSMutableString *string = [NSMutableString string];
    if (self.name) {
        [string appendFormat:@" name = '%@',",self.name];
    }else{
        [string appendFormat:@" name = '',"];
    }
    
    if (self.phonenum) {
        [string appendFormat:@" phonenum = '%@',",self.phonenum];
    }else{
        [string appendFormat:@" phonenum = '',"];
    }
    if (self.qq) {
        [string appendFormat:@" qq = '%@',",self.qq];
    }else{
        [string appendFormat:@" qq = '',"];
    }

    
    if ([self.birthYear integerValue] >0) {
        
        [string appendFormat:@" birthYear = '%@',",self.birthYear];
    }else{
        [string appendFormat:@" birthYear = '0',"];
    }
    
    if ([self.birthMonth integerValue] >0) {
        [string appendFormat:@" birthMonth = '%@',",self.birthMonth];
    }else{
        [string appendFormat:@" birthMonth = '0',"];
    }
    
    if ([self.birthDay integerValue] >0) {
        [string appendFormat:@" birthDay = '%@',",self.birthDay];
    }else{
        [string appendFormat:@" birthDay = '0',"];
    }
    
    [string appendFormat:@" gender = '%d',",[self.gender intValue]?[self.gender intValue]:0];
   
    if (self.wxNum) {
        [string appendFormat:@" wxNum = '%@',",self.wxNum];
    }else{
        [string appendFormat:@" wxNum = '',"];
    }
    
    if (self.remark) {
        [string appendFormat:@" remark = '%@',",self.remark];
    }else{
        [string appendFormat:@" remark = '',"];
    }
    
   
    
    if (self.group) {
        [string appendFormat:@" groupx = '%@',",self.group];
    }else{
        [string appendFormat:@" groupx = '',"];
    }
    
    if (self.isLunar) {
        [string appendFormat:@" isLunar = '%@' ,",@"1"];
    }else{
        [string appendFormat:@" isLunar = '0',"];
    }
    
    if (self.ageStageMin) {
        [string appendFormat:@" ageStageMin = '%d', ",self.ageStageMin];
    }else{
        [string appendFormat:@" ageStageMin = '',"];
    }
    if (self.ageStageMax) {
        [string appendFormat:@" ageStageMax = '%d',",self.ageStageMax];
    }else{
        [string appendFormat:@" ageStageMax = '',"];
    }
    
    if (self._id) {
        [string appendFormat:@" _id = '%@' ",self._id];
        
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
    
    self.name = dict[@"name"];
    self.phonenum = dict[@"phonenum"];
    self.birthYear = dict[@"birthYear"];
    self.birthMonth = dict[@"birthMonth"];
    self.birthDay = dict[@"birthDay"];
    self.gender = dict[@"gender"];
    self.wxNum = dict[@"wxNum"];
    self.remark = dict[@"remark"];
    self.isLunar = [dict[@"isLunar"]boolValue];
    self.ageStageMax = [dict[@"ageStageMax"]intValue];
    self.ageStageMin = [dict[@"ageStageMin"]intValue];
    self.group = dict[@"group"];
    
    if ([[dict allKeys]containsObject:@"qq"]) {
        self.qq = dict[@"qq"];
    }else{
        self.qq = nil;
    }
}

@end
