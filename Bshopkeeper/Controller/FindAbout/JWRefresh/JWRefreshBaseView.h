
//
//  JWRefreshBaseView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWRefreshBaseView;

#pragma mark - 控件的刷新状态
typedef enum {
	JWRefreshStatePulling = 1, // 松开就可以进行刷新的状态
	JWRefreshStateNormal = 2, // 普通状态
	JWRefreshStateRefreshing = 3, // 正在刷新中的状态
    JWRefreshStateWillRefreshing = 4
} JWRefreshState;

#pragma mark - 控件的类型
typedef enum {
    JWRefreshViewTypeHeader = -1, // 头部控件
    JWRefreshViewTypeFooter = 1 // 尾部控件
} JWRefreshViewType;

/**
 类的声明
 */
@interface JWRefreshBaseView : UIView
#pragma mark - 父控件
@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;

#pragma mark - 内部的控件
@property (nonatomic, weak, readonly) UILabel *statusLabel;
@property (nonatomic, weak, readonly) UIImageView *arrowImage;
@property (nonatomic, weak, readonly) UIActivityIndicatorView *activityView;

#pragma mark - 回调
/**
 *  开始进入刷新状态的监听器
 */
@property (weak, nonatomic) id beginRefreshingTaget;
/**
 *  开始进入刷新状态的监听方法
 */
@property (assign, nonatomic) SEL beginRefreshingAction;
/**
 *  开始进入刷新状态就会调用
 */
@property (nonatomic, copy) void (^beginRefreshingCallback)();

#pragma mark - 刷新相关
/**
 *  是否正在刷新
 */
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
/**
 *  开始刷新
 */
- (void)beginRefreshing;
/**
 *  结束刷新
 */
- (void)endRefreshing;

#pragma mark - 交给子类去实现 和 调用
@property (assign, nonatomic) JWRefreshState state;

/**
 *  文字
 */
@property (copy, nonatomic) NSString *pullToRefreshText;
@property (copy, nonatomic) NSString *releaseToRefreshText;
@property (copy, nonatomic) NSString *refreshingText;
@end