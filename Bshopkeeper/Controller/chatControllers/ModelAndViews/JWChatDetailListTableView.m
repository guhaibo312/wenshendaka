//
//  JWChatDetailListTableView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatDetailListTableView.h"
#import "UIScrollView+JWRefresh.h"
#import "JWChatMessageFrameModel.h"
#import "JWChatDetailCell.h"
#import "JWSocketCpu.h"
#import "JWSocketManage.h"

@interface JWChatDetailListTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    JWChatMessageFrameModel *operationModel;        //当前操作的
}
@end

@implementation JWChatDetailListTableView

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
        
        _ownerController = controller;
        
        self.dataSource = self;
        
        self.delegate = self;
        
        self.tableFooterView  = [[UIView alloc]init];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.resetAction) {
        _resetAction();
    }
    return [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.contentOffset.y <= -30) {
        if (self.loadMoreBlock && !_isLoading) {
            JWChatMessageFrameModel * model;
            if (self.dataArray.count>0 ) {
                model = [self.dataArray firstObject];
            }
            _loadMoreBlock(model);
            _isLoading = YES;
        }
    }

    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >=0 && indexPath.row<= _dataArray.count-1) {
        JWChatMessageFrameModel *model = [_dataArray objectAtIndex:indexPath.row];
        return model.cellHeght;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *chatDetaillCellIdentifer = @"chatDetaillCellIdentifer";
    JWChatDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:chatDetaillCellIdentifer];
    if (!cell) {
        cell = [[JWChatDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatDetaillCellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.failButton addTarget:self action:@selector(clickFailButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row >=0 && indexPath.row<= _dataArray.count-1) {
        JWChatMessageFrameModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        JWChatMessageFrameModel *beforeModel;
        if (indexPath.row-1 >=0 && indexPath.row-1<= _dataArray.count-1) {
            beforeModel = [_dataArray objectAtIndex:indexPath.row -1];
        }
        [cell setChatDetail:model beforeItem:beforeModel];
    }
    cell.tag = indexPath.row;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (void)clickFailButtonFunction:(JWSendFailButton *)sender
{
    
    if (sender.tag >=0 && sender.tag<= _dataArray.count) {
        operationModel = [_dataArray objectAtIndex:sender.tag];
    };
    
    [sender becomeFirstResponder];
    
    UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteMessageFunction:)];
    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"重发" action:@selector(resetSendMessage:)];
    
    UIMenuController *controll = [UIMenuController sharedMenuController];
    controll.menuItems = @[item2,item1];
    [controll setTargetRect:sender.frame inView:sender.superview];
    [controll setMenuVisible:YES animated:YES];
    
    
}

#pragma mark -- 删除本条记录
- (void)deleteMessageFunction:(id)sender
{
    if (!operationModel) return;
    
    if ([_dataArray containsObject:operationModel]) {
        [_dataArray removeObject:operationModel];
    }
    [self reloadData];
}


#pragma mark ---- 重新发送
- (void)resetSendMessage:(id)sender
{
    if (!operationModel) return;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (operationModel.message.text) {
        [dict setObject:operationModel.message.text forKey:@"text"];
    }
    if (operationModel.message.images) {
        [dict setObject:operationModel.message.images forKey:@"images"];
    }
    [dict setObject:@(operationModel.message.type) forKey:@"type"];
    [dict setObject:[User defaultUser].item.userId forKey:@"fromId"];
    [dict setObject:operationModel.message.otherId forKey:@"otherId"];
    double time = [[NSDate date]timeIntervalSince1970]*1000;
    time = [[NSString stringWithFormat:@"%.f",time] doubleValue];
    [dict setObject:operationModel.message.time forKey:@"time"];
    [dict setObject:operationModel.message.time forKey:@"checkCode"];
    operationModel.messagestatus = chatmessageStatusLoading;
    [self reloadData];
    [[JWSocketCpu sharedInstance] writeActionWithcommand:CS_talk UserParm:dict withModel:operationModel.message];
}


@end


@implementation JWSendFailButton

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
