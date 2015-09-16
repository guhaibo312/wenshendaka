//
//  StoreInfoSettingsViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/26.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "StoreInfoSettingsViewController.h"
#import "GoStoreSettingViewController.h"
#import "QrCodeViewController.h"
#import "UIImageView+WebCache.h"
#import "JWEditView.h"
#import "UserHomeBtn.h"
#import "UserDescribeViewController.h"
#import "CitySelectedViewController.h"
#import "BaseNavigationViewController.h"
#import "RealNameAuthenticationViewController.h"
#import "ContactServerViewController.h"

@interface StoreInfoSettingsViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    
    NSMutableDictionary * reqestUserInfoParm;           //请求个人信息 参数
    NSMutableDictionary * reqestStoreInfoParm;          //请求店铺信息 参数
    
    
    UIScrollView *backScrollView;               //滑动
    UIImageView *headImageView;                 //头像区域
    UIImage *headImg;                           //头像图片
    
    UserHomeBtn *maleBtn;                       //男
    UserHomeBtn *femaleBtn;                     //女
    
    NSString * currentGender;

    JWEditView *userView;                       //头像title
    JWEditView *nameItem;                       //昵称
    JWEditView *genderItem;                     //性别
    JWEditView *wxItem;                         //微信
    JWEditView *phoneItem;                      //手机
    JWEditView *tradeItem;                      //行业
    
    CityObject *citySelectedObject;
    
}
@end

@implementation StoreInfoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人设置";
    [self setRightNavigationBarTitle:@"保存" color:[UIColor whiteColor] fontSize:16 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    
    reqestStoreInfoParm = [NSMutableDictionary dictionary];
    reqestUserInfoParm =[NSMutableDictionary dictionary];
    
    //加载页面
    [self loadSubViews];
}

#pragma mark -------------------- 点击保存
- (void)rightNavigationBarAction:(UIButton *)sender
{
    self.view.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (headImg) {
        [UploadManager uploadImageList: [NSArray arrayWithObject:headImg] hasLoggedIn: YES success:^(NSArray *resultList) {
            if ([self currentIsTopViewController]) {
                [self submittedToModifyTheDataForUserInfo:[resultList firstObject]];
            }
        } failure:^(NSError *error) {
            [LoadingView dismiss];
            self.view.userInteractionEnabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        }];
    }else{
        [self submittedToModifyTheDataForUserInfo:nil];
    }
    
}

#pragma mark --------------------- 提交图片后 提交 个人信息
- (void)submittedToModifyTheDataForUserInfo:(NSString *)hearUrl
{
    [LoadingView show:@"请稍候..."];

    [reqestUserInfoParm removeAllObjects];
   
    if ([NSObject nulldata:nameItem.editTextField.text]) {
        [reqestUserInfoParm setObject:nameItem.editTextField.text forKey:@"nickname"];
    }else{
        [reqestUserInfoParm setObject:@"" forKey:@"nickname"];
    }
    
    if (hearUrl) {
        [reqestUserInfoParm setObject:hearUrl forKey:@"avatar"];
    }
    
    [reqestUserInfoParm setObject:currentGender forKey:@"gender"];
   
    if ([NSObject nulldata:wxItem.editTextField.text]) {
        [reqestUserInfoParm setObject:wxItem.editTextField.text forKey:@"wxNum"];
    }else{
        [reqestUserInfoParm setObject:@"" forKey:@"wxNum"];

    }
    if (citySelectedObject) {
        [reqestUserInfoParm setObject:citySelectedObject.cityCode forKey:@"city"];
        [reqestUserInfoParm setObject:citySelectedObject.provinceCode forKey:@"province"];
        [reqestUserInfoParm setObject:citySelectedObject.areaCode forKey:@"area"];

    }

    
    [[JWNetClient defaultJWNetClient]postNetClient:@"User/userInfo" requestParm:reqestUserInfoParm result:^(id responObject, NSString *errmsg) {
        
        if (!self) {
            [LoadingView dismiss];
            return ;
        }
        if (errmsg == nil) {
            [self submittedToModifyTheDataForStoreInfo];
            
            NSDictionary *dict = [responObject objectForKey:@"data"];
            if ([dict objectForKey:@"changedData"]) {
                [[User defaultUser] changeUserInfo:dict[@"changedData"] storeInf:nil];
            }else{
                [[User defaultUser] changeUserInfo:reqestUserInfoParm storeInf:nil];
            }

        }else{
            [LoadingView dismiss];
            self.view.userInteractionEnabled = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [SVProgressHUD showErrorWithStatus:errmsg];
        }
        
    }];
    

}
#pragma mark -------------------- 提交店铺设置

