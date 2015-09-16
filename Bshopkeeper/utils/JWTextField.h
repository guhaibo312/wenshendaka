//
//  JWTextField.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/18.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTextField : UITextField

+ (id)fieldWithFrame:(CGRect)frame font:(float)textFont place:(NSString*)place delete:(id<UITextFieldDelegate>)Cdelete textColor:(UIColor *)textColor;

@end
