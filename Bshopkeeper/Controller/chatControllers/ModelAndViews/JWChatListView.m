//
//  JWChatListView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatListView.h"
#import "Configurations.h"
#import "JWSocketCpu.h"
#import "JWSocketManage.h"
#import "JWChatMessageModel.h"
#import "JWChatListCell.h"
#import "JWChatDetailViewController.h"

@interface JWChatListView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation JWChatListView

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ownerController = controller;
        self.dataArray = [[NSMutableArray alloc]init];
        self.rowHeight = 66;
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc]init];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *listCellIdentifier = @"listCellIdentifier";
    JWChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellIdentifier];
    if (!cell) {
        cell = [[JWChatListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCellIdentifier];
    }
    if (indexPath.row >= 0 && indexPath.row<= _dataArray.count-1) {
        [cell refreshDataFrome:_dataArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self || !_ownerController) return;
    JWChatMessageModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (model.otherId) {
        JWChatDetailViewController *chatDetail = [[JWChatDetailViewController alloc]initWithQuery:@{@"id":model.otherId}];
        [_ownerController.navigationController pushViewController:chatDetail animated:YES];

    }
 }

- (void)getChatList
{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:ChatReceivedMessageListNotice forKey:@"checkCode"];
    [[JWSocketCpu sharedInstance]writeActionWithcommand:CS_getTalkUsers UserParm:parm];
}

@end
