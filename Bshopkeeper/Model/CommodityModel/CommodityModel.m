//
//  CommodityModel.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CommodityModel.h"

@implementation CommodityModel

- (id)initWithFMResult:(FMResultSet *)rt
{
    self =  [super initWithFMResult:rt];
    if (self) {
        self._id = [rt stringForColumn:@"_id"];
        self.title = [rt stringForColumn:@"title"];
        self.des = [rt stringForColumn:@"des"];
        self.createdTime = [rt stringForColumn:@"createdTime"];
        if ([rt stringForColumn:@"images"]) {
            self.images = [NSArray arrayWithArray:[[rt stringForColumn:@"images"]JSONValue]];
        }
        self.storeId = [rt stringForColumn:@"storeId"];
        self.price = [rt stringForColumn:@"price"];
        self.top = [rt stringForColumn:@"top"];
        self.show  = [rt stringForColumn:@"show"];
        self.serviceInStore = [rt stringForColumn:@"serviceInStore"];
        self.serviceToHome = [rt stringForColumn:@"serviceToHome"];
        self.updataTime = [rt stringForColumn:@"updataTime"];
        self.saleCount = [rt stringForColumn:@"saleCount"];
        if ([[rt stringForColumn:@"priceList"] isNonEmpty]) {
            self.priceList = [NSArray arrayWithArray:[[rt stringForColumn:@"priceList"]JSONValue]];
        }
        self.clerks = [rt stringForColumn:@"clerks"];
        self.itag = [rt stringForColumn:@"itag"];
        self.category = [rt stringForColumn:@"category"];
        self.quantifier = [rt stringForColumn:@"quantifier"];
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
        if (parm[@"description"]) {
            self.des = parm[@"description"];
        }
        if (parm[@"images"]) {
            self.images = [NSArray arrayWithArray:parm[@"images"]];
        }
        if (parm[@"priceList"]) {
            self.priceList = [NSArray arrayWithArray:parm[@"priceList"]];
        }
        if (parm[@"clerks"]) {
            self.clerks = [parm[@"clerks"] JSONString];
        }
        if (parm[@"category"]) {
            self.clerks = [parm[@"category"] JSONString];
        }
        if (parm[@"tag"]) {
            self.itag = parm[@"tag"];
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
    if (self.quantifier) {
        [keys appendString:@"quantifier,"];
        [values appendFormat:@"'%@',",self.quantifier];
    }
    if (self.storeId ) {
        [keys appendString:@"storeId,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.storeId]];
    }
    if (self.price ) {
        [keys appendString:@"price,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.price]];
    }
    if (self.deposit) {
        [keys appendString:@"deposit,"];
        [values appendString:[NSString stringWithFormat:@"'%d',",self.deposit]];
    }else{
        [keys appendString:@"deposit,"];
        [values appendString:[NSString stringWithFormat:@"'0',"]];
    }
    
    if (self.top) {
        [keys appendString:@"top,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.top]];
    }
    if (self.show) {
        [keys appendString:@"show,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.show]];
    }
    if (self.serviceInStore) {
        [keys appendString:@"serviceInStore,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.serviceInStore]];
    }
    if (self.serviceToHome) {
        [keys appendString:@"serviceToHome,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.serviceToHome]];
    }
    if (self.updataTime) {
        [keys appendString:@"updataTime,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.updataTime]];
    }
    if (self.saleCount) {
        [keys appendString:@"saleCount,"];
        [values appendString:[NSString stringWithFormat:@"'%@',",self.saleCount]];
    }
    if (self.priceList) {
        [keys appendString:@"priceList,"];
        [values appendFormat:@"'%@',",[self.priceList JSONString]];
    }
    if (self.clerks) {
        [keys appendString:@"clerks,"];
        [values appendFormat:@"'%@',",self.clerks];
    }
    if (self.itag) {
        [keys appendString:@"itag,"];
        [values appendFormat:@"'%@',",self.itag];
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
    
    if (self.des) {
        [string appendFormat:@" des = '%@',",self.des];
    }else{
        [string appendFormat:@" des = '%@',",@""];
    }
    if (self.itag) {
        [string appendFormat:@" itag = '%@',",self.itag];
    }else{
        [string appendFormat:@" itag = '%@',",@""];
    }
    if (self.clerks) {
        [string appendFormat:@" clerks = '%@',",self.clerks];
    }else{
        [string appendFormat:@" clerks = '%@',",@""];
    }
    
    if (self.category) {
        [string appendFormat:@" category = '%@',",self.category];
    }
    
    if (self.createdTime) {
        [string appendFormat:@" createdTime = '%@',",self.createdTime];
    }else{
        [string appendFormat:@" createdTime = '%@',",@""];
    }
    
    if (self.storeId) {
        [string appendFormat:@" storeId = '%@',",self.storeId];
    }else{
        [string appendFormat:@" storeId = '%@',",@""];
    }
    if (self.price) {
        [string appendFormat:@" price = '%@',",self.price];
    }else{
        [string appendFormat:@" price = '%@',",@""];
    }
    if (self.deposit) {
        [string appendFormat:@" deposit = '%ld',",(long)_deposit];

    }else{
        [string appendFormat:@" deposit = '0',"];
    }

    if (self.top) {
        [string appendFormat:@" top = '%@',",self.top];
    }else{
        [string appendFormat:@" top = '%@',",@""];
    }
    if (self.quantifier) {
        [string appendFormat:@" quantifier = '%@',",self.quantifier];
    }else{
        [string appendFormat:@" quantifier = '%@',",@""];
    }
    
    if (self.show) {
        [string appendFormat:@" show = '%@',",self.show];
    }else{
        [string appendFormat:@" show = '%@',",@""];
    }
    
    if (self.serviceInStore) {
        [string appendFormat:@" serviceInStore = '%@',",self.serviceInStore];
    }else{
        [string appendFormat:@" serviceInStore = '%@',",@""];
    }
    
    if (self.serviceToHome) {
        [string appendFormat:@" serviceToHome = '%@',",self.serviceToHome];
    }else{
        [string appendFormat:@" serviceToHome = '%@',",@""];
    }
    
    if (self.updataTime) {
        [string appendFormat:@" updataTime = '%@'",self.updataTime];
    }else{
        [string appendFormat:@" updataTime = '%@',",@""];
    }
    
    if (self.saleCount) {
        [string appendFormat:@" saleCount = '%@',",self.saleCount];
    }else{
        [string appendFormat:@" saleCount = '%@',",@""];
    }
    
    if (self.images) {
        [string appendFormat:@" images = '%@',",[self.images JSONString]];
    }else{
        [string appendFormat:@" images = '%@',",@""];
    }
    
    if (self.priceList) {
        [string appendFormat:@" priceList = '%@',",[self.priceList JSONString]];
    }else{
        [string appendFormat:@" priceList = '%@',",@""];
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
    if (parm[@"description"]) {
        self.des = parm[@"description"];
    }
    if (parm[@"images"]) {
        self.images = [NSArray arrayWithArray:parm[@"images"]];
    }
    if (parm[@"priceList"]) {
        self.priceList = [NSArray arrayWithArray:parm[@"priceList"]];
    }
    if (parm[@"clerks"]) {
        self.clerks = [parm[@"clerks"] JSONString];
    }
    if (parm[@"category"]) {
        self.clerks = [parm[@"category"] JSONString];
    }
    if (parm[@"tag"]) {
        self.itag = parm[@"tag"];
    }
    if ([parm.allKeys containsObject:@"deposit"]) {
        _deposit = [parm[@"deposit"] integerValue];
    }
    return;
    
}

/**计算作品集的高度
 */
- (void)judgeCommodityListHeight
{
    CGSize firstImgSize = CGSizeMake(SCREENWIDTH/2-12,(SCREENWIDTH/2-12)/2*3 );
    if (self.images) {
        NSString *firstImgUrl = [self.images firstObject];
        firstImgSize = [firstImgUrl imageUrlSizeWithTheOriginalSize:firstImgSize];
    }

    if (!isnan(firstImgSize.height)) {
        _commodityListHeight = firstImgSize.height+52;
    }else{
        _commodityListHeight = (SCREENWIDTH/2-12)/2*3+52;
    }
    
}

@end
