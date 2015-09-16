//
//  ToHomeSettingViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//


#import "ToHomeSettingViewController.h"
#import "JWEditView.h"

@interface ToHomeSettingViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    JWEditView *toHomeItem;                 //上门服务
    UISwitch *toHomeSwitch;                 //上门按钮
    
    JWEditView *servicePlaceItem;           //服务范围
    JWEditView *needItem;                   //服务须知
    UIView *bottomView;                     //开启后下面的层
    UIScrollView *backScrollView;           //滑动层
    
    NSMutableDictionary *parm;              //参数
}
@end

@implementation ToHomeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"上门服务设置";
    
    [self setRightNavigationBarTitle:@"保存" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.backgroundColor = VIEWBACKGROUNDCOLOR;
    [self.view addSubview:backScrollView];
    
    //上门服务
    toHomeItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) withTitleLabel:@"上门服务" type:JWEditLable detailImgName:nil];
    toHomeSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREENWIDTH- 60, 7, 50, 30)];
    toHomeSwitch.onTintColor = TABSELECTEDCOLOR;
    toHomeSwitch.tintColor = LINECOLOR;
    [toHomeSwitch addTarget:self action:@selector(openToHomeSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    [toHomeItem addSubview:toHomeSwitch];
    [backScrollView addSubview:toHomeItem];
    
    
    //bottomview
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 54, SCREENWIDTH, 88*2)];
    [backScrollView addSubview:bottomView];
    
    //服务范围
    servicePlaceItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 88) withTitleLabel:@"服务范围" type:JWEditTextView detailImgName:nil];
    servicePlaceItem.titleLabel.height = 50;
    servicePlaceItem.textViewPlaceHolder.text = @"请输入服务城区、街道或者小区...";
    [servicePlaceItem.textViewPlaceHolder sizeToFit];
    servicePlaceItem.textViewPlaceHolder.top = 10;
    servicePlaceItem.textViewPlaceHolder.hidden = YES;
    servicePlaceItem.editTextView.delegate = self;
    [bottomView addSubview:servicePlaceItem];
    
    //预约须知
    needItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, servicePlaceItem.bottom, SCREENWIDTH, 88) withTitleLabel:@"预约须知" type:JWEditTextView detailImgName:nil];
    needItem.editTextView.delegate = self;
    needItem.titleLabel.height = 50;
    needItem.textViewPlaceHolder.text = @"收到预约信息后，我会尽快与您联系！";
    [needItem.textViewPlaceHolder sizeToFit];
    needItem.textViewPlaceHolder.top = 10;
    [bottomView addSubview:needItem];
    needItem.textViewPlaceHolder.hidden = YES;
    parm  = [NSMutableDictionary dictionary];
    [self reloadData];
}

- (void)backAction
{
    if ([[User defaultUser].storeItem.serviceToHome intValue] != toHomeSwitch.on) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存当前修改的内容？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        alert.tag = 5;
        [alert show];
        return;
    }
    if ([NSObject nulldata:[User defaultUser].storeItem.serviceArea ]) {
        if (![[User defaultUser].storeItem.serviceArea isEqual:servicePlaceItem.editTextView.text]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存当前修改的内容？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
            alert.tag = 5;
            [alert show];
            return;
        }
    }else if (servicePlaceItem.editTextView.text.length >1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存当前修改的内容？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        alert.tag = 5;
        [alert show];
        return;
    }
    
    if ([NSObject nulldata: [User defaultUser].storeItem.orderNotice ] ) {
        if (![[User defaultUser].storeItem.orderNotice isEqual:needItem.editTextView.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存当前修改的内容？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
            alert.tag = 5;
            [alert show];
            return;
        }
    }else if (needItem.editTextView.text.length >1){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存当前修改的内容？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        alert.tag = 5;
        [alert show];
        return;
    }
    
    [super backAction];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 5 && buttonIndex == 1) {
        [self rightNavigationBarAction:nil];
    }else{
        if (self) {
            [super backAction];
        }
    }
}


#pragma mark -------------------------------- 点击完成
- (void)rightNavigationBarAction:(UIButton *)sender
{
    [servicePlaceItem.editTextView resignFirstResponder];
    [needItem.editTextView resignFirstResponder];
    
    [parm removeAllObjects];
    [parm setObject:toHomeSwitch.on?@"1":@"0" forKey:@"serviceToHome"];
    if (toHomeSwitch.on == YES) {
        if (servicePlaceItem.editTextView.text.length <1) {
            [SVProgressHUD showErrorWithStatus:@"请填写服务范围"];
            return;
        }
        [parm setObject:servicePlaceItem.editTextView.text forKey:@"serviceArea"];
        if (needItem.editTextView.text.length >=1) {
            [parm setObject:needItem.editTextView.text forKey:@"orderNotice"];
        }
    }
    
    [LoadingView show:@"请稍候..."];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[JWNetClient defaultJWNetClient]postNetClient:@"Store/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
        
        
        if ([self WhetherInMemoryOfChild]) {
            [LoadingView dismiss];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                [[User defaultUser] changeUserInfo:nil storeInf:parm];
                [[NSNotificationCenter defaultCenter] postNotificationName:kEDITUSERINFOSUCESS object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}


- (void)reloadData
{
    if ([[User defaultUser].storeItem.serviceToHome intValue] == 0) {
        toHomeSwitch.on = NO;
        bottomView.hidden = YES;
    }else{
        toHomeSwitch.on = YES;
        bottomView.hidden =NO;
    }
    if ([NSObject nulldata:[User defaultUser].storeItem.serviceArea]) {
        servicePlaceItem.editTextView.text = [User defaultUser].storeItem.serviceArea;
    }else{
        servicePlaceItem.textViewPlaceHolder.hidden = NO;
    }
    if ([NSObject nulldata:[User defaultUser].storeItem.orderNotice]) {
        needItem.editTextView.text = [User defaultUser].storeItem.orderNotice;
    }else{
        needItem.textViewPlaceHolder.hidden = NO;
    }
    
    
}

#pragma mark ------------------------------ 开关
- (void)openToHomeSwitchAction:(UISwitch *)sender
{
    if (sender.on == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            bottomView.frame = CGRectMake(0, 54, SCREENWIDTH, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                bottomView.frame = CGRectMake(0, 54, SCREENWIDTH, 0);
                bottomView.hidden = YES;
            }
        }];
    }else{
        bottomView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            bottomView.frame = CGRectMake(0, 54, SCREENWIDTH, 88*2);
        } completion:^(BOOL finished) {
            if (finished) {
                bottomView.frame = CGRectMake(0, 54, SCREENWIDTH, 88*2);
                bottomView.hidden = NO;
            }
            
        }];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView== servicePlaceItem.editTextView) {
        if (textView.text.length <=1 && [text isEqualToString:@""] ) {
            servicePlaceItem.textViewPlaceHolder.hidden = NO;
        }else{
            servicePlaceItem.textViewPlaceHolder.hidden = YES;
        }
    }
    
    if (textView== needItem.editTextView) {
        if (textView.text.length <=1 && [text isEqualToString:@""] ) {
            needItem.textViewPlaceHolder.hidden = NO;
        }else{
            needItem.textViewPlaceHolder.hidden = YES;
        }
    }

    
    if (textView == servicePlaceItem.editTextView && textView.text.length >=30 && ![text isEqualToString:@""] ) {
        return NO;
    }
    if (textView == needItem.editTextView && textView.text.length >=60 && ![text isEqualToString:@""] ) {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
