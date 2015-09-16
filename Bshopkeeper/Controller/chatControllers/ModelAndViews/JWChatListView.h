//
//  JWChatListView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
// 聊天列表

#import <UIKit/UIKit.h>

@interface JWChatListView : UITableView

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)controller;

@property (nonatomic, weak) UIViewController *ownerController;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL getMessageSucess;

- (void)getChatList;

@end
