//
//  UserHomeBtn.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHomeBtn : UIButton


- (id)initWithFrame:(CGRect)frame text:(NSString *)text imageName:(NSString *)imageName;

+ (instancetype)buttonWithFrame:(CGRect)frame text:(NSString *)text imageName:(NSString *)imageName;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *desIamgeView;
@property (nonatomic, strong) UIImageView *noticeImg;
@end
