//
//  JWEditView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/17.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JWEditType) {
    JWEditLable = 0, // default
    JWEditTextField,
    JWEditTextView,
};

@interface JWEditView : UIView
{
    UIButton *selectBtn;    //选中之后
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextField *editTextField;
@property (nonatomic, strong) UITextView *editTextView;
@property (nonatomic, strong) UILabel *textViewPlaceHolder;
@property (nonatomic, strong) UIImageView *rightImg;

@property (nonatomic, strong) UIView *lineView;

/*
 *初始化方法
 **/
- (instancetype)initWithFrame:(CGRect)frame withTitleLabel:(NSString *)title type:(JWEditType)type detailImgName:(NSString*)detailImg;

// 添加点击方法
- (void)setClickAction:(SEL)sel responder:(id)object;

/*设置详细大小
 **/
- (void)setDetailLabelHeight:(float)height;


@end
