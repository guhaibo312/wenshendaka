//
//  JWInputAlertView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWInputAlertView.h"
#import "Configurations.h"

@interface JWInputAlertView ()<UITextFieldDelegate>
{
    JWInputType curentType;
}
@end


@implementation JWInputAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitle:(NSString *)title inputType:(JWInputType)type delegate:(id<JWInputAlertViewDelegate>)delegate ButtonTittle:(NSString *)btnTitle
{
    self = [super init];
    if (self) {
        curentType = type;
        _inputDelegate = delegate;
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.tag = 401;
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        topView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREENWIDTH -40, 150)];
        topView.center = self.center;
        topView.backgroundColor = [UIColor whiteColor];
        topView.layer.cornerRadius = 8;
        [self addSubview:topView];
        
        titleLabel = [UILabel labelWithFrame:CGRectMake(0, 0, topView.width, 40) fontSize:16 fontColor:[UIColor blackColor] text:title];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        [topView addSubview:titleLabel];
        
        
        UIView *fieldBoldView = [[UIView alloc]initWithFrame:CGRectMake(20, titleLabel.bottom+10, topView.width - 40, 40)];
        fieldBoldView.layer.borderWidth = 0.5;
        fieldBoldView.layer.cornerRadius =  5;
        fieldBoldView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [topView addSubview:fieldBoldView];
        
        InputTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, fieldBoldView.width - 10, 40)];
        InputTextField.delegate = self;
        InputTextField.placeholder = @"点击输入";
        if (type == JWInputPhoneType || type == JWInputNumberType) {
            InputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        InputTextField.returnKeyType = UIReturnKeyDone;
        InputTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
        InputTextField.font = [UIFont systemFontOfSize:14];
        [fieldBoldView addSubview:InputTextField];
        
        
        
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(0, topView.height - 40, topView.width, 40);
        [okBtn setTitle:btnTitle forState:UIControlStateNormal];
        [okBtn setTitle:btnTitle forState:UIControlStateHighlighted];
        [okBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [okBtn setBackgroundImage:[UIUtils imageFromColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:okBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, topView.height - 40, topView.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [topView addSubview:lineView];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelfAction:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)show
{
    UIView *sameView = [[UIApplication sharedApplication].keyWindow viewWithTag:401];
    if (sameView) {
        [sameView removeFromSuperview];
        sameView = nil;
    }
    if (sameView == nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        self.alpha = 0;
        CGRect rect = topView.frame;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
            topView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (finished) {
                self.alpha = 1;
                topView.frame = rect;
            }
        }];
    }
}


#pragma mark -------------------------------- 点击确定
- (void)okBtnAction:(UIButton *)sender
{
    [InputTextField resignFirstResponder];
    if (InputTextField.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"还没有输入内容哦！"];
        return;
    }
    sender.enabled = NO;
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(JWInputAlertViewClickActionWithString:)]) {
        [_inputDelegate JWInputAlertViewClickActionWithString:InputTextField.text];
    }
    [self dismiss];

}

- (void)dismiss
{
    UIView *sameView = [[UIApplication sharedApplication].keyWindow viewWithTag:401];
    if (sameView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [sameView removeFromSuperview];
                if (self) {
                    [self removeFromSuperview];
                }
            }
        }];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (curentType == JWInputNumberType && textField.text.length >= 5 &&![string isEqualToString:@""]) {
        return NO;
        
    }
    if (curentType == JWInputPhoneType && textField.text.length >= 11 &&![string isEqualToString:@""]) {
        return NO;
        
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --------------------------------- 点击空白区域
- (void)tapSelfAction:(UITapGestureRecognizer *)tap
{
    [self dismiss];
    
}

@end
