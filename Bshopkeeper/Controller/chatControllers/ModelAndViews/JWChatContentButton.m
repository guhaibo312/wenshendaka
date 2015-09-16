//
//  JWChatContentButton.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/27.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatContentButton.h"

@implementation JWChatContentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 标题
        self.imageTextLabel = [[UILabel alloc]init];
        self.imageTextLabel.backgroundColor= [UIColor clearColor];
        self.imageTextLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.imageTextLabel];
        
        
        //图片
        self.backImageView = [[PhotoWallView alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backImageView];
        
        //语音
        self.voiceBackView = [[UIView alloc]init];
        [self addSubview:self.voiceBackView];
        
        self.second = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        self.second.textAlignment = NSTextAlignmentCenter;
        self.second.font = [UIFont systemFontOfSize:14];
        self.voice = [[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 20, 20)];
        self.voice.image = [UIImage imageNamed:@"chat_animation_white3"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"chat_animation_white1"],
                                      [UIImage imageNamed:@"chat_animation_white2"],
                                      [UIImage imageNamed:@"chat_animation_white3"],nil];
        self.voice.animationDuration = 1;
        self.voice.animationRepeatCount = 0;
        
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator.center=CGPointMake(80, 15);
        [self.voiceBackView addSubview:self.indicator];
        [self.voiceBackView addSubview:self.voice];
        [self.voiceBackView addSubview:self.second];
        
        self.backImageView.userInteractionEnabled = NO;
        self.voiceBackView.userInteractionEnabled = NO;
        self.second.userInteractionEnabled = NO;
        self.voice.userInteractionEnabled = NO;
        
        self.second.backgroundColor = [UIColor clearColor];
        self.voice.backgroundColor = [UIColor clearColor];
        self.voiceBackView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)benginLoadVoice
{
    self.voice.hidden = YES;
    [self.indicator startAnimating];
}
- (void)didLoadVoice
{
    self.voice.hidden = NO;
    [self.indicator stopAnimating];
    [self.voice startAnimating];
}
-(void)stopPlay
{
    //    if(self.voice.isAnimating){
    [self.voice stopAnimating];
    //    }
}

- (void)setIsMyMessage:(BOOL)isMyMessage
{
    _isMyMessage = isMyMessage;
    if (isMyMessage) {
        self.voiceBackView.frame = CGRectMake(15, 10, 130, 35);
        self.second.textColor = [UIColor whiteColor];
    }else{
        self.voiceBackView.frame = CGRectMake(25, 10, 130, 35);
        self.second.textColor = [UIColor grayColor];
    }
}


//添加
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.titleLabel.text;
}

@end
