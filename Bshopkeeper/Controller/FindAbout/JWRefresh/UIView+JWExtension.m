//
//  UIView+JWExtension.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UIView+JWExtension.h"

@implementation UIView (JWExtension)
- (void)setJW_x:(CGFloat)JW_x
{
    CGRect frame = self.frame;
    frame.origin.x = JW_x;
    self.frame = frame;
}

- (CGFloat)JW_x
{
    return self.frame.origin.x;
}

- (void)setJW_y:(CGFloat)JW_y
{
    CGRect frame = self.frame;
    frame.origin.y = JW_y;
    self.frame = frame;
}

- (CGFloat)JW_y
{
    return self.frame.origin.y;
}

- (void)setJW_width:(CGFloat)JW_width
{
    CGRect frame = self.frame;
    frame.size.width = JW_width;
    self.frame = frame;
}

- (CGFloat)JW_width
{
    return self.frame.size.width;
}

- (void)setJW_height:(CGFloat)JW_height
{
    CGRect frame = self.frame;
    frame.size.height = JW_height;
    self.frame = frame;
}

- (CGFloat)JW_height
{
    return self.frame.size.height;
}

- (void)setJW_size:(CGSize)JW_size
{
    CGRect frame = self.frame;
    frame.size = JW_size;
    self.frame = frame;
}

- (CGSize)JW_size
{
    return self.frame.size;
}

- (void)setJW_origin:(CGPoint)JW_origin
{
    CGRect frame = self.frame;
    frame.origin = JW_origin;
    self.frame = frame;
}

- (CGPoint)JW_origin
{
    return self.frame.origin;
}
@end