- (void)submittedToModifyTheDataForStoreInfo
{
    [reqestStoreInfoParm removeAllObjects];
        if ([NSObject nulldata:nameItem.editTextField.text]) {
        [reqestStoreInfoParm setObject:nameItem.editTextField.text forKey:@"storeName"];
    }else{
        [reqestStoreInfoParm setObject:@"" forKey:@"storeName"];
    }
    
    if (citySelectedObject) {
        [reqestStoreInfoParm setObject:citySelectedObject.cityCode forKey:@"city"];
        [reqestStoreInfoParm setObject:citySelectedObject.provinceCode forKey:@"province"];
        [reqestStoreInfoParm setObject:citySelectedObject.areaCode forKey:@"area"];
    }
    
    [[JWNetClient defaultJWNetClient]postNetClient:@"Store/info" requestParm:reqestStoreInfoParm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (self == NULL) return ;
        self.view.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [[User defaultUser] changeUserInfo:nil storeInf:reqestStoreInfoParm];
            [[NSNotificationCenter defaultCenter] postNotificationName:kEDITUSERINFOSUCESS object:nil];
        }
    }];
}

#pragma mark --------------------  加载页面
- (void)loadSubViews
{
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backScrollView];
    
    
    userView = [[JWEditView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) withTitleLabel:@"头像" type:JWEditLable detailImgName:@"icon_right_img.png"];
    [userView setClickAction:@selector(clickUserViewAction:) responder:self];
    [backScrollView addSubview:userView];
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 70, 2, 40, 40)];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    headImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
    headImageView.layer.cornerRadius = 20;
    headImageView.userInteractionEnabled = NO;
    [userView addSubview:headImageView];
    
    //昵称
    nameItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, userView.bottom, SCREENWIDTH, 44) withTitleLabel:@"昵称" type:JWEditTextField detailImgName:nil];
    nameItem.editTextField.delegate = self;
    nameItem.editTextField.placeholder = @"无";
    [backScrollView addSubview:nameItem];
    
    //性别
    genderItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, nameItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"性别" type:JWEditLable detailImgName:nil];
    [backScrollView addSubview:genderItem];
    maleBtn = [UserHomeBtn buttonWithFrame:CGRectMake(SCREENWIDTH/2, 2, 60, 40) text:@"男" imageName:@"icon_radio_normal.png"];
    maleBtn.nameLabel.textColor = GRAYTEXTCOLOR;
    maleBtn.desIamgeView.frame = CGRectMake(maleBtn.width/2-30, (maleBtn.height-20)/2, 20, 20);
    maleBtn.nameLabel.frame = CGRectMake(maleBtn.width/2-10, 0, 40, 40);
    [maleBtn addTarget:self action:@selector(clickGenderItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [genderItem addSubview:maleBtn];
    
    
    femaleBtn = [UserHomeBtn buttonWithFrame:CGRectMake(SCREENWIDTH/2+80, 2, 60, 40) text:@"女" imageName:@"icon_radio_normal.png"];
    femaleBtn.nameLabel.textColor = GRAYTEXTCOLOR;
    femaleBtn.desIamgeView.frame = CGRectMake(maleBtn.width/2-30, (maleBtn.height-20)/2, 20, 20);
    femaleBtn.nameLabel.frame = CGRectMake(maleBtn.width/2-10, 0, 40, 40);
    [femaleBtn addTarget:self action:@selector(clickGenderItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [genderItem addSubview:femaleBtn];


    
    
    //简介
    JWEditView * desItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, genderItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"个人介绍" type:JWEditLable detailImgName:@"icon_right_img.png"];
    [desItem setClickAction:@selector(pushToUserDesCribeViewController:) responder:self];
    [backScrollView addSubview:desItem];
    
    

    //微信号
    wxItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, desItem.bottom+10, SCREENWIDTH, 44) withTitleLabel:@"微信号" type:JWEditTextField detailImgName:nil];
    wxItem.editTextField.delegate = self;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"未设置" attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    wxItem.editTextField.attributedPlaceholder = string ;
    [backScrollView addSubview:wxItem];
    
    //手机号
    phoneItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, wxItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"手机号" type:JWEditLable detailImgName:nil];
    phoneItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    [backScrollView addSubview:phoneItem];
  
    if ([[User defaultUser].item.sector integerValue] == 30) {
        //机构
        JWEditView * companyItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, phoneItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"从业机构" type:JWEditLable detailImgName:@"icon_right_img.png"];
        [backScrollView addSubview:companyItem];
        [companyItem setClickAction:@selector(clickCompanyItemAction:) responder:self];
        
        //位置
        JWEditView * locationItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, companyItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"所在地" type:JWEditLable detailImgName:@"icon_right_img.png"];
        [backScrollView addSubview:locationItem];
        locationItem.tag = 89;
        locationItem.detailLabel.textAlignment = NSTextAlignmentRight;
        [locationItem setClickAction:@selector(locationselected:) responder:self];
        
        
        
        //官网二维码
        JWEditView *qritem =[[JWEditView alloc]initWithFrame:CGRectMake(0, locationItem.bottom+10, SCREENWIDTH, 44) withTitleLabel:@"名片二维码" type:JWEditLable detailImgName:@"icon_right_img.png"];
        qritem.titleLabel.frame = CGRectMake(10, 0, 100, 44);
        UIImageView *qrImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-60, 7, 30, 30)];
        qrImg.userInteractionEnabled = NO;
        qrImg.image = [UIImage imageNamed:@"icon_qr_default.png"];
        [qritem addSubview:qrImg];
        [qritem setClickAction:@selector(clickQrItemAction:) responder:self];
        [backScrollView addSubview:qritem];
        
        
        
        tradeItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, qritem.bottom+10, SCREENWIDTH, 44) withTitleLabel:@"身份" type:JWEditLable detailImgName:nil];
        tradeItem.detailLabel.textAlignment = NSTextAlignmentLeft;
        [backScrollView addSubview:tradeItem];
        
        
        UIButton *contactServiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-140, tradeItem.bottom+10, 130, 40)];
        [contactServiceBtn setTitle:@"修改行业联系客服" forState:UIControlStateNormal];
        [contactServiceBtn setTitleColor:SquareLinkColor forState:UIControlStateNormal];
        [contactServiceBtn addTarget:self action:@selector(contactServiceBtnFunction:) forControlEvents:UIControlEventTouchUpInside];
        contactServiceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [backScrollView addSubview:contactServiceBtn];
        
        backScrollView.contentSize = CGSizeMake(SCREENWIDTH, contactServiceBtn.bottom+20);
    }else{
        //位置
        JWEditView * locationItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, phoneItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"所在地" type:JWEditLable detailImgName:@"icon_right_img.png"];
        locationItem.detailLabel.textAlignment = NSTextAlignmentRight;
        [backScrollView addSubview:locationItem];
        locationItem.tag = 89;
        [locationItem setClickAction:@selector(locationselected:) responder:self];
        
        tradeItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, locationItem.bottom+10, SCREENWIDTH, 44) withTitleLabel:@"身份" type:JWEditLable detailImgName:nil];
        tradeItem.detailLabel.textAlignment = NSTextAlignmentLeft;
        [backScrollView addSubview:tradeItem];

        
       JWEditView * autItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, tradeItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"升级为纹身师" type:JWEditLable detailImgName:@"icon_right_img.png"];
        autItem.detailLabel.textAlignment = NSTextAlignmentLeft;
        autItem.titleLabel.width+=40;
        [autItem bringSubviewToFront:autItem.titleLabel];
        autItem.titleLabel.textColor = SquareLinkColor;
        [autItem setClickAction:@selector(authenFunction:) responder:self];
        [backScrollView addSubview:autItem];
        
        backScrollView.contentSize = CGSizeMake(SCREENWIDTH, autItem.bottom+40);
    }
  

    [self reloadLocalData];
    


}

