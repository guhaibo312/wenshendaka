//
//  EditOrAddOrderViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/20.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "EditOrAddOrderViewController.h"
#import "Configurations.h"
#import "OrderModel.h"
#import "OrderManageCenterViewController.h"
#import "TJWCustomPickerView.h"
#import "UIImageView+WebCache.h"
#import "JWEditView.h"
#import "UserHomeBtn.h"

@interface EditOrAddOrderViewController ()<UITextFieldDelegate,TJWCustomPickerViewDelegate,UIActionSheetDelegate,UITextViewDelegate>
{
    BOOL isAdd;                                     //是否是添加
    BOOL isToHome;                                  //默认上门
    
    NSTimeInterval currentTime;                     //当前时间
    UIScrollView *backScroll;                       //滑动的图
    
    JWEditView *nameItem;                           //名称
    JWEditView *phoneItem;                          //电话
    JWEditView *ordertimeItem;                      //服务时间
    JWEditView *orderRemark;                        //备注
    
    TJWCustomPickerView *datePicker;                //预约时间
    
}

@property (nonatomic, strong) OrderModel *currentOrder;

@end

@implementation EditOrAddOrderViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            isAdd = [query[@"isAdd"] boolValue];
            _currentOrder = query[@"item"];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (isAdd) {
        self.title = @"登记预约";
    }else{
        self.title = @"编辑预约";
    }
    
    [self setRightNavigationBarTitle:@"保存" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    
    //初始化
    [self initWithSubViews];
    
    //复值
    [self reloadData];
    
}
#pragma mark --------------------- 初始化

- (void)initWithSubViews
{
    isToHome = YES;
    backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScroll.scrollEnabled = YES;
    backScroll.backgroundColor = VIEWBACKGROUNDCOLOR;
    backScroll.showsHorizontalScrollIndicator = NO;
    backScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backScroll];
    
    //姓名
    nameItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) withTitleLabel:@"姓名" type:JWEditTextField detailImgName:nil];
    nameItem.editTextField.placeholder = @"无";
    nameItem.editTextField.delegate = self;
    [backScroll addSubview:nameItem];
    
    //手机
    phoneItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, nameItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"电话" type:JWEditTextField detailImgName:nil];
    phoneItem.editTextField.delegate = self;
    phoneItem.editTextField.placeholder = @"无";
    phoneItem.editTextField.keyboardType =UIKeyboardTypeNumberPad;
    [backScroll addSubview:phoneItem];
    
    //服务时间
    ordertimeItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, phoneItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"服务时间" type:JWEditTextField detailImgName:nil];
    ordertimeItem.editTextField.userInteractionEnabled = NO;
    ordertimeItem.editTextField.placeholder = @"无";
    [ordertimeItem setClickAction:@selector(clickTaptimeAction:) responder:self];
    ordertimeItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    [backScroll addSubview:ordertimeItem];
    
    //备注
    orderRemark = [[JWEditView alloc]initWithFrame:CGRectMake(0, ordertimeItem.bottom, SCREENWIDTH, 88) withTitleLabel:@"备注" type:JWEditTextView detailImgName:nil];
    orderRemark.editTextView.delegate = self;
    orderRemark.titleLabel.height = 44;
    orderRemark.textViewPlaceHolder.text = @"无";
    orderRemark.textViewPlaceHolder.hidden = YES;
    [backScroll addSubview:orderRemark];
    backScroll.contentSize = CGSizeMake(SCREENWIDTH, orderRemark.bottom+40);
}


#pragma mark ------------------------- 点击完成

- (void)rightNavigationBarAction:(UIButton *)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if (nameItem.editTextField.text.length <1) {
        [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
        return;
    }
    if (![[JudgeMethods defaultJudgeMethods]contentTextIsPhoneNumber:phoneItem.editTextField.text] ) {
        [SVProgressHUD showErrorWithStatus:@"请填写正确的手机号"];
        return;
    }
    if (currentTime == 0) {
        [SVProgressHUD showErrorWithStatus:@"请填写预约时间"];
        return;
    }
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:isToHome?@"20":@"10" forKey:@"servicePlace"];
    [parm setObject:@"20001" forKey:@"serviceType"];
    [parm setObject:[NSNumber numberWithDouble:currentTime*1000] forKey:@"orderTime"];
    if (orderRemark.editTextView.text.length >= 1) {
        [parm setObject:orderRemark.editTextView.text forKey:@"remark"];
    }
    [parm setObject:@{} forKey:@"commodityInfo"];
    
    NSMutableDictionary *customerDict = [[NSMutableDictionary alloc]init];
    if (phoneItem.editTextField.text.length >1) {
        [customerDict setObject:phoneItem.editTextField.text forKey:@"phonenum"];
    }
    if ([NSObject nulldata:nameItem.editTextField.text]) {
        [customerDict setObject:nameItem.editTextField.text forKey:@"name"];

    }
    
    [parm setObject:[customerDict JSONString] forKey:@"customerInfo"];
    
    [LoadingView show:@"请稍候..."];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
