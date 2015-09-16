//
//  TabBarView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/7/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHomeBtn.h"

@class JWTabItem;
@interface TabBarView : UIView

@property (nonatomic, strong) JWTabItem *firstItem;
@property (nonatomic, strong) JWTabItem *secondItem;
@property (nonatomic, strong) JWTabItem *threeItem;
@property (nonatomic, strong) JWTabItem *fourthItem;

- (void)setNothingSelected;

- (instancetype)initWithFrame:(CGRect)frame withType:(int)type;

@end

@interface JWTabItem : UIButton
@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UILabel *messageLabel;

- (instancetype)initWithFrame:(CGRect)frame withNorImg:(UIImage *)nimg selectedImg:(UIImage *)simg title:(NSString *)title;

@end