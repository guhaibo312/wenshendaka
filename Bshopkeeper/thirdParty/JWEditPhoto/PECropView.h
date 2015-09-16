//
//  PECropViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface PECropView : UIView

@property (nonatomic) UIImage *image;
@property (nonatomic, readonly) UIImage *croppedImage;
@property (nonatomic) CGFloat aspectRatio;
@property (nonatomic) CGRect cropRect;

@end
