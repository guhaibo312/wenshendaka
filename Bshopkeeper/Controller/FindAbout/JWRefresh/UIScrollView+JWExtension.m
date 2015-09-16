
//
//  UIScrollView+JWExtension.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UIScrollView+JWExtension.h"

@implementation UIScrollView (JWExtension)
- (void)setJW_contentInsetTop:(CGFloat)JW_contentInsetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = JW_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)JW_contentInsetTop
{
    return self.contentInset.top;
}

- (void)setJW_contentInsetBottom:(CGFloat)JW_contentInsetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = JW_contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)JW_contentInsetBottom
{
    return self.contentInset.bottom;
}

- (void)setJW_contentInsetLeft:(CGFloat)JW_contentInsetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = JW_contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)JW_contentInsetLeft
{
    return self.contentInset.left;
}

- (void)setJW_contentInsetRight:(CGFloat)JW_contentInsetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = JW_contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)JW_contentInsetRight
{
    return self.contentInset.right;
}

- (void)setJW_contentOffsetX:(CGFloat)JW_contentOffsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = JW_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)JW_contentOffsetX
{
    return self.contentOffset.x;
}

- (void)setJW_contentOffsetY:(CGFloat)JW_contentOffsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = JW_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)JW_contentOffsetY
{
    return self.contentOffset.y;
}

- (void)setJW_contentSizeWidth:(CGFloat)JW_contentSizeWidth
{
    CGSize size = self.contentSize;
    size.width = JW_contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)JW_contentSizeWidth
{
    return self.contentSize.width;
}

- (void)setJW_contentSizeHeight:(CGFloat)JW_contentSizeHeight
{
    CGSize size = self.contentSize;
    size.height = JW_contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)JW_contentSizeHeight
{
    return self.contentSize.height;
}
@end
