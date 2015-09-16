//
//  OrderModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/23.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderModel.h"
#import "Configurations.h"

@implementation OrderModel
- (id)initWithFMResult:(FMResultSet *)rt
{
    self =  [super initWithFMResult:rt];
    if (self) {
        self.orderStatus = [rt stringForColumn:@"orderStatus"];
        self.orderFrom = [rt stringForColumn:@"orderFrom"];
        self.orderTime = [rt stringForColumn:@"orderTime"];
        self.servicePlace = [rt stringForColumn:@"servicePlace"];
        self.createdTime = [rt stringForColumn:@"createdTime"];
        self.customerInfoName = [rt stringForColumn:@"customerInfoName"];
        self.customerInfoId = [rt stringForColumn:@"customerInfoId"];
        self.commodityInfoId  = [rt stringForColumn:@"commodityInfoId"];
        self.serviceType = [rt stringForColumn:@"serviceType"];
        self.remark = [rt stringForColumn:@"remark"];
        self._id = [rt stringForColumn:@"_id"];
        self.orderAddress = [rt stringForColumn:@"orderAddress"];
        self.custoemrInfoWxNum = [rt stringForColumn:@"customerInfoWxNum"];
        self.customerInfoGender = [rt stringForColumn:@"customerInfoGender"];
        self.customerInfoPhonenum = [rt stringForColumn:@"customerInfoPhonenum"];
        self.updateTime = [rt stringForColumn:@"updateTime"];
        
        if ([rt.columnNameToIndexMap.allKeys containsObject:@"resultname"]) {
            self.resultname = [rt stringForColumn:@"resultname"];
        }
        if ([rt.columnNameToIndexMap.allKeys containsObject:@"resultphone"]) {
            self.resultphone = [rt stringForColumn:@"resultphone"];
        }
        if ([rt.columnNameToIndexMap.allKeys containsObject:@"imgUrl"]) {
            self.imgUrl = [rt stringForColumn:@"imgUrl"];
        }
    
        self.billId = [rt stringForColumn:@"billId"];
        self.recycle = [rt intForColumn:@"recycle"];
        self.refunded = [rt intForColumn:@"refunded"];
        self.deposit = [rt intForColumn:@"deposit"];
        
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSDictionary *parm = [UIUtils filtrationEmptyString:dict];
        [self setValuesForKeysWithDictionary:parm];
        if (parm[@"commodityInfo"]) {
            self.commodityInfoId = [NSString stringWithFormat:@"%@",[parm[@"commodityInfo"] objectForKey:@"_id"]];
        }
        if (parm[@"customerInfo"]) {
            self.customerInfoName = [parm[@"customerInfo"]objectForKey:@"name"];
            self.customerInfoId = [parm[@"customerInfo"]objectForKey:@"_id"];
            self.customerInfoPhonenum = [parm[@"customerInfo"] objectForKey:@"phonenum"];
            self.customerInfoGender = [parm[@"customerInfo"] objectForKey:@"gender"];
            self.custoemrInfoWxNum = [parm[@"customerInfo"] objectForKey:@"wxNum"];
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
    if (self.remark) {
        [keys appendString:@"remark,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.remark]];
    }
    if (self.createdTime) {
        [keys appendString:@"createdTime,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.createdTime]];
    }
    if (self.updateTime) {
        [keys appendString:@"updateTime,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.updateTime]];
    }else{
        if (self.createdTime) {
            [keys appendString:@"updateTime,"];
            [values appendString:[NSString stringWithFormat:@"'%@',",self.createdTime]];
        }
    }
    
    [keys appendString:@"deposit,"];
    
    if (self.deposit) {
        [values appendString:[NSString stringWithFormat:@"'%d',",self.deposit]];
    }else{
        [values appendString:[NSString stringWithFormat:@"'0',"]];

    }

    if (_refunded) {
        [keys appendString:@"refunded,"];
        [values appendString:[NSString stringWithFormat:@"'%d',",_refunded]];
    }
    if (_recycle == 0 || !_recycle) {
        [keys appendString:@"recycle,"];
        [values appendString:[NSString stringWithFormat:@"'0',"]];
    }else{
        [keys appendString:@"recycle,"];
        [values appendString:[NSString stringWithFormat:@"'%d',",_recycle]];
    }
    if (_billId) {
        [keys appendString:@"billId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",_billId]];
    }
    
    
    if (self.orderFrom) {
        [keys appendString:@"orderFrom,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.orderFrom]];
    }
    if (self._id) {
        [keys appendString:@"_id,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self._id]];
    }
    if (self.orderStatus) {
        [keys appendString:@"orderStatus,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.orderStatus]];
    }
    if (self.servicePlace) {
        [keys appendString:@"servicePlace,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.servicePlace]];
    }
    if (self.orderAddress) {
        [keys appendString:@"orderAddress,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.orderAddress]];
    }
    if (self.serviceType && ![self.serviceType isKindOfClass:[NSNull class]]) {
        [keys appendString:@"serviceType,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.serviceType]];
    }
    if (self.orderTime) {
        [keys appendString:@"orderTime,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.orderTime]];
    }
    
    if (self.commodityInfoId) {
        [keys appendString:@"commodityInfoId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.commodityInfoId]];
    }
    if (self.customerInfoId ) {
        [keys appendString:@"customerInfoId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.customerInfoId]];
        [keys appendString:@"customerInfoName,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",@""]];
        [keys appendString:@"customerInfoPhonenum,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",@""]];
        [keys appendString:@"customerInfoGender,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",@""]];
        [keys appendString:@"customerInfoWxNum,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",@""]];
        
    }else{
        [keys appendString:@"customerInfoId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",@""]];
        
        if (self.customerInfoName) {
            [keys appendString:@"customerInfoName,"];
            [values appendString:[NSString stringWithFormat:@"'%@',",self.customerInfoName]];
        }
        if (self.customerInfoPhonenum) {
            [keys appendString:@"customerInfoPhonenum,"];
            [values appendString:[NSString stringWithFormat:@"'%@',",self.customerInfoPhonenum]];
        }
        if (self.customerInfoGender) {
            [keys appendString:@"customerInfoGender,"];
            [values appendString:[NSString stringWithFormat:@"'%@',",self.customerInfoGender]];
        }
        if (self.custoemrInfoWxNum) {
            [keys appendString:@"customerInfoWxNum,"];
            [values appendString:[NSString stringWithFormat:@"'%@',",self.custoemrInfoWxNum]];
        }

    }
    
    [dict setObject:keys forKey:@"keys"];
    [dict setObject:values forKey:@"values"];
    return dict;
}

- (NSString *)upDataObjectInfo
{
    NSMutableString *string = [NSMutableString string];
    if (self.servicePlace) {
        [string appendFormat:@" servicePlace = '%@',",self.servicePlace];
    }else{
        [string appendFormat:@" servicePlace = '%@',",@""];
    }
    
    if (self.serviceType) {
        [string appendFormat:@" serviceType = '%@',",self.serviceType];
    }else{
        [string appendFormat:@" serviceType = '%@',",@""];
    }
    
    if (self.deposit) {
        [string appendFormat:@" deposit = '%d',",self.deposit];
    }else{
        [string appendFormat:@" deposit = '%@',",@"0"];
    }

    
    if (self.orderTime) {
        [string appendFormat:@" orderTime = '%@',",self.orderTime];
    }
    
    
    if (self.orderAddress) {
        [string appendFormat:@" orderAddress = '%@',",self.orderAddress];
    }else{
        [string appendFormat:@" orderAddress = '%@',",@""];

    }
    if (_refunded ==0 || !_refunded) {
        [string appendFormat:@" refunded = '0',"];
    }else if (_refunded == -1){
        [string appendFormat:@" refunded = '-1',"];
    }else{
        [string appendFormat:@" refunded = '%d',",_refunded];
    }
    
    if (_recycle== 0 || !_recycle) {
        [string appendFormat:@" recycle = '0',"];
    }else{
        [string appendFormat:@" recycle = '%d',",_recycle];
    }
    
    if (_billId) {
        [string appendFormat:@" billId = '%@',",_billId];
    }else{
        [string appendFormat:@" billId = '%@',",@""];
    }

    
    
    if (self.orderFrom) {
        [string appendFormat:@" orderFrom = '%@',",self.orderFrom];

    }else{
        [string appendFormat:@" orderFrom = '%@',",@""];
    }
    
    if (self.commodityInfoId) {
        [string appendFormat:@" commodityInfoId = '%@',",self.commodityInfoId];
    }else{
        [string appendFormat:@" commodityInfoId = '%@',",@""];

    }
    
    if (self.customerInfoId) {
        [string appendFormat:@" customerInfoId = '%@',",self.customerInfoId];
    }else {
        [string appendFormat:@" customerInfoId = '%@',",@""];

    }
    
    if (self.orderStatus) {
        [string appendFormat:@" orderStatus = '%@',",self.orderStatus];
    }else{
        [string appendFormat:@" orderStatus = '%@',",@""];
    }
    
    if (self.remark) {
        [string appendFormat:@" remark = '%@',",self.remark];
    }else{
        [string appendFormat:@" remark = '%@',",@""];

    }

    if (self.createdTime) {
        [string appendFormat:@" createdTime = '%@',",self.createdTime];
    }else{
        [string appendFormat:@" createdTime = '%@',",@""];

    }
    
    if (self.updateTime) {
        [string appendFormat:@" updateTime = '%@',",self.updateTime];
    }
    
    if (self.customerInfoName) {
        [string appendFormat:@" customerInfoName = '%@',",self.customerInfoName];
    }else{
        [string appendFormat:@" customerInfoName = '%@',",@""];

    }
    if (self.customerInfoPhonenum) {
        [string appendFormat:@" customerInfoPhonenum = '%@',",self.customerInfoPhonenum];
    }else {
        [string appendFormat:@" customerInfoPhonenum = '%@',",@""];
   
    }
    if (self.customerInfoGender) {
        [string appendFormat:@" customerInfoGender = '%@',",self.customerInfoGender];
    }else{
        [string appendFormat:@" customerInfoGender = '%@',",@""];

    }
    
    if (self.custoemrInfoWxNum) {
        [string appendFormat:@" customerInfoWxNum = '%@',",self.custoemrInfoWxNum];
    }else{
        [string appendFormat:@" customerInfoWxNum = '%@',",@""];

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
    
    self.servicePlace = dict[@"servicePlace"];
    self.orderAddress = dict[@"orderAddress"];
    self.orderTime= dict[@"orderTime"];
    self.orderStatus = dict[@"orderStatus"];
    self.orderFrom = dict[@"orderFrom"];
    self.updateTime = dict[@"updateTime"];
    
    if ([dict objectForKey:@"customerInfo"]) {
        NSDictionary *temp = [[dict objectForKey:@"customerInfo"]JSONValue];
        self.customerInfoName = [temp objectForKey:@"name"];
        self.customerInfoId = [temp objectForKey:@"_id"];
        self.custoemrInfoWxNum = [temp objectForKey:@"wxNum"];
        self.customerInfoGender = [temp objectForKey:@"gender"];
        self.customerInfoPhonenum = [temp objectForKey:@"phonenum"];

    }
    if (dict[@"commodityInfo"]) {
        self.commodityInfoId = [dict[@"commodityInfo"] objectForKey:@"_id"] ;
    }else{
        self.commodityInfoId = @"";
    }
    self.serviceType = dict[@"serviceType"];
    self.remark = dict[@"remark"];
    self.createdTime = dict[@"createdTime"];
    self.refunded = [dict[@"refunded"]intValue];
    self.recycle = [dict[@"recycle"]integerValue];
    self.billId = dict[@"billId"];
    if (dict[@"deposit"]) {
        self.deposit = [dict[@"deposit"] integerValue];
    }else{
        self.deposit = 0;
    }
}

@end
