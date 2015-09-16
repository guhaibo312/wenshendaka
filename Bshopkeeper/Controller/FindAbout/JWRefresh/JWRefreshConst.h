
//
//  JWRefreshConst.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define JWLog(...) NSLog(__VA_ARGS__)
#else
#define JWLog(...)
#endif

// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)


#define JWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 文字颜色
#define JWRefreshLabelTextColor JWColor(150, 150, 150)

extern const CGFloat JWRefreshViewHeight;
extern const CGFloat JWRefreshFastAnimationDuration;
extern const CGFloat JWRefreshSlowAnimationDuration;

extern NSString *const JWRefreshBundleName;
#define JWRefreshSrcName(file) [JWRefreshBundleName stringByAppendingPathComponent:file]

extern NSString *const JWRefreshFooterPullToRefresh;
extern NSString *const JWRefreshFooterReleaseToRefresh;
extern NSString *const JWRefreshFooterRefreshing;

extern NSString *const JWRefreshHeaderPullToRefresh;
extern NSString *const JWRefreshHeaderReleaseToRefresh;
extern NSString *const JWRefreshHeaderRefreshing;
extern NSString *const JWRefreshHeaderTimeKey;

extern NSString *const JWRefreshContentOffset;
extern NSString *const JWRefreshContentSize;