//
//  OrderScrollView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BasViewController;

@interface OrderScrollView : UIScrollView
{
    UITableView *firstTableView;
    UITableView *secondTableView;
    UITableView *threeTableView;
    
}

/*
 *初始化
 */
- (instancetype)initWithFrame:(CGRect)frame withController:(BasViewController *)controller;

/*
 *改变内容
 */
- (void)changeDataFromArray:(NSArray *)array;

/**获取是否有数据
 */
- (BOOL)gethaveDataListFrom:(int)type;

/**获取数据的条数
 */
- (int)getDataCount:(int)type;

@end
