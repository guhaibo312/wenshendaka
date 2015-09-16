//
//  Bshopkeeper
//
//  Created by jinwei on 15/3/16.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CustomDatePicker.h"
#import "Configurations.h"


#define kCornerRadius 4 //圆角值
#define kNameColor [UIColor colorWithRed:255.0/255.0 green:134.0/255.0 blue:72.0/255.0 alpha:1.0]



@implementation CustomDatePicker


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        [self initView:frame];
    }
    return self;
}

+ (instancetype)initViewWithDelegate:(id<CustomDatePickerDelegate>)delegate
{
    CustomDatePicker *dataPicker;
    if (dataPicker) {
        [dataPicker removeFromSuperview];
        dataPicker = nil;
    }
    if (dataPicker == nil) {
        dataPicker = [[CustomDatePicker alloc]init];
        [dataPicker initView];
    }
    dataPicker.delegate = delegate;
    
    return dataPicker;
}


- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    dataLunarArrayMonth = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"腊月"];
    dataLunarArrayDay = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二十一",@"二十二",@"二十三",@"二十四",@"二十五",@"二十六",@"二十七",@"二十八",@"二十九",@"三十",@"三十一"];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    topView.backgroundColor = VIEWBACKGROUNDCOLOR;
    [self addSubview:topView];
    //当前值
    currentLabel = [UILabel labelWithFrame:CGRectMake(10, 0, 80, 40) fontSize:14 fontColor:[UIColor blackColor] text:@"1月1日"];
    [topView addSubview:currentLabel];
    
    //农历和公历
    gregorianBtn = [[UIButton alloc]initWithFrame:CGRectMake(currentLabel.right, 0,80 , 40)];
    [gregorianBtn setTitle:@"公历" forState:UIControlStateNormal];
    [gregorianBtn setTitle:@"公历" forState:UIControlStateSelected];
    [gregorianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gregorianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    gregorianBtn.selected = YES;
    islunar = NO;
    [gregorianBtn setBackgroundImage:[UIUtils imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [gregorianBtn setBackgroundImage:[UIUtils imageFromColor:SEGMENTSELECT] forState:UIControlStateSelected];
    [gregorianBtn addTarget:self action:@selector(chooseLunarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:gregorianBtn];
    
    lunarBtn = [[UIButton alloc]initWithFrame:CGRectMake(gregorianBtn.right, 0,80 , 40)];
    [lunarBtn setTitle:@"农历" forState:UIControlStateNormal];
    [lunarBtn addTarget:self action:@selector(chooseLunarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [lunarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lunarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [lunarBtn setTitle:@"农历" forState:UIControlStateSelected];
    [lunarBtn setBackgroundImage:[UIUtils imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [lunarBtn setBackgroundImage:[UIUtils imageFromColor:SEGMENTSELECT] forState:UIControlStateSelected];
    [topView addSubview:lunarBtn];

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    topLine.backgroundColor = LINECOLOR;
    [topView addSubview:topLine];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(gregorianBtn.left-0.5, 0, 0.5, 40)];
    leftLine.backgroundColor = LINECOLOR;
    [topView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(lunarBtn.right, 0, 0.5, 40)];
    rightLine.backgroundColor = LINECOLOR;
    [topView addSubview:rightLine];

    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREENWIDTH, 0.5)];
    bottomLine.backgroundColor = [UIColor blackColor];
    [topView addSubview:bottomLine];
    
    UIButton *disBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [disBtn setFrame:CGRectMake(SCREENWIDTH-60, 0, 60, 40)];
    [disBtn setTitle:@"OK" forState:UIControlStateNormal];
    [disBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [disBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    disBtn.backgroundColor = [UIColor colorWithRed:58/255.0f green:54/255.0 blue:50/255.0 alpha:1];
    disBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    [disBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:disBtn];

    currentRow1 = 0;
    currentRow2 = 0;
    datePicerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 216)];
    datePicerView.backgroundColor = [UIColor whiteColor];
    datePicerView.delegate = self;
    datePicerView.dataSource = self;
    [self addSubview:datePicerView];
    [datePicerView selectRow:0 inComponent:0 animated:NO];
    [datePicerView selectRow:0 inComponent:1 animated:NO];
    datePicerView.userInteractionEnabled = YES;
    
}

- (void)setCurrentDatelunar:(BOOL)lunar month:(NSInteger)month day:(NSInteger)day
{
    currentRow1 = month-1;
    currentRow2 = day-1;
    islunar = lunar;
    if (lunar) {
        [self chooseLunarBtnAction:lunarBtn];
    }else{
        [self chooseLunarBtnAction:gregorianBtn];
    }
    [datePicerView selectRow:currentRow1 inComponent:0 animated:NO];
    [datePicerView selectRow:currentRow2 inComponent:1 animated:NO];
}


#pragma mark-one  格式化时间
- (void)gogetData
{
    if (islunar) {
        NSString *resultStr = [NSString stringWithFormat:@"%@%@",[dataLunarArrayMonth objectAtIndex:currentRow1],[dataLunarArrayDay objectAtIndex:currentRow2]];
        currentLabel.text = resultStr;
        currentStr = resultStr;

    }else{
        NSString *resultStr = [NSString stringWithFormat:@"%d月%d日",currentRow1+1,currentRow2+1];
        currentLabel.text = resultStr;
        currentStr = resultStr;
    }
    
}

#pragma mark -- 载入，注销动画
- (void)show
{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *haveView = [keyWindow viewWithTag:100];
    if (haveView) {
        return;
    }
    UIView *customView = [[UIView alloc]initWithFrame:keyWindow.bounds];
    customView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];
    customView.tag = 100;
    customView.alpha = 0;
    [keyWindow addSubview:customView];
    self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 256);
    
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREENHEIGHT-256, SCREENWIDTH, 256);
        customView.alpha = 0;

    } completion:^(BOOL finished) {
        if (finished) {
            customView.alpha = 1;
            self.frame = CGRectMake(0, SCREENHEIGHT-256, SCREENWIDTH, 256);
            
        }
    }];
}
- (void)animationStop
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *customView = [keyWindow viewWithTag:100];
    
    [UIView animateWithDuration:0.30 animations:^{
        if (customView) {
            customView.alpha = 0;
        }
        self.frame = CGRectMake(0, SCREENHEIGHT, self.width, self.height);
    } completion:^(BOOL finished) {
        if (finished == YES) {
            if (customView) {
                [customView removeFromSuperview];
            }
            [self removeFromSuperview];
        }
    }];
}


