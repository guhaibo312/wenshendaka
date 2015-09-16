//
//  UploadingView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/1.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiniuSDK.h"
#import "Configurations.h"

@interface UploadingView : UIView

- (void)show;

- (void)dissMiss;

@property (nonatomic, strong) NSMutableArray *keyArray;

- (void)setProgress:(float)progress;

@end
