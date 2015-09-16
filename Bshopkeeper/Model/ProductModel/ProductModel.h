//
//  ProductModel.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/30.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "DataBaseObject.h"

@interface ProductModel : DataBaseObject

@property(nonatomic, strong) NSString * _id;            //商品id
@property(nonatomic, strong) NSString *title;           //title:字符串，商品名，长度<=16
@property(nonatomic, strong) NSString * des;            //description:字符串，介绍，长度<=128
@property(nonatomic, strong) NSString * category;       //所属分类 分类的id
@property(nonatomic, strong) NSString * createdTime;    //createdTime:数字，创建时间戳,
@property(nonatomic, strong) NSArray *images;           //images:字符串数组，图片列表的url
@property(nonatomic, strong) NSString *itag;            //标签
@property(nonatomic, strong) NSString *customerInfoId;  //联系人的id
@property(nonatomic, assign) int share;

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
