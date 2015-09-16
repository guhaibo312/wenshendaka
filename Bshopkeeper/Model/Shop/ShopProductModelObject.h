//
//  ShopProductModelObject.h
//  Bshopkeeper
//
//  Created by jinwei on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"

@interface ShopProductModelObject : DataBaseObject

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString * createdTime ;

@property (nonatomic, strong) NSArray *clerks;

@property (nonatomic, strong) NSString *itag;

@property (nonatomic, strong) NSArray *images;


@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) int storeId;


@property (nonatomic, assign) int share;

@property (nonatomic, assign)float productCollectionListHeight;

//初始化
- (id)initWithDictionary:(NSDictionary *)dict;

/*
 *更新操作
 **/
- (void)upDataFromDict:(NSDictionary *)dict;

/**计算作品集的高度
 */
- (void)judgeProductHeight;


@end
