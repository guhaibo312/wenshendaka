//
//  RealNameAuthenticationViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  实名认证

#import "RealNameAuthenticationViewController.h"
#import "UserHomeBtn.h"
#import "ContactServerViewController.h"

@interface RealNameAuthenticationViewController ()<TTTAttributedLabelDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextField *nameField;
    UITextField *idField;
    UserHomeBtn *uploadbutton;
    UIImageView *photoImageView;
    UIScrollView *backScrollView;
    
    FilledColorButton *saveBtn;
}
@end

@implementation RealNameAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请认证";
    self.view.backgroundColor = [UIColor whiteColor];

    [LoadingView show:@"请稍后..."];
    [[JWNetClient defaultJWNetClient]getNetClient:@"Authentication/info" requestParm:@{} result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (self == NULL) return ;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            NSDictionary *dict = responObject[@"data"];
            if (dict ) {
                NSString *Authentication =[NSString stringWithFormat:@"%@",dict[@"Authentication"]];

                int ststus = [Authentication integerValue];
                
                if (ststus == 0) {
                    [self gettingCertifiedIsWaitingwithString:@"正在审核中..."];
                }else if (ststus == 10){
                    [self gettingCertifiedIsWaitingwithString:@"恭喜你，通过认证。"];
                }else if (ststus == -1){
                    [self gettingCertifiedIsStart];
                }else{
                    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"由于您的资料有误，认证未能通过，如有问题联系客服！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"重新提交资料",@"联系客服", nil];
                    alert.tag = 40;
                    [alert show];
                }
                
            }
            
        }
    }];
    
}

- (void)rightNavigationBarAction:(UIButton *)sender
{
    
    if (![NSObject nulldata:nameField.text] ){
        [SVProgressHUD showErrorWithStatus:@"请填写姓名"];
        return;
    }
    if (![NSObject nulldata:idField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写身份证号"];
        return;
    }
   
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if (![identityCardPredicate evaluateWithObject:idField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入有效身份证件"];
        return;
    }
    if (!photoImageView.image) {
        [SVProgressHUD showErrorWithStatus:@"还没传照片哦"];
        return;
    }
    
    self.view.userInteractionEnabled = NO;

    [UploadManager uploadImageList: [NSArray arrayWithObject:photoImageView.image] hasLoggedIn: YES success:^(NSArray *resultList) {
        if (self == NULL) return ;
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:nameField.text forKey:@"realName"];
        [parm setObject:idField.text forKey:@"idCard"];
        [parm setObject:resultList[0] forKey:@"image"];
        [LoadingView show:@"请稍后..."];
        [[JWNetClient defaultJWNetClient]putNetClient:@"Authentication/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (self == NULL)return ;
            self.view.userInteractionEnabled = YES;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [self gettingCertifiedIsWaitingwithString:@"提交成功,正在审核中..."];
            }
        }];
    } failure:^(NSError *error) {
        [LoadingView dismiss];
        self.view.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
    }];
    
}

