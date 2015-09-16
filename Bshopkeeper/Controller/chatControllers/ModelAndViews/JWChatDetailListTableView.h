//
//  JWChatDetailListTableView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWChatMessageFrameModel;

typedef void(^reloadMoreHistoryRecord)(JWChatMessageFrameModel *model);

typedef void(^resetSuperView)(void);


@interface JWChatDetailListTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller;

@property (nonatomic, weak) UIViewController *ownerController;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, copy) reloadMoreHistoryRecord loadMoreBlock;

@property (nonatomic, copy) resetSuperView resetAction;

@property (nonatomic , strong) NSString *userAvatar;


@end

@interface JWSendFailButton : UIButton

@end