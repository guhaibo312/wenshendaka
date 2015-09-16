//
//  OrderWxRMViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/28.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderWxRMViewController.h"
#import "OrderManageCenterViewController.h"
#import "Configurations.h"
#import "UserHomeBtn.h"
#import "UIImageView+WebCache.h"

@interface OrderWxRMViewController ()<UMSocialUIDelegate>

@end

@implementation OrderWxRMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = _isWXYY?@"微信邀约":@"微信收款";
    
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    UIView *topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 300)];
    topBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topBackView];

    
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(10, 50, SCREENWIDTH-20, 30) fontSize:18 fontColor:[UIColor blackColor] text:_isWXYY?@"微信邀约创建成功":@"微信收款创建成功!"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UILabel *subTitleLabel = [UILabel labelWithFrame:CGRectMake(10, titleLabel.bottom+10, SCREENWIDTH-20, 20) fontSize:14 fontColor:GRAYTEXTCOLOR text:_isWXYY?@"用以下方式发送给买家":@"请选择以下方式向买家发起收款"];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subTitleLabel];
    
    UserHomeBtn *wxSendBtn = [[UserHomeBtn alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-50, subTitleLabel.bottom+40, 100, 110) text:@"微信" imageName:@"icon_order_wxrecived.png"];
    wxSendBtn.desIamgeView.frame = CGRectMake(wxSendBtn.width/2-33, 15, 66, 66);
    wxSendBtn.nameLabel.frame = CGRectMake(0, wxSendBtn.height-25, wxSendBtn.width, 25);
    wxSendBtn.nameLabel.textAlignment = NSTextAlignmentCenter;
    [wxSendBtn setBackgroundImage:[UIUtils imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [wxSendBtn setBackgroundImage:[UIUtils imageFromColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [wxSendBtn addTarget:self action:@selector(wxsendBtnFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wxSendBtn];
}


- (void)wxsendBtnFunction:(UserHomeBtn *)sender
{
    
    if (!_oneItem) return;
    NSString *platName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeWechatSession];
    NSString *content = _oneItem.content;
    [[UMSocialControllerService defaultControllerService] setShareText:content
                                                            shareImage:_oneItem.shareImg
                                                      socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:platName].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}


-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    
    
    
    if (platformName==UMShareToWechatSession) {//微信好友
        if ([_oneItem.sharedURL isNonEmpty]) {
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;//消息类型
            [UMSocialData defaultData].extConfig.wechatSessionData.url = _oneItem.sharedURL;
        }
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = _oneItem.title;
    }
    
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    BOOL issuccess = (response.responseCode == UMSResponseCodeSuccess)?YES:NO;
    NSString *result = @"";
    if (response.responseCode == UMSResponseCodeSuccess) {
        result = @"发送成功";
    }else if (response.responseCode == UMSResponseCodeCancel){
        result = @"已取消";
    }else{
        result = @"发送失败";
    }
    if (issuccess) {
        [SVProgressHUD showSuccessWithStatus: result];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {
                OrderManageCenterViewController *manageVC = (OrderManageCenterViewController *)controller;
                [manageVC backToPindingList];
                [self.navigationController popToViewController:manageVC animated:YES];
                return;
            }
        }
    }else {
        [SVProgressHUD showErrorWithStatus: result];
    }
    
}

- (void)backAction
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {
            OrderManageCenterViewController *manageVC = (OrderManageCenterViewController *)controller;
            [manageVC backToPindingList];
            [self.navigationController popToViewController:manageVC animated:YES];
            return;
        }
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
