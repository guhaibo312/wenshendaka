//
//  JWLayerButton.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWLayerButton.h"

@interface JWLayerButton ()
{
    CAShapeLayer *maskLayer;
    UIColor *selectedColor;
    UILabel *nameLabel;
    UIColor *normalTitleColor;
}

@end

@implementation JWLayerButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title fontsize:(float)font style:(int) style selectedBgColor:(UIColor *)color titleColor:(UIColor *)titleColor
{
    self = [super initWithFrame:frame];
    if (self) {
        selectedColor = color;
        
        if (style <= 9 && style >=0) {
            UIRectCorner corners;
            switch (style)
            {
                case 0:
                    corners = UIRectCornerBottomLeft;
                    break;
                case 1:
                    corners = UIRectCornerBottomRight;
                    break;
                case 2:
                    corners = UIRectCornerTopLeft;
                    break;
                case 3:
                    corners = UIRectCornerTopRight;
                    break;
                case 4:
                    corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
                    break;
                case 5:
                    corners = UIRectCornerTopLeft | UIRectCornerTopRight;
                    break;
                case 6:
                    corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
                    break;
                case 7:
                    corners = UIRectCornerBottomRight | UIRectCornerTopRight;
                    break;
                case 8:
                    corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
                    break;
                case 9:
                    corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
                    break;
                default:
                    corners = UIRectCornerAllCorners;
                    break;
            }
            
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           byRoundingCorners:corners cornerRadii:CGSizeMake(frame.size.height/2,frame.size.height/2)];
            maskLayer = [CAShapeLayer layer];
            maskLayer.frame         = self.bounds;
            maskLayer.cornerRadius  = frame.size.height/2;
            maskLayer.fillColor     = [UIColor whiteColor].CGColor;
            maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
            maskLayer.path          = maskPath.CGPath;
            [self.layer  addSublayer: maskLayer];
            self.layer.backgroundColor = [UIColor clearColor].CGColor;
            self.layer.masksToBounds = YES;
        }
        
        
        nameLabel = [[UILabel alloc]initWithFrame:self.bounds];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = title;
        nameLabel.textColor = titleColor;
        normalTitleColor = titleColor;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:font];
        [self addSubview:nameLabel];
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-30, 4, 6, 6)];
        _messageLabel.backgroundColor = [UIColor redColor];
        _messageLabel.layer.cornerRadius = 3;
        _messageLabel.clipsToBounds = YES;
        _messageLabel.hidden = YES;
        [self addSubview:_messageLabel];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        if (maskLayer) {
            maskLayer.fillColor = selectedColor.CGColor;
        }else{
            nameLabel.backgroundColor = selectedColor;
        }
        nameLabel.textColor = [UIColor blackColor];
    }else{
        if (maskLayer) {
            maskLayer.fillColor = [UIColor whiteColor].CGColor;
        }else{
            nameLabel.backgroundColor = [UIColor whiteColor];
        }
        nameLabel.textColor = normalTitleColor;
    }
}
//设置正常状态下的背景颜色
- (void)setNormarlBackGroundColor:(UIColor *)color
{
    if (maskLayer) {
        maskLayer.backgroundColor = color.CGColor;
        maskLayer.fillColor = color.CGColor;
        nameLabel.backgroundColor = [UIColor clearColor];

    }else{
        nameLabel.backgroundColor = color;
    }
    
    
}
//设置正常下的layer的边框
- (void)setLayerWidth:(float)width
{
    if (maskLayer) {
        maskLayer.lineWidth = width;
    }
}

- (void)setNameLabelTextColor:(UIColor *)tColor backGroundColor:(UIColor *)bColor
{
    if (maskLayer) {
        maskLayer.backgroundColor = bColor.CGColor;
        maskLayer.fillColor = bColor.CGColor;
        nameLabel.backgroundColor = [UIColor clearColor];
        
    }else{
        nameLabel.backgroundColor = bColor;
    }
    nameLabel.textColor = tColor;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
