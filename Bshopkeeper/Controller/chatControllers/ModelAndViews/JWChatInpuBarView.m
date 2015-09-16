//
//  JWChatInpuBarView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/25.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatInpuBarView.h"
#import "NSString+Extension.h"
#import "Configurations.h"

@interface JWChatInpuBarView ()<UITextViewDelegate>

@end

@implementation JWChatInpuBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
        topLineView.backgroundColor = LINECOLOR;
        [self addSubview:topLineView];
        
        _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, SCREENWIDTH-60, 30)];
        _inputTextView.font = [UIFont systemFontOfSize:14];
        _inputTextView.backgroundColor = VIEWBACKGROUNDCOLOR;
        _inputTextView.textAlignment = NSTextAlignmentLeft;
        _inputTextView.layer.cornerRadius = 5;
        _inputTextView.delegate = self;
        _inputTextView.layer.borderColor = LINECOLOR.CGColor;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.clipsToBounds = YES;
        [self addSubview:_inputTextView];
        
        _actionbutton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 0, 40, 40)];
        _actionbutton.backgroundColor = [UIColor clearColor];
        [_actionbutton setImage:[UIImage imageNamed:@"icon_chat_acitonButton.png"] forState:UIControlStateNormal];
        [_actionbutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_actionbutton addTarget:self action:@selector(clickActionButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actionbutton];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_inputTextView) {
        _inputTextView.frame = CGRectMake(10, 5, SCREENWIDTH-60, frame.size.height-10);
    }
    
}


- (void)clickActionButton
{
    if (_delegate && [_delegate respondsToSelector:@selector(actionButton)]) {
        [_delegate actionButton];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSMutableString *contentString = [[NSMutableString alloc]initWithString:textView.text];
    
    [contentString replaceCharactersInRange:range withString:text];
    
    float stringHeight = [contentString sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREENWIDTH-60, 800)].height+16;
    float result = stringHeight;
    if (stringHeight <= 30) {
        result = 30;
    }else if (stringHeight >=14*4+8){
        result = 14*4+8;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(resetInputViewHeight:)]) {
        [_delegate resetInputViewHeight:result];
    }
    
    if ([text isEqualToString:@"\n"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(sendMessage:)]) {
            [_delegate sendMessage:textView.text];
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)dealloc{
    self.inputTextView = nil;
    self.actionbutton = nil;

}



@end
