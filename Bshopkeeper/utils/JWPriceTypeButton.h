//
//  JWPriceTypeButton.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWPriceTypeButton : UIButton
{
    UIColor *backGroundColor;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title font:(float)font selectedbackgroundColor:(UIColor *)color;

@end
