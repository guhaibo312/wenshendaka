//
//  CommodityTagView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  标签选择的view

#import <UIKit/UIKit.h>

@interface CommodityTagView : UIView

@property (nonatomic, assign) int tagCount;
/*
 *@根据数据初始化
 **/
- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSDictionary *)sourceDict andCurrentSelectedArray:(NSMutableArray *)selectedArray withLeftColor:(UIColor *)color;


/*
 *检索数据
 */
- (NSArray *)checkingDataFromeArray:(NSArray *)array;


/*
 *检索标签是否存在
 */
- (BOOL)WhetherTheLabelAlreadyExists:(NSString *)fromStr;


/*
 *新建标签
 */
- (void)addTag:(NSString *)fromStr;

/*
 *获取所有标签
 */
- (NSArray *)getAllTitles;

/*设置选中
 */
- (void)setSelected:(NSString *)tagStr;

@end
