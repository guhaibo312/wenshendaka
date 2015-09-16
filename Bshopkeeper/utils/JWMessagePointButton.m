//
//  JWMessagePointButton.m
//  Bshopkeeper
//
//  Created by jinwei on 15/9/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWMessagePointButton.h"
#import "Configurations.h"

@implementation JWMessagePointButton

- (instancetype)initWithFrame:(CGRect)frame BackImage:(UIImage *)backImg
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setImage:backImg forState:UIControlStateNormal];
        [self setImage:backImg forState:UIControlStateSelected];
        self.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
       self.messageLabel = [UILabel labelWithFrame:CGRectMake(self.width-10, 5, 6, 6) fontSize:14 fontColor:MessageBackColor text:@""];
        _messageLabel.backgroundColor = MessageBackColor;
        _messageLabel.layer.cornerRadius = 3;
        _messageLabel.clipsToBounds = YES;
        _messageLabel.hidden = YES;
        [self addSubview:_messageLabel];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}



@end
