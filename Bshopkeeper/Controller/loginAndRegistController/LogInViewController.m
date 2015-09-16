//
//  LogInViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "LogInViewController.h"
#import "Configurations.h"
#import "FindPasswordViewController.h"
#import "JWSocketManage.h"

@interface LogInViewController ()<UITextFieldDelegate>
{
    UIImageView *backImgView1;
    UIImageView *backImgView2;
    UIImageView *backImgView3;
    
    UIButton *logInButton;
    UIButton *registButton;
    UIButton *closeButton;
    UIButton *findPasswordButton;
    
    UITextField *phoneField;
    UITextField *passwordField;
    
    UILabel *headLable;
    BOOL startIsLogIn;
    
}
@end

@implementation LogInViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        self.isBackButton = NO;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    backImgView1 = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImgView1.contentMode = UIViewContentModeScaleAspectFill;
    backImgView1.image = [UIImage imageNamed:@"icon_login_backimg1.png"];
    backImgView1.clipsToBounds = YES;
    [self.view addSubview:backImgView1];
    
    backImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(60, 30, SCREENWIDTH-120, 445/(454/(SCREENWIDTH-120)))];
    backImgView2.contentMode = UIViewContentModeScaleAspectFill;
    backImgView2.image = [UIImage imageNamed:@"icon_login_backimg2.png"];
    backImgView2.clipsToBounds = YES;
    [self.view addSubview:backImgView2];

    backImgView3 = [[UIImageView alloc]initWithFrame:CGRectMake(90, backImgView2.bottom+10, SCREENWIDTH-180, 133/(338/(SCREENWIDTH-180)))];
    backImgView3.contentMode = UIViewContentModeScaleAspectFill;
    backImgView3.image = [UIImage imageNamed:@"icon_login_backimg3.png"];
    backImgView3.clipsToBounds = YES;
    [self.view addSubview:backImgView3];
    
    
    closeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH+ 10, 20, 40, 40)];
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton setImage:[UIImage imageNamed:@"icon_close_white.png"] forState:UIControlStateNormal];
    closeButton.imageEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 12);
    [closeButton addTarget:self action:@selector(backToLastViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    
    headLable = [UILabel labelWithFrame:CGRectMake(SCREENWIDTH+40, 20, SCREENWIDTH-80, 40) fontSize:18 fontColor:[UIColor whiteColor] text:@"登陆"];
    headLable.textAlignment = NSTextAlignmentCenter;
    headLable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headLable];
    
    
    //账号的输入框
    phoneField = [[UITextField alloc]initWithFrame:CGRectMake(-SCREENWIDTH+ 30, 84, SCREENWIDTH-60, 40)];
    [phoneField addTarget:self action:@selector(phoneChange) forControlEvents:UIControlEventEditingChanged];
    
    phoneField.returnKeyType = UIReturnKeyNext;
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneField.textColor = [UIColor whiteColor];
    phoneField.delegate = self;
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc]initWithString:@"输入手机号" attributes:@{NSForegroundColorAttributeName:RGBCOLOR_HEX(0x646464),NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    phoneField.attributedPlaceholder = placeholderString;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    phoneField.font = [UIFont systemFontOfSize:16];
    UIView *bottomLine1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, phoneField.width, 1)];
    bottomLine1.backgroundColor = TABBOTTOMTEXTCOLOR;
    [phoneField addSubview:bottomLine1];
    phoneField.backgroundColor = [UIColor clearColor];
    [self.view addSubview:phoneField];
    
    //密码的输入框
    passwordField = [[UITextField alloc]initWithFrame:CGRectMake(SCREENWIDTH+ 30, phoneField.bottom+10, SCREENWIDTH-60, 40)];
    passwordField.returnKeyType = UIReturnKeyDone;
    passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordField.textColor = [UIColor whiteColor];
    passwordField.delegate = self;
    passwordField.keyboardType = UIKeyboardTypeASCIICapable;
    NSMutableAttributedString *placeholderString2 = [[NSMutableAttributedString alloc]initWithString:@"输入密码" attributes:@{NSForegroundColorAttributeName:RGBCOLOR_HEX(0x646464),NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    passwordField.attributedPlaceholder = placeholderString2;
    passwordField.secureTextEntry = YES;
    passwordField.font = [UIFont systemFontOfSize:16];
    UIView *bottomLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, phoneField.width, 1)];
    bottomLine2.backgroundColor = TABBOTTOMTEXTCOLOR;
    [passwordField addSubview:bottomLine2];
    passwordField.backgroundColor = [UIColor clearColor];
    [self.view  addSubview:passwordField];
    
    findPasswordButton = [[UIButton alloc]initWithFrame:CGRectMake(-SCREENWIDTH+(SCREENWIDTH-110), passwordField.bottom+10, 80, 40)];
    findPasswordButton.backgroundColor = [UIColor clearColor];
    [findPasswordButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    findPasswordButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [findPasswordButton setTitleColor:SquareLinkColor forState:UIControlStateNormal];
    [findPasswordButton addTarget:self action:@selector(findPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPasswordButton];
    
    
    
    logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logInButton.frame = CGRectMake(50, SCREENHEIGHT-150, SCREENWIDTH-100, 44);
    [logInButton setTitle:@"登录" forState:UIControlStateNormal];
    [logInButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logInButton setBackgroundColor:TABBOTTOMTEXTCOLOR];
    logInButton.layer.cornerRadius= 22;
    logInButton.alpha = 0.6;
    logInButton.clipsToBounds = YES;
    [logInButton addTarget:self action:@selector(logInAction:) forControlEvents:UIControlEventTouchUpInside];
    logInButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:logInButton];
    
    registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registButton.frame = CGRectMake(50, logInButton.bottom+20, SCREENWIDTH-100, 44);
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton setTitleColor:TABBOTTOMTEXTCOLOR forState:UIControlStateNormal];
    registButton.layer.cornerRadius= 22;
    registButton.layer.borderWidth = 1;
    registButton.layer.borderColor = TABBOTTOMTEXTCOLOR.CGColor;
    registButton.clipsToBounds = YES;
    [registButton addTarget:self action:@selector(clickRegistBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    registButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:registButton];

    
    UIImageView *img = (UIImageView *)[[AppDelegate appDelegate].window viewWithTag:100];
    if (img) {
        [img removeFromSuperview];
        img = nil;
    }
   
}

