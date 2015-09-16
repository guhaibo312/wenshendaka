//
//  OtherUserModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OtherUserModel.h"
#import "Configurations.h"

@implementation OtherUserModel

- (id)initWithFMResult:(FMResultSet *)rt
{
    self =  [super initWithFMResult:rt];
    if (self) {
        self.userId = [rt stringForColumn:@"userId"];
        self.avatar = [rt stringForColumn:@"avatar"];
        self.nickname= [rt stringForColumn:@"nickname"];
        self.messagenum = [rt intForColumn:@"messagenum"];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSDictionary *parm = [UIUtils filtrationEmptyString:dict];
        [self setValuesForKeysWithDictionary:parm];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (NSMutableDictionary *)dataInitialization
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    if (self.nickname) {
        [keys appendString:@"nickname,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.nickname]];
    }
    if (self.avatar) {
        [keys appendString:@"avatar,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.avatar]];
    }
    
    if (self.userId) {
        [keys appendString:@"userid,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.userId]];
    }
    if (self.messagenum >0) {
        [keys appendString:@"messagenum,"];
        [values appendString:[NSString stringWithFormat:@"'%d',",self.messagenum]];
    }else{
        [keys appendString:@"messagenum,"];
        [values appendString:[NSString stringWithFormat:@"'0',"]];
    }
    
    [dict setObject:keys forKey:@"keys"];
    [dict setObject:values forKey:@"values"];
    return dict;
}

- (NSString *)upDataObjectInfo
{
    NSMutableString *string = [NSMutableString string];
    if (self.nickname) {
        [string appendFormat:@" nickname = '%@',",self.nickname];
    }else{
        [string appendFormat:@" nickname = '%@',",@""];
    }
    
    if (self.avatar) {
        [string appendFormat:@" avatar = '%@',",self.avatar];
    }else {
        [string appendFormat:@" avatar = '%@',",@""];
    }

    
    if (self.messagenum>0) {
        [string appendFormat:@" messagenum = '%d',",self.messagenum];
    }
    
    if (self.userId) {
        [string appendFormat:@" userid = '%@'",self.userId];
    }

    NSString *resultStr = [NSString stringWithFormat:@"%@ WHERE userId = '%@'",string,self.userId];
    return resultStr;
}

- (void)upDataFromDict:(NSDictionary *)dict{
    
    NSDictionary *parm = [UIUtils filtrationEmptyString:dict];
    [self setValuesForKeysWithDictionary:parm];}

@end
