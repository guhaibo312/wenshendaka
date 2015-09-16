//
//  RegistCompleteViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "RegistCompleteViewController.h"
#import "JWSocketManage.h"
#import "NSString+Extension.h"

@interface RegistCompleteViewController ()<UITextFieldDelegate>
{
    UITextField *nameField;
    UIButton *completeButton;
    
    UIButton *hobbyButton;
    UIButton *tattooButton;
    
}
@property (nonatomic, strong) NSMutableDictionary *parms;
@end

@implementation RegistCompleteViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _parms = [NSMutableDictionary dictionaryWithDictionary:query];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.title = @"完善资料";
    [self layoutSublViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self && [nameField canBecomeFirstResponder]) {
        [nameField becomeFirstResponder];
    }
}
- (void)layoutSublViews
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(10, 45, SCREENWIDTH-20, 48)];
    topView.backgroundColor = VIEWBACKGROUNDCOLOR;
    topView.layer.cornerRadius = 5;
    topView.layer.borderWidth = 0.5;
    topView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:topView];
    
    

    nameField = [JWTextField fieldWithFrame:CGRectMake(0, 1, topView.width, 46) font:14 place:@"填写昵称" delete:self textColor:[UIColor blackColor]];
    nameField.backgroundColor = [UIColor clearColor];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, 20, 46)];
    leftView.backgroundColor = [UIColor clearColor];
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.leftView = leftView;
    [topView addSubview:nameField];
    
    
    UILabel *typeLable = [UILabel labelWithFrame:CGRectMake(10, topView.bottom+30, SCREENWIDTH-20, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@"选择身份:"];
    [self.view addSubview:typeLable];
    
    tattooButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-120, typeLable.bottom+20, 90, 90)];
    [tattooButton setBackgroundColor:[UIColor clearColor]];
    [tattooButton setImage:[UIImage imageNamed:@"icon_regist_type_tattooed.png"] forState:UIControlStateSelected];
    [tattooButton setImage:[UIImage imageNamed:@"icon_regist_type_untattoo.png"] forState:UIControlStateNormal];
    [tattooButton addTarget:self action:@selector(selectedTypeFrom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tattooButton];
    
    hobbyButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+30, typeLable.bottom+20, 90, 90)];
    [hobbyButton setBackgroundColor:[UIColor clearColor]];
    [hobbyButton setImage:[UIImage imageNamed:@"icon_regist_type_liked.png"] forState:UIControlStateSelected];
    [hobbyButton setImage:[UIImage imageNamed:@"icon_regist_type_unlike.png"] forState:UIControlStateNormal];
    [hobbyButton addTarget:self action:@selector(selectedTypeFrom:) forControlEvents:UIControlEventTouchUpInside];
    hobbyButton.selected = NO;
    [self.view addSubview:hobbyButton];

    

    
    completeButton = [[UIButton alloc]initWithFrame:CGRectMake(20, hobbyButton.bottom+30, SCREENWIDTH-40, 48)];
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    completeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    completeButton.layer.cornerRadius = 24;
    [completeButton setBackgroundImage:[UIUtils imageFromColor:SEGMENTSELECT] forState:UIControlStateNormal];
    [completeButton setBackgroundImage:[UIUtils imageFromColor:SEGMENTSELECT] forState:UIControlStateSelected];
    completeButton.clipsToBounds = YES;
    [completeButton addTarget:self action:@selector(completeButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeButton];

}

#pragma mark -- 完成

- (void)completeButtonFunction:(UIButton *)sender
{
    
    
    
    if (![NSObject nulldata:nameField.text]) {
     
        [SVProgressHUD showErrorWithStatus:@"请填写昵称"];
        return;
    }
    if ([NSString isIncludeSpecialCharact:nameField.text]) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能含有特殊字符"];
        return;
    }
    
    if (!tattooButton.selected && !hobbyButton.selected) {
        [SVProgressHUD showErrorWithStatus:@"选择你的身份"];
        return;
    }
    [_parms setObject:nameField.text forKey:@"nickname"];
    [self.parms setObject:@"1988" forKey:@"birthYear"];
    [self.parms setObject:@"08" forKey:@"birthMonth"];
    [self.parms setObject:@"08" forKey:@"birthDay"];
    if (tattooButton.selected) {
        [_parms setObject:@(30) forKey:@"sector"];

    }else{
        [_parms setObject:@(0) forKey:@"sector"];

    }
    [_parms setObject:@(-1) forKey:@"gender"];
    [_parms setObject:@(0) forKey:@"storeType"];
    
    [LoadingView show:@"提交中..."];
    self.view.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    __weak __typeof (self)weakSelf = self;
    [[JWNetClient defaultJWNetClient]putNetClient:@"User/register" requestParm:_parms result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (weakSelf == nil) return ;
        weakSelf.view.userInteractionEnabled = YES;
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            NSMutableDictionary *logInInfo = [NSMutableDictionary dictionary];
            [logInInfo setValue:_parms[@"password"] forKey:@"password"];
            [logInInfo setValue:_parms[@"phonenum"] forKey:@"phonenum"];
            [logInInfo setValue:@"10" forKey:@"logInType"];
            [[NSUserDefaults standardUserDefaults] setObject:[logInInfo JSONString] forKey:CURRENTLOGININFO];
            [[NSUserDefaults standardUserDefaults]synchronize];

            User *currentUser = [User defaultUser];
            [currentUser logInSucessSaveInfo:responObject];
           
            TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
            [operationDB createdAllDataBase];

            [[AppDelegate appDelegate]pushToLogInControllor:NO];
            
            //启动socket
//            [[JWSocketManage shareManage]startConnect];

        }
        
    }];
    
    
}

#pragma mark -- textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result =  [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([NSObject nulldata:result]) {
        completeButton.enabled  = YES;
        completeButton.selected = YES;
        completeButton.layer.borderWidth = 0;
    }else{
        completeButton.enabled  = NO;
        completeButton.selected = NO;
        completeButton.layer.borderWidth = 2;
        
    }
    if (textField == nameField && textField.text.length >= 20 && ![string isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (void)selectedTypeFrom:(UIButton *)sender
{
    if (sender == tattooButton) {
        tattooButton.selected=!tattooButton.selected;
        hobbyButton.selected = NO;
    }else{
        hobbyButton.selected=!hobbyButton.selected;
        tattooButton.selected = NO;
    }
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