//    [parm setObject:[NSNumber numberWithInt:[_currentOrder.orderStatus intValue]] forKey:@"orderStatus"];
    if (!isAdd) {
        [_currentOrder upDataFromDict:parm];
        [parm setObject:_currentOrder._id forKey:@"_id"];
        [[JWNetClient defaultJWNetClient]postNetClient:@"Order/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (self == NULL) return ;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {
                        OrderManageCenterViewController *orderVC = (OrderManageCenterViewController *)controller;
                        [orderVC changeList];
                    }
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:kEditOrderSucessNotice object:_currentOrder];
                [self backAction];
            }
        }];
        return;
    }else{
        [parm setObject:@"31" forKey:@"orderFrom"];
        [parm setObject:@"11" forKey:@"orderStatus"];
        [[JWNetClient defaultJWNetClient]putNetClient:@"Order/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (self == NULL) return ;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {

                        OrderManageCenterViewController *ordervc = (OrderManageCenterViewController *)controller;
                        [ordervc changeList];
                        [ordervc addOrderCompleteScrollToHistory];
                        [self.navigationController popToViewController:ordervc animated:YES];
                    }
                }

            }
        }];
    }

}

#pragma mark ------------------------- tjwDatePicker Delegate
- (void)selectedContentAction:(NSString *)content time:(NSTimeInterval)tamp
{
    ordertimeItem.editTextField.text = content;
    currentTime = tamp;
}
- (void)pickerDismiss
{
    if (datePicker) {
        [datePicker removeFromSuperview];
        datePicker = nil;
    }
}

#pragma mark ------------------------- 点击时间
- (void)clickTaptimeAction:(UITapGestureRecognizer *)tap
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (datePicker) {
        [datePicker removeFromSuperview];
        datePicker = nil;
    }
    if (datePicker == nil) {
        datePicker = [[TJWCustomPickerView alloc]initWithTitle:@"选择预约时间" delegate:self cancelButtonTitle:nil complete:@"完成"];
        [datePicker show];
    }
}
#pragma mark ------------------------- textfield Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (datePicker) {
        [datePicker removeFromSuperview];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phoneItem.editTextField && textField.text.length >=11 && ![string isEqualToString:@""]) {
        return NO;
    }
    if (textField == nameItem.editTextField && textField.text.length >=15 && ![string isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView== orderRemark.editTextView) {
        if (textView.text.length <=1 && [text isEqualToString:@""] ) {
            orderRemark.textViewPlaceHolder.hidden = NO;
        }else{
            orderRemark.textViewPlaceHolder.hidden = YES;
        }
    }
    
    if (textView == orderRemark.editTextView && textView.text.length >=64 && ![text isEqualToString:@""]) {
        return NO;
    }
    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    // Dispose of any resources that can be recreated.
}


- (void)reloadData
{
    if (_currentOrder) {
       
        //备注
        if ([NSObject nulldata:_currentOrder.remark]) {
            orderRemark.editTextView.text = _currentOrder.remark;
            orderRemark.textViewPlaceHolder.hidden = YES;
        }else{
            orderRemark.textViewPlaceHolder.hidden = NO;
        }
        
        //时间
        if (_currentOrder.orderTime) {
            currentTime = [_currentOrder.orderTime doubleValue]/1000;
            ordertimeItem.editTextField.text = [UIUtils intoMMDDHHmmFrom:currentTime];

        }
        
        //姓名和电话
        nameItem.editTextField.text = _currentOrder.resultname;
        phoneItem.editTextField.text = _currentOrder.resultphone;
        
    }else{
        orderRemark.textViewPlaceHolder.hidden = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
