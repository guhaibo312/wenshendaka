//
//  JWChatMessageModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/26.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatMessageModel.h"
#import "Configurations.h"

@implementation JWChatMessageModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}



- (id)initWithFMResult:(FMResultSet *)rt
{
    self =  [super initWithFMResult:rt];
    if (self) {
        self._id = [rt stringForColumn:@"_id"];
        self.title = [rt stringForColumn:@"title"];
        self.text = [rt stringForColumn:@"text"];
        if ([rt stringForColumn:@"images"]) {
            self.images = [[rt stringForColumn:@"images"]JSONValue];
        }
        self.url = [rt stringForColumn:@"url"];
        self.fromId = [rt stringForColumn:@"fromId"];
        self.otherId = [rt stringForColumn:@"otherId"];
        self.time = [rt stringForColumn:@"time"];
        self.type = [rt intForColumn:@"type"];
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


- (NSMutableDictionary *)dataInitialization
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableString * keys = [NSMutableString stringWithFormat:@" ("];
    NSMutableString * values = [NSMutableString stringWithFormat:@" ( "];
    if (self.title) {
        [keys appendString:@"title,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.title]];
    }
    if (self.text ) {
        [keys appendString:@"text,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.text]];
    }
    
    if (self.images ) {
        [keys appendString:@"images,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",[self.images JSONRepresentation]]];
    }
    
    if (self.url ) {
        [keys appendString:@"url,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.url]];
    }
    
    if (self.fromId ) {
        [keys appendString:@"fromId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.fromId]];
    }
    if (self.type ) {
        [keys appendString:@"type,"];
        [values appendString:[NSString stringWithFormat:@"'%d',",self.type]];
    }
   
    if (self.otherId ) {
        [keys appendString:@"otherId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.otherId]];
    }
    if (self.time ) {
        [keys appendString:@"time,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.time]];
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
    if (self.title) {
        [string appendFormat:@" title = '%@',",self.title];
    }else{
        [string appendFormat:@" title = '%@',",@""];
    }
    
    if (self.text) {
        [string appendFormat:@" text = '%@',",self.text];
    }else{
        [string appendFormat:@" text = '%@',",@""];
    }
    
    if (self.images) {
        [string appendFormat:@" images = '%@',",[self.images JSONRepresentation]];
    }else{
        [string appendFormat:@" images = '%@',",@""];
    }
    
    if (self.fromId) {
        [string appendFormat:@" fromId = '%@',",self.fromId];
    }else{
        [string appendFormat:@" fromId = '%@',",@""];
    }
    
    if (self.type) {
        [string appendFormat:@" type = '%d',",self.type];
    }else{
        [string appendFormat:@" type = '%@',",@""];
    }
    
    if (self.url) {
        [string appendFormat:@" url = '%@',",self.url];
    }else{
        [string appendFormat:@" url = '%@',",@""];
    }
    
    if (self.otherId) {
        [string appendFormat:@" otherId = '%@',",self.otherId];
    }else{
        [string appendFormat:@" otherId = '%@',",@""];
    }
    
    if (self.time) {
        [string appendFormat:@" time = '%@',",self.time];
    }else{
        [string appendFormat:@" time = '%@',",@""];
    }
    
    if (self._id) {
        [string appendFormat:@" _id = '%@'",self._id];
    }
    
    NSString *resultStr = [NSString stringWithFormat:@"%@ WHERE _id = '%@'",string,self._id];
    return resultStr;
}

- (void)upDataFromDict:(NSDictionary *)dict
{
    if (!dict){
        return;
    }
    NSDictionary *parm = [UIUtils filtrationEmptyString:dict];
    [self setValuesForKeysWithDictionary:parm];
}

@end