- (void)phoneChange
{
    if (phoneField.text.length == 0 ) {
        passwordField.text = @"";
    }
}


- (void)clickRegistBtnAction:(FilledColorButton *)sender
{
    
    FindPasswordViewController *registVC = [[FindPasswordViewController alloc]initWithQuery:@{@"isregist":@(YES)}];
    [self.navigationController pushViewController:registVC  animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-  (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == phoneField && textField.text.length >= 11 && ![string isEqualToString:@""]) {
        return NO;
    }
    if (textField == passwordField && textField.text.length >= 16 && ![string isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)addLogInInfo
{
    NSString *logInfo = [[NSUserDefaults standardUserDefaults]objectForKey:CURRENTLOGININFO];
    if (logInfo) {
        NSDictionary *dict = [logInfo JSONValue];
        phoneField.text = dict[@"phonenum"];
        passwordField.text = dict[@"password"];
    }
}


/*
 *手机号登录
 */

- (void)logInAction:(UIButton *)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (!startIsLogIn) {
        [self stareAnimation:YES];
        return;
    }
    
    
    
    if (![NSObject nulldata:phoneField.text ]) {
        [[UIUtils defaultUIUtils]shakeAnimation:phoneField];
        return;
    }
    if (![NSObject nulldata:passwordField.text]) {
        [[UIUtils defaultUIUtils]shakeAnimation:passwordField];
        return;
    }
    logInButton.enabled = NO;
    self.view.userInteractionEnabled = NO;
    [LoadingView show:@"登录中..."];
    
    
    __weak __typeof (self) weakSelf = self;
    
    [[JWNetClient defaultJWNetClient]postNetClient:@"User/login" requestParm:@{@"phonenum":phoneField.text,@"password":passwordField.text} result:^(id responObject, NSString *errmsg) {

        HBLog(@"---------%@",responObject);
        
        [LoadingView dismiss];
        if (weakSelf == NULL) return ;
        
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
            [weakSelf requestFinishedAction:nil];
        }else{
            [weakSelf requestFinishedAction:responObject];
            
        }
        
    }];
}

- (void)requestFinishedAction:(id)result
{

    self.view.userInteractionEnabled = YES;
    logInButton.enabled = YES;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CURRENTLOGININFO];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (!result ) return;

    if ([[result objectForKey:@"code"]integerValue] == 0 ) {
        
        User *currentUser = [User defaultUser];
        [currentUser logInSucessSaveInfo:result];
        /*
         *当前登陆信息 @｛ phonenum :   password: logInType:  thirdToken:｝
         * logInType @"10" 手机号登录
         */
        NSMutableDictionary *logInInfo = [NSMutableDictionary dictionary];
        [logInInfo setValue:passwordField.text forKey:@"password"];
        [logInInfo setValue:phoneField.text forKey:@"phonenum"];
        [logInInfo setValue:@"10" forKey:@"logInType"];
        [[NSUserDefaults standardUserDefaults] setObject:[logInInfo JSONString] forKey:CURRENTLOGININFO];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
        //创建表
        [operationDB createdAllDataBase];
        
        //更新数据
        [currentUser getNewDataFromServer];
        
               
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:[result objectForKey:@"msg"]];
    }
    
    
}

