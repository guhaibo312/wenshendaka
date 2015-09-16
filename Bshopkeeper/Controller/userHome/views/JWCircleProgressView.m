//
//  JWCircleProgressView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWCircleProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import "Configurations.h"


@implementation JWCircleProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor progressColor:(UIColor *)progressColor lineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        backgroundColor = backColor;
        currentProgressColor = progressColor;
        currentLineWidth = lineWidth;
        
        _backProgressView  = [self createRingLayerWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2) radius:CGRectGetWidth(self.bounds) / 2 - lineWidth / 2 lineWidth:lineWidth color:backColor];
        [self.layer addSublayer:_backProgressView];
        
        _progressView = [self createRingLayerWithCenter:CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2) radius:CGRectGetWidth(self.bounds) / 2 - lineWidth / 2 lineWidth:lineWidth color:progressColor];
        _progressView.strokeEnd = 0;
        [self.layer addSublayer:_progressView];
        
        progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, frame.size.width-16, frame.size.height-16)];
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.layer.cornerRadius = progressLabel.bounds.size.height/2;
        progressLabel.clipsToBounds = YES;
        progressLabel.textColor = GRAYTEXTCOLOR;
        progressLabel.font = [UIFont systemFontOfSize:14];
        [self.layer addSublayer:progressLabel.layer];
    }
    return self;
    
}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    UIBezierPath *smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:- M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineJoinBevel;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}

/*设置进度
 **/
- (void)setCurrentProgress:(float)progress withTotal:(float)total ispercentage:(BOOL)isPer
{

    if (progress == 0) {
        progressLabel.text = isPer?@"0%" : [NSString stringWithFormat:@"0/%.0f",total];
        _progressView.hidden = YES;
        _progressView.strokeEnd = 0;

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            _progressView.strokeEnd = 0;
//        });
    }else {
        _progressView.hidden = NO;
        _progressView.strokeEnd = progress;
        
        if (!isPer) {
            
            progressLabel.text = [NSString stringWithFormat:@"%d/%.0f",(int)(progress*total),total];
        }else{
            progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
        }
    }

}

- (void)setCurrentProgress:(float)progress
{
    _progressView.strokeEnd = progress;
    progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progress*100];

}

- (void)setProgressLabelHidden:(BOOL)hidden
{
    progressLabel.hidden = hidden;
    
}

- (void)setProgressLabelTextColor:(UIColor *)color
{
    progressLabel.textColor = color;
}

- (void)setProgressLabelBackGroundColor:(UIColor *)color
{
    progressLabel.backgroundColor = color;
    progressLabel.font = [UIFont systemFontOfSize:18];

}

@end
