//
//  ShopFinishController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ShopFinishController.h"
#import "Configurations.h"
#import "OrderWxRMViewController.h"
#import "SameCityViewController.h"

@interface ShopFinishController ()

@end

@implementation ShopFinishController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"申请认证";
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_img_white.png"] style:0 target:self action:@selector(back)];
    barButtonItem.tintColor = [UIColor whiteColor];
    [barButtonItem setImageInsets:UIEdgeInsetsMake(10, 0, 10, 20)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
}

- (void)back
{

    for (UIViewController *childVc in self.navigationController.viewControllers) {
        if ([childVc isKindOfClass:[SameCityViewController class]]) {
            [self.navigationController popToViewController:childVc animated:YES];
            return;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

- (IBAction)shareClick:(id)sender {
    SharedItem *shareItem = [[SharedItem alloc] init];
    NSString *  title = [NSMutableString stringWithFormat:@"%@向您发起邀约",[User defaultUser].item.nickname];
    shareItem.title = title;
    shareItem.content = @"邀请纹身师！";
    NSString *urlStr =  API_SHAREURL_SHOP(@"");
    shareItem.sharedURL = urlStr;
    UIImage *headImg = [UIImage imageNamed:@"icon_userHead_default.png"];
    shareItem.shareImg = headImg;
    
    OrderWxRMViewController *createdSucessVC = [[OrderWxRMViewController alloc]init];
    createdSucessVC.oneItem = shareItem;
    createdSucessVC.isWXYY = YES;
    [self.navigationController pushViewController:createdSucessVC animated:YES];
}

@end
