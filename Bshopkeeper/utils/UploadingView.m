//
//  UploadingView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/1.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UploadingView.h"
#import "JWCircleProgressView.h"

@interface UploadingView ()
{
    JWCircleProgressView *topCircleView;
    
}

@end

@implementation UploadingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(100, 100, 100, 100);
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 50;
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
        
        topCircleView = [[JWCircleProgressView alloc]initWithFrame:CGRectMake(10 , 10, 80, 80) backColor:[UIColor blackColor] progressColor:[UIColor whiteColor] lineWidth:6];
        [topCircleView setProgressLabelBackGroundColor:[UIColor clearColor]];
        [topCircleView setProgressLabelTextColor:[UIColor whiteColor]];
        [self addSubview:topCircleView];
        _keyArray = [[NSMutableArray alloc]init];
        self.tag = 787;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.center = keyWindow.center;
        [keyWindow addSubview:self];
    }
    return self;
}
- (void)setProgress:(float)progress
{
    if (self) {
        [topCircleView setCurrentProgress:progress];
    }
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *haveView = [keyWindow viewWithTag:787];
    if (haveView) {
        return;
    }
    self.center= keyWindow.center;
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.alpha = 1;
        }
    }];
}
- (void)animationStop
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *customView = [keyWindow viewWithTag:787];
    
    [UIView animateWithDuration:0.30 animations:^{
        if (customView) {
            customView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        if (finished == YES) {
            if (customView) {
                [customView removeFromSuperview];
            }
            if (self) {
                [self removeFromSuperview];

            }
        }
    }];
}


- (void)dissMiss
{
    
    [self animationStop];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
