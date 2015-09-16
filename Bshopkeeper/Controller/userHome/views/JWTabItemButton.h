//
//  JWTabItemButton.h
//  Bshopkeeper
//
//  Created by jinwei on 15/7/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTabItemButton : UIButton
{
    UILabel *nameLabel;
    UIView *bottomLineView;
}
@property (nonatomic ,strong) UILabel *messageLabel;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title normalTextColor:(UIColor *)color needBottomView:(BOOL)isNeed;

@end
