//
//  PECropViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PEResizeControl : UIView

@property (weak, nonatomic) id delegate;
@property (nonatomic, readonly) CGPoint translation;

@end

@protocol PEResizeConrolViewDelegate <NSObject>

- (void)resizeConrolViewDidBeginResizing:(PEResizeControl *)resizeConrolView;
- (void)resizeConrolViewDidResize:(PEResizeControl *)resizeConrolView;
- (void)resizeConrolViewDidEndResizing:(PEResizeControl *)resizeConrolView;

@end
