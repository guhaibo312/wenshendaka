//
//  SquareLikeButton.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/3.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SquareLikeButton.h"
#import "Configurations.h"

@implementation SquareLikeButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height/2-15, 30, 30)];
        _leftImgView.backgroundColor = [UIColor clearColor];
        if (imageName) {
            _leftImgView.image = [UIImage imageNamed:imageName];
        }
        _leftImgView.userInteractionEnabled = NO;
        [self addSubview:_leftImgView];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, frame.size.width-35 , frame.size.height)];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.text = title;
        _contentLabel.textColor = SquareTextColor;
        _contentLabel.textAlignment = NSTextAlignmentCenter;;
        [self addSubview:_contentLabel];
        _contentLabel.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (_hightColor) {
        self.layer.backgroundColor = _hightColor.CGColor;
        self.backgroundColor = _hightColor;
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    if (_hightColor) {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (_hightColor) {
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