- (void)stareAnimation:(BOOL)show
{
    if (show) {
        logInButton.enabled = NO;
        
        UIImage *image2 = [UIImage imageNamed:@"icon_login_backimg2.png"];
        CIContext *context2 = [CIContext contextWithOptions:nil];
        CIImage *needImg2 = [CIImage imageWithCGImage:image2.CGImage];
        CIFilter *filter2 = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter2 setValue:needImg2 forKey:kCIInputImageKey];
        [filter2 setValue:@20.0f forKey: @"inputRadius"];
        CIImage *result2 = [filter2 valueForKey:kCIOutputImageKey];
        CGImageRef outImage2 = [context2 createCGImage: result2 fromRect:[result2 extent]];
        backImgView2.image = [UIImage imageWithCGImage:outImage2];
        CFRelease(outImage2);
        
        UIImage *image3 = [UIImage imageNamed:@"icon_login_backimg3.png"];
        CIContext *context3 = [CIContext contextWithOptions:nil];
        CIImage *needImg3 = [CIImage imageWithCGImage:image3.CGImage];
        CIFilter *filter3 = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter3 setValue:needImg3 forKey:kCIInputImageKey];
        [filter3 setValue:@20.0f forKey: @"inputRadius"];
        CIImage *result3 = [filter3 valueForKey:kCIOutputImageKey];
        CGImageRef outImage3 = [context3 createCGImage: result3 fromRect:[result3 extent]];
        backImgView3.image = [UIImage imageWithCGImage:outImage3];
        registButton.hidden = YES;
        CFRelease(outImage3);
        
        [UIView animateWithDuration:0.3 animations:^{
            phoneField.frame =  CGRectMake( 30, 84, SCREENWIDTH-60, 40);
            passwordField.frame = CGRectMake( 30, phoneField.bottom+10, SCREENWIDTH-60, 40);
            findPasswordButton.frame = CGRectMake(SCREENWIDTH-110, passwordField.bottom+10, 80, 40);
            closeButton.frame = CGRectMake(10, 20, 40, 40);
            headLable.frame = CGRectMake(40, 20, SCREENWIDTH-80, 40);
            logInButton.frame = CGRectMake(50, findPasswordButton.bottom+10, SCREENWIDTH-100, 44);
        } completion:^(BOOL finished) {
            
            if (finished) {
                startIsLogIn = YES;
                logInButton.enabled = YES;
                phoneField.frame =  CGRectMake( 30, 84, SCREENWIDTH-60, 40);
                passwordField.frame = CGRectMake( 30, phoneField.bottom+10, SCREENWIDTH-60, 40);
                findPasswordButton.frame = CGRectMake(SCREENWIDTH-110, passwordField.bottom+10, 80, 40);
                closeButton.frame = CGRectMake(10, 20, 40, 40);
                headLable.frame = CGRectMake(40, 20, SCREENWIDTH-80, 40);
                logInButton.frame = CGRectMake(50, findPasswordButton.bottom+10, SCREENWIDTH-100, 44);
                [self addLogInInfo];
            }
        }];
        return;
    }else{
        logInButton.enabled = NO;
        registButton.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            phoneField.frame =  CGRectMake( -SCREENWIDTH+ 30, 84, SCREENWIDTH-60, 40);
            passwordField.frame = CGRectMake( 30+SCREENWIDTH, phoneField.bottom+10, SCREENWIDTH-60, 40);
            findPasswordButton.frame = CGRectMake(-SCREENWIDTH+SCREENWIDTH-110, passwordField.bottom+10, 80, 40);
            closeButton.frame = CGRectMake(10+SCREENWIDTH, 20, 40, 40);
            headLable.frame = CGRectMake(40+SCREENWIDTH, 20, SCREENWIDTH-80, 40);
            logInButton.frame = CGRectMake(50, SCREENHEIGHT-150, SCREENWIDTH-100, 44);
        } completion:^(BOOL finished) {
            
            if (finished) {
                startIsLogIn = NO;
                logInButton.enabled = YES;
                phoneField.frame =  CGRectMake( -SCREENWIDTH+ 30, 84, SCREENWIDTH-60, 40);
                passwordField.frame = CGRectMake( 30+SCREENWIDTH, phoneField.bottom+10, SCREENWIDTH-60, 40);
                findPasswordButton.frame = CGRectMake(-SCREENWIDTH+SCREENWIDTH-110, passwordField.bottom+10, 80, 40);
                closeButton.frame = CGRectMake(10+SCREENWIDTH, 20, 40, 40);
                headLable.frame = CGRectMake(40+SCREENWIDTH, 20, SCREENWIDTH-80, 40);
                logInButton.frame = CGRectMake(50, SCREENHEIGHT-150, SCREENWIDTH-100, 44);
            }
        }];
        backImgView2.image = [UIImage imageNamed:@"icon_login_backimg2.png"];
        backImgView3.image = [UIImage imageNamed:@"icon_login_backimg3.png"];

    }
}


