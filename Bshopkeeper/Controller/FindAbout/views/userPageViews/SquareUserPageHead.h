//
//  SquareUserPageHead.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/4.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareUserPageHead : UIView

- (instancetype)initWithFrame:(CGRect)frame withOwnerController:(UIViewController *)controller;

- (void)setDataFrom:(NSDictionary *)dict;

- (UIImage *)getShareHeadImage;

@end

