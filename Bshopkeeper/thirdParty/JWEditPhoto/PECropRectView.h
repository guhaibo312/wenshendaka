//
//  PECropViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECropRectView : UIView

@property (nonatomic) id delegate;
@property (nonatomic) BOOL showsGridMajor;
@property (nonatomic) BOOL showsGridMinor;

@end

@protocol PECropRectViewDelegate <NSObject>

- (void)cropRectViewDidBeginEditing:(PECropRectView *)cropRectView;
- (void)cropRectViewEditingChanged:(PECropRectView *)cropRectView;
- (void)cropRectViewDidEndEditing:(PECropRectView *)cropRectView;

@end

