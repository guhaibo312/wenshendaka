//
//  UserDescribeViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UserDescribeViewController.h"

@interface UserDescribeViewController ()<UITextViewDelegate>
{
    UITextView *contentTextView;
    UILabel *placeLabel;
}
@end

@implementation UserDescribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"个人简介";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setRightNavigationBarTitle:@"保存" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    contentTextView.textContainerInset = UIEdgeInsetsMake(10, 20, 10, 20);
    contentTextView.backgroundColor = [UIColor whiteColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.delegate = self;
    placeLabel = [UILabel labelWithFrame:CGRectMake(24, 0, SCREENWIDTH-40, 50) fontSize:14 fontColor:GRAYTEXTCOLOR text:[NSString stringWithFormat:@"说说你的从业经历、获奖荣誉、擅长风格、收费情况等"]];
    placeLabel.numberOfLines = 0;
    [contentTextView addSubview:placeLabel];
    [self.view addSubview:contentTextView];
    if ([ NSObject nulldata:[User defaultUser].item.faith]) {
        contentTextView.text = [User defaultUser].item.faith;
        placeLabel.hidden = YES;
    }else{
        placeLabel.hidden = NO;
    }
}

- (void)rightNavigationBarAction:(UIButton *)sender
{
    [contentTextView resignFirstResponder];
    [LoadingView show:@"请稍后..."];
    
    self.view.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;

    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    if ([NSObject nulldata:contentTextView.text]) {
        [parm setObject:contentTextView.text forKey:@"faith"];
    }else{
        [parm setObject:@"" forKey:@"faith"];
    }
    
    [[JWNetClient defaultJWNetClient]postNetClient:@"User/userInfo" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        self.view.userInteractionEnabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;

        if (errmsg == nil) {
            
            [[User defaultUser] changeUserInfo:[[responObject objectForKey:@"data"] objectForKey:@"changedData"] storeInf:nil];
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kEDITUSERINFOSUCESS object:nil];
            [super backAction];
        }else{
            [SVProgressHUD showErrorWithStatus:errmsg];
        }
        
    }];

    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![NSObject nulldata:textView.text]) {
        if (![text isEqualToString:@""]) {
            placeLabel.hidden = YES;
        }else{
            placeLabel.hidden = NO;
        }
    }else{
        if ([text isEqualToString:@""] && textView.text.length <=1) {
            placeLabel.hidden = NO;
        }else{
            placeLabel.hidden = YES;
        }
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    if ([NSObject nulldata:textView.text]) {
        placeLabel.hidden = YES;
    }else{
        placeLabel.hidden = NO;
    }
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([NSObject nulldata:textView.text]) {
        placeLabel.hidden = YES;
    }else{
        placeLabel.hidden = NO;
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
