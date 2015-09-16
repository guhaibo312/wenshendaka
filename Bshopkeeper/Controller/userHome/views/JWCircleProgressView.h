//
//  JWCircleProgressView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCircleProgressView : UIView
{
    CAShapeLayer *_progressView;           //当前进度
    CAShapeLayer *_backProgressView;       //进度的背景色
    
    UILabel *progressLabel;                //进度的label
    
    UIColor *backgroundColor;
    UIColor *currentProgressColor;
    float currentLineWidth;
}

- (instancetype)initWithFrame:(CGRect)frame backColor:(UIColor *)backColor progressColor:(UIColor *)progressColor lineWidth:(float)lineWidth;

/*设置进度
 **/
- (void)setCurrentProgress:(float)progress withTotal:(float)total ispercentage:(BOOL)isPer;

- (void)setProgressLabelBackGroundColor:(UIColor *)color;

- (void)setProgressLabelHidden:(BOOL)hidden;

- (void)setCurrentProgress:(float)progress;

- (void)setProgressLabelTextColor:(UIColor *)color;

@end