#pragma mark -- 认证纹身
- (void)authenFunction:(id)sender
{
    RealNameAuthenticationViewController *reaNameVC = [[RealNameAuthenticationViewController alloc]init];
    [self.navigationController pushViewController:reaNameVC animated:YES];
}

#pragma mark -- 个人介绍

- (void)pushToUserDesCribeViewController:(UIButton *)sender
{
    UserDescribeViewController *desVC = [[UserDescribeViewController alloc ]init];
    [self.navigationController pushViewController:desVC animated:YES];
    
}

#pragma mark -------------------------- 点击二维码
- (void)clickQrItemAction:(id)sender
{
    QrCodeViewController *qrcodeVC = [[QrCodeViewController alloc]init];
    [self.navigationController pushViewController:qrcodeVC animated:YES];
    
}

#pragma mark ---------------------－－－－－－加载存在的数据
- (void)reloadLocalData
{
    nameItem.editTextField.text = [User defaultUser].item.nickname;
    
    if ([[User defaultUser].item.gender boolValue] == YES) {
        currentGender = @"1";
        maleBtn.desIamgeView.image = [UIImage imageNamed:@"icon_radio_useInfo.png"];
        femaleBtn.desIamgeView.image = [UIImage imageNamed:@"icon_radio_normal.png"];
    }else{
        currentGender = @"0";
        femaleBtn.desIamgeView.image = [UIImage imageNamed:@"icon_radio_useInfo.png"];
        maleBtn.desIamgeView.image = [UIImage imageNamed:@"icon_radio_normal.png"];
    }
    
    wxItem.editTextField.text = [User defaultUser].item.wxNum;
    phoneItem.detailLabel.text = [User defaultUser].item.phonenum;
    if ([NSObject nulldata:[User defaultUser].item.avatar]) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:[User defaultUser].item.avatar] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
    }
   
    tradeItem.detailLabel.text = [UIUtils findTypeFrom:@{@"sector":[User defaultUser].item.sector?[User defaultUser].item.sector:@"10"}];
    
    
    JWEditView * locationItem  = (JWEditView *)[self.view viewWithTag:89];
    if (locationItem) {
        locationItem.detailLabel.text = [[JudgeMethods defaultJudgeMethods]getCurrentCityName];
    }
}


