//
//  JWShardManager.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "BasViewController.h"


@class UMSocialControllerService;
@class BasViewController;

@protocol JWSharedManagerDelegate <NSObject>

@optional
- (void)sharedResultCallBack:(BOOL)isSucess info:(NSString *)result;

@end

@interface SharedItem :NSObject

@property (nonatomic, strong) NSString *title ;  //分享的title
@property (nonatomic, strong) NSString *content; //分享的内容
@property (nonatomic, strong) NSString *sharedURL;  //分享的链接
@property (nonatomic, strong) UIImage *shareImg;

@end

@interface JWShardManager : NSObject

+ (instancetype)defaultJWShardManager;

@property (nonatomic, weak) UIViewController* controller;
@property (nonatomic, strong) SharedItem *sitem;



- (void)startShareWithItem:(SharedItem*)item controller:(UIViewController*)controller withImage:(UIImage *)shareImg;

// 直接分享到某个平台上
- (void)shareToSnsType:(UMSocialSnsType)type title:(NSString*)title content:(NSString*)content url:(NSString*)url toViewController:(UIViewController*)controller;



@end
