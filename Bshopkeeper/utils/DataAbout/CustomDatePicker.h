//
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
///

#import <UIKit/UIKit.h>
@class CustomDatePicker;

@protocol CustomDatePickerDelegate <NSObject>

- (void)selectDate:(NSString *)selectDate isLunar:(BOOL)islunar withMonth:(NSInteger)month day:(NSInteger )day;

@end

@interface CustomDatePicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *datePicerView;
    UILabel *currentLabel;
    
    UIButton *lunarBtn;    //农历
    UIButton *gregorianBtn;   //公历
    
    BOOL islunar;       //是否是农历
    
    NSInteger currentRow1;
    NSInteger currentRow2;
    NSArray *dataLunarArrayMonth;
    NSArray *dataLunarArrayDay;
    NSString *currentStr;           //当前时间
}

- (void)setCurrentDatelunar:(BOOL)lunar month:(NSInteger)month day:(NSInteger)day;

@property (nonatomic, assign) id<CustomDatePickerDelegate>delegate;

/**
 *custom initial method
 */
+ (instancetype)initViewWithDelegate:(id<CustomDatePickerDelegate>)delegate;

/**
 *showCustomDatePicker
 */
- (void)show;

@end