//
//  FindPasswordViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "RegistCompleteViewController.h"
#import "LogInViewController.h"
#import <MessageUI/MessageUI.h>


#define GrayColorLine [UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1]

@interface FindPasswordViewController ()<UITextFieldDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate>
{
    JWTextField *phonenumField;      //手机号输入
    JWTextField *codeField;          //验证码
    JWTextField *password;           //密码
    FilledColorButton *completeBtn ; //完成
    FilledColorButton *sendCodeBtn;  //发送验证码
    NSTimer *startTime;              //倒计时
    int currentTime;                //当前时间
    int code;
    NSMutableDictionary *infoDict;
    UIScrollView *backScrollView;
    
//    UIButton *questionButton;       //登录遇到问题
}

@property (nonatomic, assign) BOOL isRegist;

@end



@implementation FindPasswordViewController
- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _isRegist = [query[@"isregist"] boolValue];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_isRegist) {
        self.title = @"注册";
    }else{
        self.title = @"找回密码";

    }
    self.navigationController.navigationBar.hidden = NO;
    infoDict = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    backScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    backScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backScrollView];
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(10, 45, SCREENWIDTH-20, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 5;
    topView.layer.borderWidth = 0.5;
    topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [backScrollView addSubview:topView];
    
    
    codeField = [JWTextField  fieldWithFrame:CGRectMake(0, 50, topView.width-100, 50) font:14 place:@"请输入验证码" delete:self textColor:[UIColor blackColor]];
    codeField.backgroundColor = [UIColor clearColor];
    UIView *leftView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 50)];
    leftView2.backgroundColor = [UIColor clearColor];
    codeField.leftView = leftView2;
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    codeField.leftViewMode = UITextFieldViewModeAlways;
    [topView addSubview:codeField];
    
    
    
    sendCodeBtn = [[FilledColorButton alloc]initWithFrame:CGRectMake(codeField.right, 55, 95, 40) color:SEGMENTSELECT borderColor:TAGSCOLORFORE textClolr:[UIColor whiteColor] title:@"获取验证码" fontSize:14 isBold:NO];
    sendCodeBtn.layer.cornerRadius = 5;
    sendCodeBtn.layer.borderWidth = 0;
    [sendCodeBtn addTarget:self action:@selector(getCodeFromServe:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:sendCodeBtn];
    
    
    
    
    UILabel *leftLabel = [UILabel labelWithFrame:CGRectMake(15, 0, 35, 50) fontSize:14 fontColor:GRAYTEXTCOLOR text:@"+86"];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.backgroundColor = [UIColor clearColor];
    [topView addSubview:leftLabel];
    
    phonenumField = [JWTextField fieldWithFrame:CGRectMake(50, 0, topView.width-50, 50) font:14 place:@"输入手机号" delete:self textColor:[UIColor blackColor]];
    phonenumField.backgroundColor = [UIColor clearColor];
    phonenumField.keyboardType= UIKeyboardTypeNumberPad;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 50)];
    leftView.backgroundColor = [UIColor clearColor];
    phonenumField.leftViewMode = UITextFieldViewModeAlways;
    phonenumField.leftView = leftView;
    [topView addSubview:phonenumField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, topView.width, 0.5)];
    lineView.backgroundColor =  [UIColor lightGrayColor];
    [topView addSubview:lineView];
    
    
