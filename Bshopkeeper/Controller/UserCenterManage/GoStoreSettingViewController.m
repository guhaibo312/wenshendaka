//
//  GoStoreSettingViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "GoStoreSettingViewController.h"
#import "InstitutionSelectedViewController.h"
#import "JWEditView.h"
#import "UserHomeBtn.h"
#import "TJWWorkTimePicker.h"

@interface GoStoreSettingViewController ()<UITextFieldDelegate,UITextViewDelegate,InstitutionDelegate,WorkTimeSelectdDelegate,UIAlertViewDelegate>
{

    JWEditView *storeNameItem;              //机构名称
    JWEditView *locationItem;               //机构地址
    JWEditView *workTimeItem;               //营业时间
    
    
    TJWWorkTimePicker *timePicker;          //时间选择
    UIView *bottomView;                     //开启后下面的层
    UIScrollView *backScrollView;           //滑动层
    NSMutableDictionary *parm;              //参数
}
@end

@implementation GoStoreSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"从业机构设置";
    
    [self setRightNavigationBarTitle:@"保存" color:[UIColor whiteColor] fontSize:16 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.backgroundColor = VIEWBACKGROUNDCOLOR;
    [self.view addSubview:backScrollView];
    
    //bottomview
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 88*2)];
    [backScrollView addSubview:bottomView];
    
    //服务名称
    storeNameItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) withTitleLabel:@"机构名称" type:JWEditTextField detailImgName:nil];
    storeNameItem.editTextField.delegate = self;
    storeNameItem.editTextField.width-=65;
    storeNameItem.editTextField.placeholder = @"输入名称";
    [bottomView addSubview:storeNameItem];
    
    
    
    UserHomeBtn *startLocationBtn = [UserHomeBtn buttonWithFrame:CGRectMake(SCREENWIDTH- 60, 2, 60, 40) text:@"定位" imageName:@"icon_currentLocation.png"];
    startLocationBtn.desIamgeView.frame = CGRectMake(5, 12, 11, 16);
    startLocationBtn.nameLabel.frame = CGRectMake(20, 0, 40, 40);
    startLocationBtn.nameLabel.textColor = GRAYTEXTCOLOR;
    [startLocationBtn addTarget:self action:@selector(ChooseSearchCompanyAction:) forControlEvents:UIControlEventTouchUpInside];
    [storeNameItem addSubview:startLocationBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-60.5, 0, 0.5, 43)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [storeNameItem addSubview:lineView];
    
    
    
    //详细地址
    locationItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, storeNameItem.bottom, SCREENWIDTH, 88) withTitleLabel:@"详细地址" type:JWEditTextView detailImgName:nil];
    locationItem.editTextView.delegate = self;
    locationItem.titleLabel.height = 50;
    locationItem.textViewPlaceHolder.text = @"请输入详细地址以便顾客寻找";
    [bottomView addSubview:locationItem];
    
    //营业时间
    workTimeItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, locationItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"营业时间" type:JWEditTextField detailImgName:nil];
    [workTimeItem setClickAction:@selector(chooseWorkTimeAction:) responder:self];
    workTimeItem.editTextField.userInteractionEnabled = NO;
    workTimeItem.editTextField.placeholder = @"无";
    [bottomView addSubview:workTimeItem];
    
    parm  = [NSMutableDictionary dictionary];
    [self reloadData];

}

