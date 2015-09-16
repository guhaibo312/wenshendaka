//
//  JWShareView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/27.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"
#import "JWShardManager.h"

@class SharedItem;

typedef NS_OPTIONS(NSUInteger, JWShareViewType) {
    JWShareViewTypewx   = 0,
    JWShareViewTypewxpyq,
    JWShareViewTypesjqq,
    JWShareViewTypeqqkj,
    JWShareViewTypexlwb,
    JWShareViewTypesjdx,
    JWShareViewTypefzlj
};

typedef void(^resultFunction)(void);

@interface JWShareView : UIView

{
    UIView *backGroundView;
    UIView *bottomeView;
}

@property (nonatomic, copy) resultFunction block;

/**分享到各个平台
 *@types 制定类型的数组
 */
- (instancetype)initWithFrame:(CGRect)frame withShareTypes:(NSArray *)types dataItem:(SharedItem*)item UIViewController:(UIViewController *)controller;

- (void)show;

- (void)dissMiss;


@end
