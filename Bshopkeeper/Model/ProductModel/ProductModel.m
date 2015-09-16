//
//  ProductModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/30.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  作品管理

#import "ProductModel.h"
#import "Configurations.h"
#import "JudgeMethods.h"
#import "NSString+BG.h"


@implementation ProductModel

- (id)initWithFMResult:(FMResultSet *)rt
{
    self =  [super initWithFMResult:rt];
    if (self) {
        self._id = [rt stringForColumn:@"_id"];
        self.title = [rt stringForColumn:@"title"];
        self.des = [rt stringForColumn:@"des"];
        self.createdTime = [rt stringForColumn:@"createdTime"];
        self.category = [rt stringForColumn:@"category"];
        self.itag = [rt stringForColumn:@"itag"];
        if ([rt stringForColumn:@"images"]) {
            if ([NSObject nulldata:[rt stringForColumn:@"images"] ]) {
                self.images = [NSArray arrayWithArray:[[rt stringForColumn:@"images"]JSONValue]];
            }
        }
        self.customerInfoId = [rt stringForColumn:@"customerInfoId"];
        self.share = [rt intForColumn:@"share"];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        NSDictionary *parm = [UIUtils filtrationEmptyString:dict];
        [self setValuesForKeysWithDictionary:parm];
        if (parm[@"description"]) {
            self.des = parm[@"description"];
        }
        if (parm[@"images"]) {
            self.images = [NSArray arrayWithArray:parm[@"images"]];
        }
        self.itag = [dict objectForKey:@"tag"];
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
    if (self.title) {
        [keys appendString:@"title,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.title]];
    }
    if (self.createdTime) {
        [keys appendString:@"createdTime,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.createdTime]];
    }
    if (self.category) {
        [keys appendString:@"category,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.category]];
    }
    if (self.des) {
        [keys appendString:@"des,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.des]];
    }
    if (self.images) {
        [keys appendString:@"images,"];
        [values appendFormat:@"'%@',",[self.images JSONString]];
    }
    if (self.customerInfoId ) {
        [keys appendString:@"customerInfoId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.customerInfoId]];
    }
    if (self.itag) {
        [keys appendString:@"itag,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.itag]];
    }
    
    if (!self.share) {
        [keys appendString:@"share,"];
        [values appendString:[NSString stringWithFormat:@"'0',"]];
        
    }else{
        [keys appendString:@"share,"];
        [values appendString:[NSString stringWithFormat:@"'1',"]];
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
    if (self.itag) {
        [string appendFormat:@" itag = '%@',",self.itag];
    }else {
        [string appendFormat:@" itag = '%@',",@""];

    }
    
    if (self.des) {
        [string appendFormat:@" des = '%@',",self.des];
    }else{
        [string appendFormat:@" des = '%@',",@""];
    }
    if (self.category) {
        [string appendFormat:@" category = '%@',",self.category];
    }
    
    if (self.createdTime) {
        [string appendFormat:@" createdTime = '%@',",self.createdTime];
    }else{
        [string appendFormat:@" createdTime = '%@',",@""];
    }
    
    
    if (self.customerInfoId) {
        [string appendFormat:@" customerInfoId = '%@',",self.customerInfoId];
    }else{
        [string appendFormat:@" customerInfoId = '%@',",@""];
    }
    
    
    if (self.images) {
        [string appendFormat:@" images = '%@',",[self.images JSONString]];
    }else{
        [string appendFormat:@" images = '%@',",@""];
    }
    
    if (!self.share) {
        [string appendFormat:@" share = '0',"];

    }else{
        [string appendFormat:@" share = '1',"];

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
    self.category = dict[@"category"];
    self.title = dict[@"title"];
    self.des= dict[@"description"];
    self.createdTime = dict[@"createdTime"];
    self.images = dict[@"images"];
    if (dict[@"customerInfo"]) {
        self.customerInfoId = [dict[@"customerInfo"] objectForKey:@"_id"];
    }
    self._id = dict[@"_id"];
    self.itag = dict [@"tag"];
    if ([dict.allKeys containsObject:@"share"]) {
        self.share = [dict[@"share"]intValue];
    }else{
        self.share = 0;
    }
}

/**计算作品集的高度
 */
- (void)judgeProductHeight
{
    CGSize firstImgSize = CGSizeMake(SCREENWIDTH/2-12,(SCREENWIDTH/2-12)/2*3 );
    if (self.images) {
        NSString *firstImgUrl = [self.images firstObject];
        firstImgSize = [firstImgUrl imageUrlSizeWithTheOriginalSize:firstImgSize];
    }
    
    if (!isnan(firstImgSize.height)) {
        _productCollectionListHeight = firstImgSize.height+26;
    }else{
        _productCollectionListHeight = (SCREENWIDTH/2-12)/2*3 +26;
    }
}
@end
