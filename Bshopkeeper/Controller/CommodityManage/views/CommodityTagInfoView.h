//
//  CommodityTagInfoView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityTagInfoView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame withSelectdArray:(NSArray *)selectedArray;

// 改变内容
- (void)createdSubViewsFromeArray:(NSArray *)array;

@end
