//
//  JWInputAlertView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JWInputType) {
    JWInputPhoneType = 0,
    JWInputNumberType,
    JWInputTokenType
};
@protocol JWInputAlertViewDelegate <NSObject>

- (void)JWInputAlertViewClickActionWithString:(NSString *)contentStr;

@end
@interface JWInputAlertView : UIScrollView

{
    UILabel *titleLabel;
    UITextField *InputTextField;
    UIView *topView;
}
@property (nonatomic, assign) id<JWInputAlertViewDelegate> inputDelegate;

- (instancetype)initWithTitle:(NSString *)title inputType:(JWInputType)type delegate:(id<JWInputAlertViewDelegate>)delegate ButtonTittle:(NSString *)btnTitle;

- (void)show;

@end
