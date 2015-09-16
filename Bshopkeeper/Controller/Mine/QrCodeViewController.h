//
//  QrCodeViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/9.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BasViewController.h"

@interface QrCodeViewController : BasViewController

@end

@interface ArcView : UIView

@property (nonatomic, strong) UIColor *bolderColor;
- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor *)aColor;
@end