- (void)backAction
{
    
    
    if ([User defaultUser].item.company) {
        BOOL isChanged = NO;

        NSString *companyName =[[User defaultUser].item.company objectForKey:@"name"];
        NSString *companyAdd =[[User defaultUser].item.company objectForKey:@"address"];
        
        if ([NSObject nulldata:companyName]) {
            if (![companyName isEqual:storeNameItem.editTextField.text]) {
                isChanged = YES;
            }
        }
        if ([NSObject nulldata:companyAdd]) {
            if (![companyAdd isEqual:locationItem.editTextView.text]) {
                isChanged = YES;
            }
        }
        if (isChanged) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存当前修改的内容？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
            alert.tag = 5;
            [alert show];
            return;
        }
        
    }
    if ([NSObject nulldata:[User defaultUser].storeItem.openTime ]) {
        if (![[User defaultUser].storeItem.openTime isEqual:workTimeItem.editTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否保存当前修改的内容？" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
            alert.tag = 5;
            [alert show];
            return;
        }
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

#pragma mark ---------------------------------- 选择营业时间
- (void)chooseWorkTimeAction:(id)sender
{
    [self.view endEditing:YES];
    
    if (timePicker) {
        [timePicker removeFromSuperview];
    }
    timePicker = [[TJWWorkTimePicker alloc]initWithCurrentTime:workTimeItem.editTextField.text delegate:self];
    [timePicker show];
}

#pragma mark   --------------------------------- 点击搜索机构
- (void)ChooseSearchCompanyAction:(UserHomeBtn *)sender
{
    
    [storeNameItem.editTextField resignFirstResponder];
    [locationItem.editTextView resignFirstResponder];
    
    InstitutionSelectedViewController *selectedVC  =[[InstitutionSelectedViewController alloc]init];
    selectedVC.delegate = self;
    [self.navigationController pushViewController:selectedVC animated:YES];
}

#pragma mark ---------------------------------- 结构回调
- (void)selectedInstitution:(NSDictionary *)dict
{
    storeNameItem.editTextField.text = dict[@"name"];
    locationItem.editTextView.text= dict[@"address"];
    if ([NSObject nulldata:locationItem.editTextView.text ]) {
        locationItem.textViewPlaceHolder.hidden = YES;
    }
}


#pragma mark -------------------------------- 点击完成
- (void)rightNavigationBarAction:(UIButton *)sender
{
    [locationItem.editTextView resignFirstResponder];
    [storeNameItem.editTextField resignFirstResponder];
    
    [parm removeAllObjects];
    [parm setObject:@"1" forKey:@"serviceInStore"];
    
    if (locationItem.editTextView.text.length <1) {
        [SVProgressHUD showErrorWithStatus:@"请填写详细地址"];
        return;
    }
    if (storeNameItem.editTextField.text.length <1) {
        [SVProgressHUD showErrorWithStatus:@"请填写机构名称"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:storeNameItem.editTextField.text?storeNameItem.editTextField.text:@"" forKey:@"name"];
    [dict setObject:locationItem.editTextView.text?locationItem.editTextView.text:@"" forKey:@"address"];
    [parm setObject:dict forKey:@"company"];
    if (workTimeItem.editTextField.text.length) {
        [parm setObject:workTimeItem.editTextField.text forKey:@"openTime"];
    }
    [LoadingView show:@"请稍候..."];
    
    [[JWNetClient defaultJWNetClient]postNetClient:@"Store/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if(self == NULL)return ;
        if (errmsg) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            [self requestUserInfoAction];
        }
    }];
    

}

#pragma mark ------------------------------提交个人信息
- (void)requestUserInfoAction
{
    [[JWNetClient defaultJWNetClient]postNetClient:@"User/userInfo" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (self == NULL) return ;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(completeCompanyEditWithDict:)]) {
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [dictionary setObject:storeNameItem.editTextField.text?storeNameItem.editTextField.text:@"" forKey:@"name"];
                [dictionary setObject:locationItem.editTextView.text?locationItem.editTextView.text:@"" forKey:@"address"];
                [_delegate completeCompanyEditWithDict:dictionary];
            }

            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [[User defaultUser] changeUserInfo:parm storeInf:parm];
            [[NSNotificationCenter defaultCenter] postNotificationName:kEDITUSERINFOSUCESS object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark ------------------------------- 时间回调
- (void)selectedWorkTime:(NSString *)content
{
    workTimeItem.editTextField.text = content;
}

- (void)workTimePickerDissmiss
{
    if (timePicker) {
        [timePicker removeFromSuperview];
    }
    timePicker = nil;
}

- (void)reloadData
{
    locationItem.textViewPlaceHolder.hidden = NO;
    if ([User defaultUser].item.company) {
        storeNameItem.editTextField.text =[[User defaultUser].item.company objectForKey:@"name"];
        locationItem.editTextView.text =[[User defaultUser].item.company objectForKey:@"address"];
        if (locationItem.editTextView.text.length >=1) {
            locationItem.textViewPlaceHolder.hidden = YES;
        }
    }
    
    if ([User defaultUser].storeItem.openTime) {
        workTimeItem.editTextField.text = [User defaultUser].storeItem.openTime;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView== locationItem.editTextView) {
        if (textView.text.length <=1 && [text isEqualToString:@""] ) {
            locationItem.textViewPlaceHolder.hidden = NO;
        }else{
            locationItem.textViewPlaceHolder.hidden = YES;
        }
    }
    
    if (textView == locationItem.editTextView && textView.text.length >=30 && ![text isEqualToString:@""] ) {
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
