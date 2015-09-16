//
//  TJWCustomPickerView.h
//  temp
//
//  Created by 诸葛浩楠 on 15/2/14.
//  Copyright (c) 2015年 TJW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"

@protocol TJWCustomPickerViewDelegate;

@interface TJWCustomPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *TpickerView;
    id<TJWCustomPickerViewDelegate> delegate;
}

- (void)show;

- (instancetype)initWithTitle:(NSString *)Ttitle delegate:(id<TJWCustomPickerViewDelegate>)Tdelegate cancelButtonTitle:(NSString *)cancleString complete:(NSString *)complentString;
@end

@protocol TJWCustomPickerViewDelegate <NSObject>

@optional
- (void)selectedContentAction:(NSString *)content time:(NSTimeInterval)tamp;
- (void)pickerDismiss;
@end

