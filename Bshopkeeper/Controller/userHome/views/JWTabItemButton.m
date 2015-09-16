//
//  JWTabItemButton.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWTabItemButton.h"
#import "Configurations.h"

@interface JWTabItemButton ()
{
    UIColor *normalColor;
    
}

@end

@implementation JWTabItemButton


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title normalTextColor:(UIColor *)color needBottomView:(BOOL)isNeed
{
    self = [super initWithFrame:frame];
    if (self) {
        
        normalColor = color;
        
        nameLabel = [[UILabel alloc]initWithFrame:self.bounds];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = title;
        nameLabel.textColor = color;
        nameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:nameLabel];
        
    
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width-30, 5, 20, 20)];
        _messageLabel.backgroundColor = MessageBackColor;
        _messageLabel.clipsToBounds = YES;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:12];
        [_messageLabel setTextColor:TAGBODLECOLOR];
        _messageLabel.layer.cornerRadius = 10;
        [self addSubview:_messageLabel];
        
        _messageLabel.hidden = YES;
        
        if (isNeed) {
            bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(self.width/2-30, self.height-3, 60, 3)];
            bottomLineView.backgroundColor = SEGMENTSELECT;
            bottomLineView.hidden = YES;
            [self addSubview:bottomLineView];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        nameLabel.textColor = SEGMENTSELECT;
        if (bottomLineView) {
            bottomLineView.hidden = NO;
        }
    }else{
        if (normalColor) {
            nameLabel.textColor = normalColor;
        }else{
            nameLabel.textColor = TAGBODLECOLOR;
        }
        if (bottomLineView) {
            bottomLineView.hidden = YES;
        }
    }
}
@end
