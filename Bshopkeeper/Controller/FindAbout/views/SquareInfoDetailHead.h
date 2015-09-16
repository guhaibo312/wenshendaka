//
//  SquareInfoDetailHead.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/3.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareObject.h"

@interface SquareInfoDetailHead : UIView

- (instancetype)initWithSquareItem:(SquareDataItem *)item ownerController:(UIViewController *)ownerVC;

- (void)setValueForViews:(SquareDataItem *)item;

- (UIImage *)getHeadImg;

@end

@interface SquareInfoDetailTag : UIView
{
    UIScrollView *tagScrollView;
    UIImageView *leftTagView;
}

- (instancetype)initWithFrame:(CGRect)frame withTag:(NSString *)tagStr;

- (void)setTagStr:(NSString *)tagStr;

- (void)bingClickFuncitonTarget:(id)taget action:(SEL)sel;


@end

@interface ImageFeedHeadView : UIView

- (instancetype)initWithSquareItem:(SquareDataItem *)item ownerController:(UIViewController *)ownerVC;

- (void)setValueForViews:(SquareDataItem *)item;

- (UIImage *)getHeadImg;

@end