#pragma mark-- 认证等待中
- (void)gettingCertifiedIsWaitingwithString:(NSString *)waitingString
{
    for (UIView *oneView in self.view.subviews) {
        if (oneView) {
            [oneView removeFromSuperview];
        }
    }
    
    UIImageView *sucessImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-64, 40, 128, 81)];
    sucessImageView.backgroundColor = [UIColor clearColor];
    sucessImageView.image = [UIImage imageNamed:@"icon_mine_aut_sucess.png"];
    sucessImageView.tag = 50;
    [self.view addSubview:sucessImageView];
    
    UILabel *statusLabel = [UILabel labelWithFrame:CGRectMake(10, sucessImageView.bottom+30, SCREENWIDTH-10, 30) fontSize:18 fontColor:RGBCOLOR(112., 185., 101.) text:waitingString];
    statusLabel.tag = 51;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:statusLabel];
    
    TTTAttributedLabel *kefuLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(30, statusLabel.bottom+30, SCREENWIDTH-60 , 30)];
    kefuLabel.font = [UIFont systemFontOfSize:14];
    kefuLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableDictionary *mutableLinkAttributes3 = [NSMutableDictionary dictionary];
    [mutableLinkAttributes3 setValue:(id)[SquareLinkColor CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
    [mutableLinkAttributes3 setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    kefuLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes3];
    kefuLabel.text = @"如有疑问，请联系客服";
    [kefuLabel sizeToFit];
    kefuLabel.center = CGPointMake(SCREENWIDTH/2, statusLabel.bottom+30);
    kefuLabel.delegate = self;
    [kefuLabel addLinkToPhoneNumber:@"联系客服" withRange:[@"如有疑问，请联系客服" rangeOfString:@"联系客服"]];
    [self.view addSubview:kefuLabel];
}

#pragma mark -- 认证开始界面

- (void)gettingCertifiedIsStart
{
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backScrollView];
    
    UILabel *label = [UILabel labelWithFrame:CGRectMake(10, 20, SCREENWIDTH-20, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:@"请填写个人信息申请认证纹身师"];
    [backScrollView addSubview:label];
    
    UIView *inputView = [[UIView alloc]initWithFrame:CGRectMake(10, label.bottom+10, SCREENWIDTH-20, 88)];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.layer.cornerRadius = 8;
    inputView.layer.borderWidth = 1;
    inputView.layer.borderColor = LINECOLOR.CGColor;
    inputView.clipsToBounds = YES;
    [backScrollView addSubview:inputView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, inputView.width, 1)];
    lineView.backgroundColor = LINECOLOR;
    [inputView addSubview:lineView];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(20, 2, inputView.width-30, 40)];
    nameField.placeholder = @"真实姓名";
    nameField.clearButtonMode= UITextFieldViewModeWhileEditing;
    nameField.font = [UIFont systemFontOfSize:14];
    nameField.backgroundColor = [UIColor clearColor];
    nameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 10)];
    [inputView addSubview:nameField];
    nameField.delegate = self;
    
    idField = [[UITextField alloc]initWithFrame:CGRectMake(20, 46, inputView.width-30, 40)];
    idField.placeholder = @"身份证号";
    idField.delegate = self;
    idField.clearButtonMode = UITextFieldViewModeWhileEditing;
    idField.returnKeyType = UIReturnKeyDone;
    idField.font = [UIFont systemFontOfSize:14];
    idField.backgroundColor = [UIColor clearColor];
    UIView *leftView2 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 10)];
    idField.leftView = leftView2;
    [inputView addSubview:idField];
    
    uploadbutton = [[UserHomeBtn alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-141, inputView.bottom+30, 282, 208)text:@"手持身份证头部照" imageName:@"icon_mine_addPhone.png"];
    uploadbutton.clipsToBounds = YES;
    uploadbutton.desIamgeView.frame = CGRectMake(uploadbutton.width/2-26, uploadbutton.height/2-40, 52,52);
    uploadbutton.nameLabel.frame = CGRectMake(10, uploadbutton.height/2+30, uploadbutton.width-20, 30);
    uploadbutton.layer.cornerRadius = 8;
    uploadbutton.nameLabel.font = [UIFont systemFontOfSize:14];
    uploadbutton.layer.borderColor = LINECOLOR.CGColor;
    uploadbutton.layer.borderWidth = 1;
    [uploadbutton addTarget:self action:@selector(uploadPhotoFunction:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:uploadbutton];
    
    photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-142, inputView.bottom+30, 282, 208)];
    photoImageView.layer.cornerRadius = 8;
    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    photoImageView.clipsToBounds = YES;
    photoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapphotoImage = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadPhotoFunction:)];
    [photoImageView addGestureRecognizer:tapphotoImage];
    photoImageView.hidden = YES;
    [backScrollView addSubview:photoImageView];
    
    
    UIImageView *sampleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-142, uploadbutton.bottom+20, 282, 208)];
    sampleImageView.image = [UIImage imageNamed:@"icon_mine_aut_sample.png"];
    sampleImageView.layer.cornerRadius = 8;
    sampleImageView.clipsToBounds = YES;
    [backScrollView addSubview:sampleImageView];
    
    
    saveBtn = [[FilledColorButton alloc]initWithFrame:CGRectMake(20, sampleImageView.bottom+20, SCREENWIDTH- 40, 40) color:[UIColor whiteColor] borderColor:SEGMENTSELECT textClolr:[UIColor blackColor] title:@"完 成" fontSize:16 isBold:NO];
    [saveBtn addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.layer.cornerRadius = 20;
    saveBtn.layer.borderWidth = 1;
    saveBtn.layer.borderColor = LINECOLOR.CGColor;
    [backScrollView addSubview:saveBtn];
    backScrollView.contentSize = CGSizeMake(SCREENWIDTH, saveBtn.bottom+40);

}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    [self contactService];
}

- (void)uploadPhotoFunction:(id)sender
{
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"取消" destructiveButtonTitle: nil otherButtonTitles: @"拍照", @"从手机相册选择" , nil];
    actSheet.tag = 1;
    [actSheet showInView: self.view];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 40 && buttonIndex == 1) {
        [self gettingCertifiedIsStart];
        return;
    }else if (alertView.tag == 40 && buttonIndex == 2){
        [self contactService];
    }
}

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
            controller.allowsEditing = NO;
            [self.navigationController presentViewController: controller
                                                    animated: YES
                                                  completion: NULL];
        } else if(buttonIndex == 1) {
            
            // 选取照片
            UIImagePickerController* controller = [[UIImagePickerController alloc] init];
            controller.delegate = self;
            // 媒体库
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.allowsEditing = NO;
            if([controller.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
            {
                [controller.navigationBar setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forBarMetrics:UIBarMetricsDefault];
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
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        photoImageView.image = image;
        photoImageView.hidden = NO;
        uploadbutton.hidden = YES;
    }
    [picker dismissViewControllerAnimated: YES completion: NULL];
    
    
}


#pragma mark-- UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == nameField && textField.text.length >= 8 && ![string isEqualToString:@""]) {
        return NO;
    }
    if (textField == idField && textField.text.length >= 18 && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)contactService
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