#pragma mark -- 取消按钮action
- (void)dismissAction
{
   
    
    if ([self.delegate respondsToSelector:@selector(selectDate: isLunar: withMonth:day:)]) {
        [self.delegate selectDate:currentStr isLunar:islunar withMonth:currentRow1+1 day:currentRow2+1];
    }
    [self animationStop];

}
- (void)chooseLunarBtnAction:(UIButton *)sender
{
    
    if (sender == lunarBtn) {
        islunar = YES;
        gregorianBtn.selected = NO;
        lunarBtn.selected = YES;
        [datePicerView reloadAllComponents];
    }else{
        gregorianBtn.selected = YES;
        lunarBtn.selected = NO;
        islunar = NO;
        [datePicerView reloadAllComponents];
    }
    [self pickerView:datePicerView didSelectRow:currentRow1 inComponent:0];
    [self pickerView:datePicerView didSelectRow:currentRow2 inComponent:1];
    
    

}
#pragma mark -------------------------pickerDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 12;
    }
    if (islunar) {
        return 30;
    }else{
        if (currentRow1+1 == 2) {
            return 29;
        }else if (currentRow1+1 ==4  || currentRow1+1 == 6 ||currentRow1+1 == 9  || currentRow1+1 == 11){
            return 30;
        }else{
            return 31;
        }
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        if (islunar) {
            return [dataLunarArrayMonth objectAtIndex:row];
        }else{
            return [NSString stringWithFormat:@"%d月",row+1];
        }
        
    }else{
        if (islunar) {
            return [dataLunarArrayDay objectAtIndex:row];
        }else{
            return [NSString stringWithFormat:@"%d日",row+1];
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        currentRow1 = row;
        
        if (islunar) {
            if (currentRow2 >29) {
                currentRow2 = 29;
            }
        }else {
            if (currentRow1+1 == 2) {
                if (currentRow2 >28) {
                    currentRow2 = 28;
                }
            }else if (currentRow1+1 ==4  || currentRow1+1 == 6 ||currentRow1+1 == 9  || currentRow1+1 == 11){
                if (currentRow2 >29) {
                    currentRow2 = 29;
                }
            }

        }
       [datePicerView reloadComponent:1];

    }else{
        currentRow2 = row;
    }
    [self gogetData];
}

@end
