//
//  SetingViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SetingViewController.h"
#import "Configurations.h"
#import "AboutUsViewController.h"
#import "LogInViewController.h"
#import "UMFeedback.h"
#import "StoreInfoSettingsViewController.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"
#import "JWEditView.h"
#import <StoreKit/StoreKit.h>
#import "JWSocketManage.h"
#import "ContactServerViewController.h"
#import "GeTuiSdk.h"

@interface SetingViewController ()<SKStoreProductViewControllerDelegate>

{
    FilledColorButton *logOutBtn;
    
}
@end

@implementation SetingViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
    
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    JWEditView *aboutItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) withTitleLabel:@"关于我们" type:JWEditLable detailImgName:@"icon_right_img.png"];
    aboutItem.tag = 71;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    aboutItem.detailLabel.text = [NSString stringWithFormat:@"V%@",version] ;
    aboutItem.detailLabel.font = [UIFont systemFontOfSize:14];
    aboutItem.detailLabel.textColor = GRAYTEXTCOLOR;
    aboutItem.width -= 20;
    [aboutItem setClickAction:@selector(listAction:) responder:self];
    [self.view addSubview:aboutItem];


    JWEditView *helpItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, aboutItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"帮助与反馈" type:JWEditLable detailImgName:@"icon_right_img.png"];
    helpItem.tag = 72;
    helpItem.titleLabel.width +=40;
    [helpItem setClickAction:@selector(listAction:) responder:self];
    [self.view addSubview:helpItem];

//    JWEditView *pushItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, helpItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"给予好评" type:JWEditLable detailImgName:@"icon_right_img.png"];
//    pushItem.tag = 70;
//    pushItem.titleLabel.width +=40;
//    [pushItem setClickAction:@selector(listAction:) responder:self];
//    [self.view addSubview:pushItem];
    
    
    logOutBtn = [[FilledColorButton alloc]initWithFrame:CGRectMake(20, helpItem.bottom+40, SCREENWIDTH- 40, 40) color:[UIColor whiteColor] borderColor:SEGMENTSELECT textClolr:[UIColor blackColor] title:@"退出登录" fontSize:16 isBold:NO];
    [logOutBtn addTarget:self action:@selector(logOutAction:) forControlEvents:UIControlEventTouchUpInside];
    logOutBtn.layer.cornerRadius = 0;
    logOutBtn.layer.borderWidth = 2;
    logOutBtn.layer.borderColor = DeleteLayerBoderColor.CGColor;
    [self.view addSubview:logOutBtn];
    
}


#pragma mark ------------------------------- 退出登录
- (void)logOutAction:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:CURRENTLOGINSTATUS];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    [User defaultUser].isLogIn = NO;
    [LoadingView show:@"请稍候..."];
    sender.enabled = NO;
    
    
    
    [[JWNetClient defaultJWNetClient]postNetClient:@"User/logout" requestParm:@{} result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@%@",PRODUCTNAME,[User defaultUser].item.userId]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@%@",COMMODITYNAME,[User defaultUser].item.userId]];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,[User defaultUser].item.userId]];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [User defaultUser].isLogIn = NO;
        
        //容云断开
        [[RCIM sharedRCIM] disconnect];
        
        // 不接受消息
        [[AppDelegate appDelegate]openGetui:NO];
        
        [GeTuiSdk enterBackground];
        
//        [[JWSocketManage shareManage]disConnect];
        
        [[AppDelegate appDelegate]pushToLogInControllor:YES];

    }];
   
}


- (void)listAction:(JWEditView *)sender
{
    if (sender.tag == 71) {
        AboutUsViewController *aboutUs  = [[AboutUsViewController alloc]init];
        [self.navigationController pushViewController:aboutUs animated:YES];
    }else if (sender.tag == 70){
        
        SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
        storeProductViewContorller.delegate = self;
//          美掌柜id 990930202 纹身大咖id 1022212399
        [storeProductViewContorller loadProductWithParameters:
         @{SKStoreProductParameterITunesItemIdentifier : @"1022212399"} completionBlock:^(BOOL result, NSError *error) {
             if(error){
                 [self showAlertView:[[error userInfo] description]];
             }else{
                 [self presentViewController:storeProductViewContorller animated:YES completion:NULL];
             }
         }];

    }else if (sender.tag == 72){
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
        [self.navigationController pushViewController:conversationVC animated:YES];        return;
    }else{
        
    }

}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:NULL];
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
