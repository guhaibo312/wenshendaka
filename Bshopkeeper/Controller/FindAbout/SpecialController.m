//
//  SpecialController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SpecialController.h"
#import "SpecialCell.h"
#import "Configurations.h"
#import "SpecialDetailController.h"

@interface SpecialController ()

@end

@implementation SpecialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = VIEWBACKGROUNDCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"专题名称";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialCell *cell = [SpecialCell specialCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialDetailController *speDetailVc = [[SpecialDetailController alloc] init];
    [self.navigationController pushViewController:speDetailVc animated:YES];
}

@end