#pragma mark ------------------------------- 设置头像 男女 生日 微信 类型 行业等等
- (void)clickGenderItemAction:(UserHomeBtn *)sender
{
    
    if (sender == maleBtn) {
        currentGender = @"1";
        maleBtn.desIamgeView.image = [UIImage imageNamed:@"icon_radio_useInfo.png"];
        femaleBtn.desIamgeView.image = [UIImage imageNamed:@"icon_radio_normal.png"];
        return;

    }else{
        currentGender = @"0";
        femaleBtn.desIamgeView.image = [UIImage imageNamed:@"icon_radio_useInfo.png"];
        maleBtn.desIamgeView.image = [UIImage imageNamed:@"icon_radio_normal.png"];
    }

}

#pragma mark --------------------------------设置机构
- (void)clickCompanyItemAction:(UIButton *)sender
{
    
    GoStoreSettingViewController *gostoreVC = [[GoStoreSettingViewController alloc]init];
//    gostoreVC.delegate = self;
    [self.navigationController pushViewController:gostoreVC animated:YES];
    
}

//#pragma mark --------------------------------机构回调
//- (void)completeCompanyEditWithDict:(NSDictionary *)dict
//{
//    
//    if (dict) {
//        [userInfoDict setObject:dict forKey:@"company"];
//    }else{
//        [userInfoDict removeObjectForKey:@"company"];
//    }
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //头像
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            // 拍照
            UIImagePickerController* controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            // 拍照
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] ) {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                controller.showsCameraControls = YES;
            } else {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            controller.allowsEditing = YES;
            [self.navigationController presentViewController: controller
                                                    animated: YES
                                                  completion: NULL];
        } else if(buttonIndex == 1) {
            
            // 选取照片
            UIImagePickerController* controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            // 媒体库
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.allowsEditing = YES;
            if([controller.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [controller.navigationBar setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forBarMetrics:UIBarMetricsDefault];
                controller.navigationBar.tintColor = [UIColor whiteColor];
            }
            [self.navigationController presentViewController: controller
                                                    animated: YES
                                                  completion: NULL];
        }
        return;
 
    }
}

