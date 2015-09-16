
//
//  JWRefreshConst.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <QuartzCore/QuartzCore.h>

const CGFloat JWRefreshViewHeight = 64.0;
const CGFloat JWRefreshFastAnimationDuration = 0.25;
const CGFloat JWRefreshSlowAnimationDuration = 0.4;

NSString *const JWRefreshBundleName = @"JWRefresh.bundle";

NSString *const JWRefreshFooterPullToRefresh = @"上拉可以加载更多数据";
NSString *const JWRefreshFooterReleaseToRefresh = @"松开立即加载更多数据";
NSString *const JWRefreshFooterRefreshing = @"正在帮你加载数据...";

NSString *const JWRefreshHeaderPullToRefresh = @"下拉可以刷新";
NSString *const JWRefreshHeaderReleaseToRefresh = @"松开立即刷新";
NSString *const JWRefreshHeaderRefreshing = @"正在帮你刷新...";
NSString *const JWRefreshHeaderTimeKey = @"JWRefreshHeaderView";

NSString *const JWRefreshContentOffset = @"contentOffset";
NSString *const JWRefreshContentSize = @"contentSize";