//    if (_isRegist) {
//        questionButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-130, topView.bottom+10, 120, 40)];
//        questionButton.backgroundColor = [UIColor clearColor];
//        [questionButton setTitle:@"收不到验证码？" forState:UIControlStateNormal];
//        questionButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [questionButton setTitleColor:SquareLinkColor forState:UIControlStateNormal];
//        [questionButton addTarget:self action:@selector(questionbuttonFunction:) forControlEvents:UIControlEventTouchUpInside];
//        [backScrollView addSubview:questionButton];
//    }
    
    password = [JWTextField  fieldWithFrame:CGRectMake(10,topView.bottom+ 30, SCREENWIDTH- 20, 40) font:14 place:_isRegist?@"设置密码 (6-20个字符)":@"设置新密码（6-20个字符）" delete:self textColor:[UIColor blackColor]];
    UIView *leftView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 50)];
    leftView3.backgroundColor = [UIColor whiteColor];
    password.leftView = leftView3;
    password.layer.cornerRadius = 5;
    password.layer.borderWidth = 0.5;
    password.layer.borderColor = [UIColor lightGrayColor].CGColor;
    password.keyboardType = UIKeyboardTypeASCIICapable;
    password.backgroundColor = [UIColor whiteColor];
    password.leftViewMode = UITextFieldViewModeAlways;
    [backScrollView addSubview:password];
    
  
    
    
    completeBtn = [[FilledColorButton alloc]initWithFrame:CGRectMake(40, password.bottom+35, SCREENWIDTH- 80, 40) color:SEGMENTSELECT borderColor:TAGSCOLORFORE textClolr:[UIColor whiteColor] title:@"提交" fontSize:14 isBold:NO];
    if (_isRegist) {
        [completeBtn setTitle:@"下一步"];
    }
    completeBtn.layer.borderWidth = 0;
    completeBtn.layer.cornerRadius = 20;
    [completeBtn addTarget:self action:@selector(clickFindPassWordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:completeBtn];
    
    
    UILabel *weimiLabel = [UILabel labelWithFrame:CGRectMake(10, SCREENHEIGHT- 60 -64, SCREENWIDTH-20, 20) fontSize:12 fontColor:CUSTOMTEXTCOLOR text:@"由微蜜科技提供" ];
    weimiLabel.textAlignment = NSTextAlignmentCenter;
    [backScrollView addSubview:weimiLabel];
    
    UILabel *versonLabel = [UILabel labelWithFrame:CGRectMake(10, SCREENHEIGHT-45-64, SCREENWIDTH-20, 20) fontSize:12 fontColor:CUSTOMTEXTCOLOR text:@"V1.0.0"];
    versonLabel.textAlignment = NSTextAlignmentCenter;
    [backScrollView addSubview:versonLabel];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phonenumField && textField.text.length >= 11 && ![string isEqualToString:@""]) {
        return NO;
    }
    if (textField == codeField && textField.text.length >= 6 && ![string isEqualToString:@""]) {
        return NO;
    }
    if (textField == password && textField.text.length >= 16 && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

#pragma mark -------------------------------------------点击找回密码
- (void)clickFindPassWordBtnAction:(UIButton *)sender
{
    
    if (phonenumField.text.length <1 || password.text.length <1 || codeField.text.length<1) {
        return;
    }
    
    
    completeBtn.enabled = NO;
    
    if (_isRegist) {
        [infoDict setObject:phonenumField.text forKey:@"phonenum"];
        [infoDict setObject:password.text forKey:@"password"];

        
        
        [[JWNetClient defaultJWNetClient] postNetClient:@"User/registerCaptcha" requestParm:@{@"phonenum":phonenumField.text,@"captcha":codeField.text} result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (!self) return ;
            completeBtn.enabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else {
                RegistCompleteViewController *registVC = [[RegistCompleteViewController alloc]initWithQuery:infoDict];
                [self.navigationController pushViewController:registVC animated:YES];
            }
        }];
        return;
    }
    [LoadingView show:@"请稍候..."];

    [[JWNetClient defaultJWNetClient] postNetClient:@"User/password" requestParm:@{@"phonenum":phonenumField.text,@"captcha":codeField.text,@"password":password.text} result:^(id responObject, NSString *errmsg) {
       
        [LoadingView dismiss];
        if (NULL==self)return ;
        completeBtn.enabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"密码找回成功，请用新密码重新登录" duration:3];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

//#pragma mark-- 遇到问题
//
//- (void)questionbuttonFunction:(UIButton *)sender
//{
//    
//    if( [MFMessageComposeViewController canSendText] ){
//        code = arc4random()%900000+100000;
//        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
//        controller.recipients = [NSArray arrayWithObject:@"10010"];
//        controller.body = [NSString stringWithFormat:@"[%d],美掌柜短信校验！",code];
//        controller.messageComposeDelegate = self;
//        [self presentViewController:controller animated:YES completion:NULL];
//        
//        return;
//    }else{
//        [self showAlertView:@"设备没有短信功能"];
//    }
//    
//}


#pragma mark --------------------------- 倒计时

- (void)startTheCountdown
{
    sendCodeBtn.enabled = NO;
    sendCodeBtn.backGroundColor = GrayColorLine;
    sendCodeBtn.backgroundColor = GrayColorLine;
    [sendCodeBtn setTitle:@"60s"];
    if (startTime) {
        [startTime invalidate];
    }
    currentTime = 60;
    startTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refeshCodeStatus:) userInfo:sendCodeBtn repeats:YES];
}
- (void)refeshCodeStatus:(NSTimer *)sender
{
    
    currentTime--;
    if (currentTime <= 0) {
        [startTime invalidate];
        sendCodeBtn.enabled = YES;
        [sendCodeBtn setTitle:@"获取验证码"];
        sendCodeBtn.backGroundColor = SCHEMOCOLOR;
        sendCodeBtn.backgroundColor = SCHEMOCOLOR;
        return;
    }
    NSString *title = [NSString stringWithFormat:@"%ds",currentTime];
    [sendCodeBtn setTitle:title];
}

#pragma mark --------------------------- 获取验证码

- (void)getCodeFromServe:(FilledColorButton *)sender
{
    [self.view endEditing:YES];
    
    if (![[JudgeMethods defaultJudgeMethods]contentTextIsPhoneNumber:phonenumField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    sender.enabled = NO;
    
    
    NSString *apiString = @"User/password";
    if (_isRegist) {
        apiString = @"User/registerCaptcha";
    }
    
    [[JWNetClient defaultJWNetClient]getNetClient:apiString requestParm:@{@"phonenum":phonenumField.text} result:^(id responObject, NSString *errmsg) {
        if (!self) return ;
        sendCodeBtn.enabled = YES;
        if (errmsg) {
            if ([errmsg rangeOfString:@"手机号已被占用"].location != NSNotFound) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此号码已注册，请登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                alertView.tag = 6001;
                [alertView show];
            }else{
                [SVProgressHUD showErrorWithStatus:errmsg];
            }
        }else{
            [self startTheCountdown];
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功，注意查收"];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 6001 && buttonIndex == 1) {
     
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LogInViewController class]]) {
                LogInViewController *logInVC = (LogInViewController *)controller;
                [logInVC showLogInViews];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (startTime) {
        [startTime invalidate];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if (result == MessageComposeResultSent){
        [SVProgressHUD showSuccessWithStatus:@"验证成功"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"验证失败"];
    }
    [controller dismissViewControllerAnimated:YES completion:NULL];
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
