//
//  ContactServerViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/26.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "ContactServerViewController.h"
#import "IQKeyboardManager.h"
#import "Configurations.h"

@interface ContactServerViewController ()

@end

@implementation ContactServerViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_img_white.png"] style:0 target:self action:@selector(backAction)];
    barButtonItem.tintColor = [UIColor whiteColor];
    [barButtonItem setImageInsets:UIEdgeInsetsMake(10, 0, 10, 20)];
    
    UIView *view = [[UIView alloc] init];
    view.width = 30;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItems = @[barButtonItem,item];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTextAlignment:1];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.text = self.title;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [[JudgeMethods defaultJudgeMethods]setShowKefuMessage:NO];
    [[JudgeMethods defaultJudgeMethods] setKefuMessageCount:0];
}

- (void)backAction
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
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