#pragma mark ----------------------------- UIImagePickerViewControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage* image = info[UIImagePickerControllerEditedImage];
    headImg = image;
    headImageView.image = image;
    [picker dismissViewControllerAnimated: YES completion: NULL];
    
}


#pragma mark ---------------------------- 选择投降
- (void)clickUserViewAction:(UIButton *)sender
{
    //头像
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"取消" destructiveButtonTitle: nil otherButtonTitles: @"拍照", @"从手机相册选择" , nil];
    actSheet.tag = 1;
    [actSheet showInView: self.view];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == nameItem.editTextField && ![string isEqualToString:@""] && textField.text.length >=16) {
        return NO;
    }
    if (textField == wxItem.editTextField && ![string isEqualToString:@""] && textField.text.length >=29) {
        return NO;
    }
   
    return YES;
}

#pragma mark--
- (void)contactServiceBtnFunction:(id)sender
{
   
    [JudgeMethods defaultJudgeMethods].showKefuMessage = NO;
    [JudgeMethods defaultJudgeMethods].kefuMessageCount = 0;
    if (![User defaultUser].supportRongyun) {
        [SVProgressHUD showErrorWithStatus:@"客服系统异常，正在排查中，请稍后使用"];
        return;
    }
    ContactServerViewController *conversationVC = [[ContactServerViewController alloc]init];
    conversationVC.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    conversationVC.conversationType = 1;
    conversationVC.targetId =[NSString stringWithFormat:@"%@",[User defaultUser].kefuNum];
    conversationVC.userName = [User defaultUser].kefuName;
    conversationVC.title = [User defaultUser].kefuName;
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:conversationVC action:@selector(backAction)];
    leftBar.tintColor = [UIColor whiteColor];
    conversationVC.navigationItem.leftBarButtonItem = leftBar;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --- 地址选择

- (void)locationselected:(id)sender
{
    CitySelectedViewController *cityVC = [[CitySelectedViewController alloc]init];

    __weak __typeof(self) weakself = self;
    cityVC.block = ^(CityObject *selectedCity){
        if (selectedCity) {
            citySelectedObject = [[CityObject alloc]init];
            citySelectedObject = selectedCity;
            JWEditView * locationItem  = (JWEditView *)[weakself.view viewWithTag:89];
            if (locationItem) {
                locationItem.detailLabel.text = citySelectedObject.areaName;
            }
        }
    };
    [self presentViewController:[[BaseNavigationViewController alloc] initWithRootViewController:cityVC] animated:YES completion:NULL];
    
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
