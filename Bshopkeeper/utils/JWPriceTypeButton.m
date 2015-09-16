//
//  JWPriceTypeButton.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWPriceTypeButton.h"
#import "Configurations.h"

@implementation JWPriceTypeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(float)font selectedbackgroundColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateSelected];
        backGroundColor = color;
        [self setTitleColor:GRAYTEXTCOLOR forState:UIControlStateNormal];
        [self setTitleColor:GRAYTEXTCOLOR forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.5, frame.size.height)];
        leftView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:leftView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = backGroundColor;
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
