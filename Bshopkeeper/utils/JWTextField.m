//
//  JWTextField.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/18.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWTextField.h"

@implementation JWTextField

+ (id)fieldWithFrame:(CGRect)frame font:(float)textFont place:(NSString *)place delete:(id<UITextFieldDelegate>)Cdelete textColor:(UIColor *)textColor
{
    UITextField *field = [[UITextField alloc]initWithFrame:frame];
    if (textFont) {
        field.font = [UIFont systemFontOfSize:textFont];
    }
    if (place) {
        field.placeholder = place;
    }
    if (Cdelete) {
        field.delegate = Cdelete;
    }
    if (textColor) {
        field.textColor = textColor;
    }else {
        field.textColor = [UIColor blackColor];
    }
    field.returnKeyType = UIReturnKeyDone;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;

    return field;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
