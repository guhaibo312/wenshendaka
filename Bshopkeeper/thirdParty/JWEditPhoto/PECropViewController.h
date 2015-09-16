//
//  PECropViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECropViewController : UIViewController

@property (nonatomic) id delegate;
@property (nonatomic) UIImage *image;

@end

@protocol PECropViewControllerDelegate <NSObject>

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage;

- (void)cropViewControllerDidCancel:(PECropViewController *)controller;

@end