#pragma mark ------------------------------------- 找回密码
- (void)findPasswordAction:(UIButton *)sender
{
    FindPasswordViewController *passwordFind = [[FindPasswordViewController alloc]init];
    [self.navigationController pushViewController:passwordFind animated:YES];
}

#pragma mark --  撤销登陆
- (void)backToLastViewController:(id)sender
{
    [self.view endEditing:YES];
    phoneField.text = nil;
    passwordField.text = nil;
    [phoneField resignFirstResponder];
    [passwordField resignFirstResponder];
    [self stareAnimation:NO];
    
}

#pragma mark-- 登录状态
 - (void)showLogInViews
{
    UIImage *image2 = [UIImage imageNamed:@"icon_login_backimg2.png"];
    CIContext *context2 = [CIContext contextWithOptions:nil];
    CIImage *needImg2 = [CIImage imageWithCGImage:image2.CGImage];
    CIFilter *filter2 = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter2 setValue:needImg2 forKey:kCIInputImageKey];
    [filter2 setValue:@20.0f forKey: @"inputRadius"];
    CIImage *result2 = [filter2 valueForKey:kCIOutputImageKey];
    CGImageRef outImage2 = [context2 createCGImage: result2 fromRect:[result2 extent]];
    backImgView2.image = [UIImage imageWithCGImage:outImage2];
    CFRelease(outImage2);
    
    UIImage *image3 = [UIImage imageNamed:@"icon_login_backimg3.png"];
    CIContext *context3 = [CIContext contextWithOptions:nil];
    CIImage *needImg3 = [CIImage imageWithCGImage:image3.CGImage];
    CIFilter *filter3 = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter3 setValue:needImg3 forKey:kCIInputImageKey];
    [filter3 setValue:@20.0f forKey: @"inputRadius"];
    CIImage *result3 = [filter3 valueForKey:kCIOutputImageKey];
    CGImageRef outImage3 = [context3 createCGImage: result3 fromRect:[result3 extent]];
    backImgView3.image = [UIImage imageWithCGImage:outImage3];
    registButton.hidden = YES;
    CFRelease(outImage2);
    
    startIsLogIn = YES;
    logInButton.enabled = YES;
    phoneField.frame =  CGRectMake( 30, 84, SCREENWIDTH-60, 40);
    passwordField.frame = CGRectMake( 30, phoneField.bottom+10, SCREENWIDTH-60, 40);
    findPasswordButton.frame = CGRectMake(SCREENWIDTH-110, passwordField.bottom+10, 80, 40);
    closeButton.frame = CGRectMake(10, 20, 40, 40);
    headLable.frame = CGRectMake(40, 20, SCREENWIDTH-80, 40);
    logInButton.frame = CGRectMake(50, findPasswordButton.bottom+10, SCREENWIDTH-100, 44);
    [self addLogInInfo];

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
