//
//  TJWWorkTimePicker.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/29.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "TJWWorkTimePicker.h"
#import "Configurations.h"


@interface TJWWorkTimePicker()

{
    NSInteger currentRow1;
    NSInteger currentRow2;
}

@end

@implementation TJWWorkTimePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCurrentTime:(NSString *)currentTime delegate:(id<WorkTimeSelectdDelegate>)Tdelegate
{
    self = [super init];
    if (self) {
        delegate = Tdelegate;
        self.frame = CGRectMake(0, SCREENHEIGHT-220, SCREENWIDTH, 220);
        [self initView:currentTime];
    }
    return self;
}


- (void)initView:(NSString *)Ttitle
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH,0.5)];
    topLine.backgroundColor = LINECOLOR;
    [self addSubview:topLine];
    
    UIButton *disBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [disBtn setFrame:CGRectMake(SCREENWIDTH-60, 0, 60, 44)];
    [disBtn setTitle:@"OK" forState:UIControlStateNormal];
    [disBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [disBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    disBtn.backgroundColor = [UIColor colorWithRed:58/255.0f green:54/255.0 blue:50/255.0 alpha:1];
    disBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    [disBtn addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:disBtn];
    
    currentLabel = [UILabel labelWithFrame:CGRectMake(20, 0, SCREENWIDTH-100, 43) fontSize:16 fontColor:[UIColor blackColor] text:@""];
    currentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:currentLabel];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREENWIDTH,0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [self addSubview:lineView];
    
    
    
    datePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREENWIDTH, self.bounds.size.height-44)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.delegate = self;
    datePicker.dataSource = self;
    [self addSubview:datePicker];
    currentRow1 = 0;
    currentRow2 = 27;
    
    [datePicker selectRow:0 inComponent:0 animated:NO];
    [datePicker selectRow:28 inComponent:1 animated:NO];
    currentLabel.text = @"08:00-22:00";

    if (Ttitle) {
        NSArray *resultArray = [Ttitle componentsSeparatedByString:@"-"];
        if (resultArray.count== 2) {
            NSArray *startT = [(NSString *)[resultArray firstObject]componentsSeparatedByString:@":"];
            NSArray *endT = [(NSString *)[resultArray lastObject]componentsSeparatedByString:@":"];
            if (startT.count == 2 && endT.count == 2) {
                int a = [[startT firstObject]intValue]-8 ;
                int b = [[endT firstObject]intValue]-8 ;
                if (a >0 && b >0 && a< 23 && b<23) {
                    currentRow1 = a;
                    currentRow2 = b;
                    [datePicker selectRow:a inComponent:0 animated:NO];
                    [datePicker selectRow:b inComponent:1 animated:NO];
                    currentLabel.text = Ttitle;
                }
            }
        }
    }

   
}

#pragma mark ---------取消
- (void)cancleAction:(id)sender
{
    [self animationStop];
}

#pragma mark ------确定
- (void)dismissAction:(id)sender
{
    [self setCurrentLabelText];
    
    if ([delegate respondsToSelector:@selector(selectedWorkTime:)]) {
        [delegate selectedWorkTime:currentLabel.text];
    }
    [self animationStop];
    
}

- (void)setCurrentLabelText
{
   
    NSString *startTime = [NSString stringWithFormat:@"%d:%@",currentRow1%2==0?currentRow1/2+8:(currentRow1+1)/2+7,currentRow1%2==0?@"00":@"30"];
    NSString *endTime = [NSString stringWithFormat:@"%d:%@",currentRow2%2==0?currentRow2/2+8:(currentRow2+1)/2+7,currentRow2%2==0?@"00":@"30"];
    if (currentRow1 <4) {
        startTime = [NSString stringWithFormat:@"0%d:%@",currentRow1%2==0?currentRow1/2+8:(currentRow1+1)/2+7,currentRow1%2==0?@"00":@"30"];
    }
    if (currentRow2 < 4) {
        endTime = [NSString stringWithFormat:@"0%d:%@",currentRow2%2==0?currentRow2/2+8:(currentRow2+1)/2+7,currentRow2%2==0?@"00":@"30"];
    }
    currentLabel.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];

}

- (void)animationStop
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *customView = [keyWindow viewWithTag:100];
    
    [UIView animateWithDuration:0.30 animations:^{
        
        self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, self.width);
        if (customView) {
            customView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        if (finished == YES) {
            if (customView) {
                [customView removeFromSuperview];
            }
            if (delegate && [delegate respondsToSelector:@selector(workTimePickerDissmiss)]) {
                [delegate workTimePickerDissmiss];
            }
        }
    }];
}

#pragma mark -- 显示
- (void)show
{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *customView = [[UIView alloc]initWithFrame:keyWindow.bounds];
    customView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];
    customView.tag = 100;
    customView.alpha = 0;
    [keyWindow addSubview:customView];
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, SCREENHEIGHT - self.height , self.width, self.height);
        customView.alpha = 1;
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.frame = CGRectMake(0, SCREENHEIGHT - self.height , self.width, self.height);
            customView.alpha = 1;
        }
    }];
    
    
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 29;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREENWIDTH/2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (row < 4) {
        return [NSString stringWithFormat:@"0%d:%@",row%2==0?row/2+8:(row+1)/2+7,row%2==0?@"00":@"30"];
    }
    return  [NSString stringWithFormat:@"%d:%@",row%2==0?row/2+8:(row+1)/2+7,row%2==0?@"00":@"30"];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        currentRow1 = row;
    }else{
        currentRow2 = row;
    }
    [self setCurrentLabelText];
}



@end
