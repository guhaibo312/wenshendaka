//
//  TJWCustomPickerView.m
//  temp
//
//  Created by 诸葛浩楠 on 15/2/14.
//  Copyright (c) 2015年 TJW. All rights reserved.
//

#import "TJWCustomPickerView.h"

@interface TJWCustomPickerView ()

{
    NSTimeInterval curentTime;
    NSMutableArray *firstArray;
    NSInteger currentRow1;
    NSInteger currentRow2;
    NSInteger currentRow3;
}
@end

@implementation TJWCustomPickerView

- (instancetype)initWithTitle:(NSString *)Ttitle delegate:(id<TJWCustomPickerViewDelegate>)Tdelegate cancelButtonTitle:(NSString *)cancleString complete:(NSString *)complentString
{
    self = [super init];
    if (self) {
        delegate = Tdelegate;
        self.frame = CGRectMake(0, SCREENHEIGHT-216, SCREENWIDTH, 216);
        [self initView:Ttitle cancelBtn:cancleString omplete:complentString];
    }
    return self;
}


- (void)initView:(NSString *)Ttitle cancelBtn:(NSString *)cancleString omplete:(NSString *)complentString
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH,0.5)];
    topLine.backgroundColor = [UIColor orangeColor];
    [self addSubview:topLine];
    
    if (complentString != nil) {
        UIButton *disBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [disBtn setFrame:CGRectMake(SCREENWIDTH-60, 0, 60, 40)];
        [disBtn setTitle:complentString forState:UIControlStateNormal];
        [disBtn setTitleColor:SCHEMOCOLOR forState:UIControlStateNormal];
        [disBtn setTitleColor:SCHEMOCOLORSELECT forState:UIControlStateHighlighted];
        disBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [disBtn addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disBtn];

    }
    if (Ttitle != nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, SCREENWIDTH-160, 40)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = Ttitle;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];

    }
    
    if (complentString != nil) {
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setFrame:CGRectMake(20, 0, 40, 40)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:SCHEMOCOLORSELECT forState:UIControlStateHighlighted];
        [cancleBtn setTitleColor:SCHEMOCOLOR forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBtn];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH,0.5)];
    lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [self addSubview:lineView];
    
    
    TpickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 41, SCREENWIDTH, self.bounds.size.height-41)];
    TpickerView.backgroundColor = [UIColor whiteColor];
    TpickerView.delegate = self;
    TpickerView.dataSource = self;
    [self addSubview:TpickerView];
    curentTime = [[NSDate date]timeIntervalSince1970];
    
    firstArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< 7; i++) {
        NSNumber *number = [NSNumber  numberWithDouble:curentTime+24*i*60*60];
        [firstArray addObject:number];
    }
    currentRow1 = 0;
    currentRow2 = 0;
    currentRow3 = 0;
    
    NSString *currenthhmm = [UIUtils intoMinuteFromTimestamp:[[NSDate date] timeIntervalSince1970]];
    NSArray *hhmmArray = [currenthhmm componentsSeparatedByString:@":"];
    int mm = [[hhmmArray lastObject] intValue];
    int hh = [[hhmmArray firstObject]intValue];


    if ((hh == 21 && mm >=45)|| hh >21) {
        currentRow1 = 1;
        [TpickerView selectRow:1 inComponent:0 animated:NO];
    }else{
        if (hh < 8) {
            currentRow2 = 0;
            [TpickerView selectRow:0 inComponent:1 animated:NO];
        }else {
            if (mm >=30) {
                currentRow2 = hh-7;
                currentRow3 = 0;
                [TpickerView selectRow:hh-7 inComponent:1 animated:NO];
                [TpickerView selectRow:0 inComponent:2 animated:NO];
            }else{
                currentRow2 = hh-8;
                currentRow3 = 2;
                [TpickerView selectRow:hh-8 inComponent:1 animated:NO];
                [TpickerView selectRow:2 inComponent:2 animated:NO];
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
    
    NSTimeInterval temp = [[firstArray objectAtIndex:currentRow1]doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:temp];
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MM月dd日"];
    
    NSString *title;
    title = [format stringFromDate:date];
    
    NSString *selectedYMD = [UIUtils findKeyFromTimestamp:temp];
    NSTimeInterval nowTime = [UIUtils timeFromString:selectedYMD];

    switch (currentRow1) {
        case 0:
            title = @"今天";
            break;
        case 1:
            title = @"明天";
        default:
            title = title;
            break;
    }
    
    NSString *hhStr;
    NSString *mmStr;
    
    currentRow2+=8;
    
    if (currentRow2 >9) {
        hhStr = [NSString stringWithFormat:@"%d",currentRow2];
    }else{
        hhStr = [NSString stringWithFormat:@"0%d",currentRow2];
    }
    
    int rowM = 0;
    if (currentRow3 == 0) {
        mmStr = [NSString stringWithFormat:@"00"];
        
    }else if (currentRow3 == 1){
        mmStr = [NSString stringWithFormat:@"15"];
        rowM = 15;
    }else if (currentRow3 == 2){
        mmStr = [NSString stringWithFormat:@"30"];
        rowM = 30;
    }else {
        mmStr = [NSString stringWithFormat:@"45"];
        rowM = 45;
    }
    
    NSString *selectedContent = [NSString stringWithFormat:@"%@\t%@ : %@",title,hhStr,mmStr];
    
    if ([delegate respondsToSelector:@selector(selectedContentAction:time:)]) {
        [delegate selectedContentAction:selectedContent time:nowTime + currentRow2*60*60+rowM*60];
    }
    
    [self animationStop];

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
            if (delegate && [delegate respondsToSelector:@selector(pickerDismiss)]) {
                [delegate pickerDismiss];
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
    if (component == 0)return 7;
    else if (component == 1) {
        return 14;
    }
    return 4;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (component == 0)return SCREENWIDTH/2-30;
    return SCREENWIDTH/4+15;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if (component == 0) {
        NSTimeInterval temp = [[firstArray objectAtIndex:row]doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:temp];
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"MM月dd日"];
        title = [format stringFromDate:date];
        switch (row) {
            case 0:
                title = @"今天";
                break;
            case 1:
                title = @"明天";
            default:
                title = title;
                break;
        }
        return title;
    }else if(component == 1){
        row+=8;
        if (row >9) {
            title = [NSString stringWithFormat:@"%d时",row];
        }else{
            title = [NSString stringWithFormat:@"0%d时",row];
        }
    }else {
        if (row == 0) {
            title = @"00";
        }else if (row == 1){

            title = @"15";
        }else if (row == 2){
            
            title = @"30";
        }else {
            
            title = @"45";
        }
    }
   
    return title;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) currentRow1 = row;
    else if (component == 1){
        currentRow2 = row;
    }else{
        currentRow3 = row;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
