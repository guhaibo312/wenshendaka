//
//  JWEditView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/17.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWEditView.h"
#import "Configurations.h"

@implementation JWEditView


/*
 *初始化方法
 **/
- (instancetype)initWithFrame:(CGRect)frame withTitleLabel:(NSString *)title type:(JWEditType)type detailImgName:(NSString*)detailImg
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, frame.size.height)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.text = title;
        _titleLabel.textColor = GRAYTEXTCOLOR;
        [self addSubview:_titleLabel];
        
        
        if (type == JWEditLable) {
            
            if (detailImg) {
                _rightImg = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width - 20, frame.size.height/2- 5,6 , 10)];
                _rightImg.image = [UIImage imageNamed:detailImg];
                
                [self addSubview:_rightImg];
            }
            
            float rightW = _rightImg?140:120;
            _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, frame.size.width - rightW, frame.size.height)];
            _detailLabel.textAlignment = NSTextAlignmentRight;
            _detailLabel.font = [UIFont systemFontOfSize:16];
            _detailLabel.backgroundColor = [UIColor whiteColor];
            _detailLabel.numberOfLines = 0;
            [self addSubview:_detailLabel];
        

        }else if (type == JWEditTextField){
            
            _editTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 0, frame.size.width-120, frame.size.height)];
            _editTextField.font = [UIFont systemFontOfSize:16];
            _editTextField.returnKeyType = UIReturnKeyDone;
            _editTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self addSubview:_editTextField];
            
        }else{
            
            _editTextView = [[UITextView alloc]initWithFrame:CGRectMake(100, 5, frame.size.width - 120, frame.size.height-10)];
            _editTextView.font = [UIFont systemFontOfSize:16];
            [self addSubview:_editTextView];
            
            _textViewPlaceHolder = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, frame.size.width- 120, 40)];
            _textViewPlaceHolder.backgroundColor = [UIColor clearColor];
            _textViewPlaceHolder.hidden = YES;
            _textViewPlaceHolder.font = [UIFont systemFontOfSize:16];
            _textViewPlaceHolder.numberOfLines = 0;
            _textViewPlaceHolder.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
            _textViewPlaceHolder.userInteractionEnabled = NO;
            [self addSubview:_textViewPlaceHolder];


        }
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height -0.5, frame.size.width, 0.5)];
        _lineView.backgroundColor = LINECOLOR;
        [self addSubview:_lineView];
    }
    
    return self;
}

// 添加点击方法
- (void)setClickAction:(SEL)sel responder:(id)object
{
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.tag = self.tag;
    selectBtn.backgroundColor = [UIColor clearColor];
    selectBtn.frame = CGRectMake(70, 0, self.frame.size.width- 70, self.frame.size.height- 1);
    [selectBtn addTarget:object action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
}

/*设置详细大小
 **/
- (void)setDetailLabelHeight:(float)height
{
    self.detailLabel.height = height;
    self.height = height;
    _lineView.top = height-0.5;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
