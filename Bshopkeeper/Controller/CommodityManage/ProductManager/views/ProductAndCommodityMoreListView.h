//
//  ProductAndCommodityMoreListView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductAndCommodityMoreListView : UIView
{
    UITableView *table;
}

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller model:(id)model;


- (void)show;

- (void)disMiss;

@end
