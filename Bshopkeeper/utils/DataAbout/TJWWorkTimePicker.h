//
//  TJWWorkTimePicker.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/29.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WorkTimeSelectdDelegate <NSObject>
@optional
- (void)selectedWorkTime:(NSString *)content;
- (void)workTimePickerDissmiss;

@end

@interface TJWWorkTimePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

{
    UIPickerView *datePicker;
    UILabel *currentLabel;
    id<WorkTimeSelectdDelegate> delegate;
    
}

- (void)show;

- (instancetype)initWithCurrentTime:(NSString *)currentTime delegate:(id<WorkTimeSelectdDelegate>)Tdelegate;
@end



