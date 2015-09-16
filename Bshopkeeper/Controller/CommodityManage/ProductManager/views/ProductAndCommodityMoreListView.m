//
//  ProductAndCommodityMoreListView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ProductAndCommodityMoreListView.h"
#import "OrderRecycleViewController.h"
#import "OrderRevenueViewController.h"
#import "Configurations.h"
#import "OrderModel.h"



@interface ProductAndCommodityMoreListView ()<UITableViewDataSource,UITableViewDelegate>

{
    UIButton *backBtn;
    NSMutableArray *titleArray;
    float tableHeight;
}

@property (nonatomic, assign) UIViewController * supViewController;
@property (nonatomic, assign) id sourceObject;
@end

@implementation ProductAndCommodityMoreListView

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller model:(id)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        backBtn = [[UIButton alloc]initWithFrame:self.bounds];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        tableHeight = 88;
        if (!model) {
            titleArray = [NSMutableArray arrayWithObjects:@"收入",@"回收站",nil];
        }else{
            titleArray = [NSMutableArray array];
            
            if ([model isKindOfClass:[OrderModel class]]) {
                OrderModel *resultModel = (OrderModel *)model;
                int code = [resultModel.orderStatus intValue];
                if (code == 7) {
                    
                    titleArray = [NSMutableArray arrayWithObjects:@"接受",@"编辑",@"拒绝", nil];
                    
                }else if (code == 10 || code == 11){
                    titleArray = [NSMutableArray arrayWithObjects:@"完成消费",@"编辑",@"取消预约", nil];
    
                }else {
//                    if (code == 14 || code == 2 || code == 20 || code == 1)
                    titleArray = [NSMutableArray arrayWithObjects:@"编辑",@"放入回收站",nil];
                }
               
            }
            
          
            tableHeight = 44*titleArray.count;

        }
        _supViewController = controller;
        _sourceObject = model;
        table = [[UITableView alloc]initWithFrame:CGRectMake(self.width-120, -tableHeight, 120, tableHeight)];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = [UIColor whiteColor];
        table.scrollEnabled = NO;
        [self addSubview:table];
        self.tag = 88;        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:table.bounds];
        
        table.layer.masksToBounds = NO;
        table.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        table.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        table.layer.shadowOpacity = 0.9f;
        
        table.layer.shadowPath = shadowPath.CGPath;
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.2];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentitier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentitier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = titleArray[indexPath.row];
    return cell;
}

- (void)show
{
    if (self) {
        UIView *haveView = [_supViewController.view viewWithTag:88];
        if (haveView) {
            [haveView removeFromSuperview];
        }
        [_supViewController.view addSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            table.frame = CGRectMake(self.width-120, 0, 120, tableHeight);
        } completion:^(BOOL finished) {
            if (finished) {
                table.frame = CGRectMake(self.width-120, 0, 120,tableHeight);
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_supViewController) return;
    if (!_sourceObject) {
        if (indexPath.row == 0) {
            OrderRevenueViewController *orderRevenueVC = [[OrderRevenueViewController alloc]init];
            [_supViewController.navigationController pushViewController:orderRevenueVC animated:YES];
            return;
        }else{
            OrderRecycleViewController *orderRecycleVC = [[OrderRecycleViewController alloc]init];
            [_supViewController.navigationController pushViewController:orderRecycleVC animated:YES];
            return;
        }
    }else{
        if (_supViewController && [_supViewController respondsToSelector:@selector(clickoperationAction:)]) {
            [_supViewController performSelector:@selector(clickoperationAction:) withObject:@(indexPath.row)];
        }
        [self disMiss];
    }
    
    
}

- (void)disMiss
{
    if (!self) {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        table.frame = CGRectMake(self.width-120, -tableHeight, 120, tableHeight);
    } completion:^(BOOL finished) {
        if (finished) {
            table.frame = CGRectMake(self.width-120, -tableHeight, 120, tableHeight);
            [self removeFromSuperview];
        }
    }];

}
- (void)dealloc
{
    _supViewController = nil;
    _sourceObject = nil;
}
@end
