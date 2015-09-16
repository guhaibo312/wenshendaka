//
//  AboutUsViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/1.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"关于我们";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //软件图标 appIcon
    UIImageView *appIcon = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-45, 40, 90, 90)];
    appIcon.image = [UIImage imageNamed:@"icon-60@2x.png"];
    appIcon.layer.cornerRadius = 15.0;
    appIcon.layer.masksToBounds = YES;
    [self.view addSubview:appIcon];
    
    //软件名称appNameLabel
    UILabel *appName = [UILabel labelWithFrame:CGRectMake(0, appIcon.bottom + 12.5, SCREENWIDTH, 22) fontSize:16 fontColor:RGBCOLOR_HEX(0x333333) text:@"纹身大咖"];
    appName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:appName];
    
    //软件版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    UILabel *appVersion = [UILabel labelWithFrame:CGRectMake(0, appName.bottom + 11, SCREENWIDTH, 13) fontSize:13 fontColor:RGBCOLOR_HEX(0x333333) text:[NSString stringWithFormat:@"版本 %@",version]];
    appVersion.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:appVersion];
    
    //底部的关于公司2行label
    UILabel *companyLabel = [UILabel labelWithFrame:CGRectMake(0, SCREENHEIGHT-64-44, SCREENWIDTH, 12) fontSize:11 fontColor:RGBCOLOR_HEX(0x888888) text:@"Copyright © 2015 北京微蜜科技有限公司"];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:companyLabel];
    
    UILabel *bottomLabel = [UILabel labelWithFrame:CGRectMake(0, companyLabel.bottom + 3, SCREENWIDTH, 12) fontSize:11 fontColor:RGBCOLOR_HEX(0x888888) text:@"weimi@utodo.cn"];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];

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
