//
//  FilledColorButton.h
//  SymptomChecker
//
//  Created by suning on 14-8-29.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    kFilledBtnGeeen = 0xFFFF,
    kFilledBtnWhite,
    kFilledBtnBlue,
    kFilledBtnGray,
    kFilledBtnRed,
    kFilledBtnOrange,
    kFilledBtnClear,            // 透明的
    kFilledBtnCustomColor,
    KFilledBtnDelegate,       //删除
    kFilledBtnNone,
} FilledColorTyle;

@interface FilledColorButton : UIButton {
    UILabel* _titleLabel;
}
@property (nonatomic, strong) UIColor *backGroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) NSInteger fontSize;
@property (nonatomic) BOOL isBold;

- (id) initWithFrame:(CGRect)frame type:(FilledColorTyle) type title:(NSString*) title;
- (id) initWithFrame:(CGRect)frame type:(FilledColorTyle)type title:(NSString *)title fontSize:(NSInteger) size isBold:(BOOL) isbold;
- (id) initWithFrame:(CGRect)frame color:(UIColor*)color borderColor:(UIColor*)borderColor textClolr:(UIColor*)textColor title:(NSString *)title fontSize:(NSInteger) size isBold:(BOOL) isbold;


// 初始化之后还能做修改
- (void) setTitle:(NSString *)title;
- (void) bindType:(FilledColorTyle) type title:(NSString*) title;
- (void) bindColor:(UIColor*)color borderColor:(UIColor*)borderColor textClolr:(UIColor*)textColor title:(NSString *)title fontSize:(NSInteger) size isBold:(BOOL) isbold;

- (void)setTitleLabelFrame:(CGRect)frame;

- (NSString *)getCurrentTitle;

@end
