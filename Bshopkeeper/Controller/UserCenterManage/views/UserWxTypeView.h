//
//  UserWxTypeView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/7/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserWxTypeView : UIView
- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)controller;


- (void)resetLoad;

@end

@interface DesBolderButton : UIButton

@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIButton *desButton;


- (void)setDesLabelText:(NSString *)string type:(int)whereType;

@end