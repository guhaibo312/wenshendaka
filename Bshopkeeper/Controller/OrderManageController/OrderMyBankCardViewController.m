//
//  OrderMyBankCardViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderMyBankCardViewController.h"
#import "OrderBankCardBundledViewController.h"
#import "UserHomeBtn.h"


@interface OrderMyBankCardViewController ()
{
    UIImageView *headImg;
    UILabel *nameLabel;
    UILabel *bankNameLabel;
    UILabel *numberLabel;
    UIImageView *footImg;
    NSDictionary *bankInfoD;
}
@end

@implementation OrderMyBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的银行卡";
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    
    UIView *bankInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 88)];
    bankInfoView.backgroundColor =  [UIColor whiteColor];
    [self.view addSubview:bankInfoView];
    bankInfoD = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BankName" ofType:@"plist"]];
    
    
    footImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, 0, 140, 88)];
    footImg.image = [UIImage imageNamed:@"icon_bank_gs1.png"];
    [bankInfoView addSubview:footImg];
    
    headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 44-30, 60, 60)];
    headImg.backgroundColor = [UIColor whiteColor];
    headImg.image = [UIImage imageNamed:@"icon_bank_gs.png"];
    [bankInfoView addSubview:headImg];
    
    nameLabel = [UILabel labelWithFrame:CGRectMake(headImg.right+10, 20, 100, 20) fontSize:14 fontColor:[UIColor blackColor] text:@""];
    [bankInfoView addSubview:nameLabel];
    
    bankNameLabel = [UILabel labelWithFrame:CGRectMake(headImg.right+10, nameLabel.bottom, 120, 20) fontSize:12 fontColor:[UIColor blackColor] text:@""];
    [bankInfoView addSubview:bankNameLabel];
    
    numberLabel = [UILabel labelWithFrame:CGRectMake(headImg.right+10, bankNameLabel.bottom, 150, 20) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
    [bankInfoView addSubview:numberLabel];
   
    
    UserHomeBtn *changeBankBtn = [UserHomeBtn buttonWithFrame:CGRectMake(0, bankInfoView.bottom+20, SCREENWIDTH, 40) text:@"更换银行卡" imageName:@"icon_order_changed.png"];
    changeBankBtn.desIamgeView.frame = CGRectMake(SCREENWIDTH/2-60, 10, 20, 20);
    changeBankBtn.nameLabel.frame = CGRectMake(SCREENWIDTH/2-30, 0, 100, 40);
    [changeBankBtn addTarget:self action:@selector(clickChangeBankBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    changeBankBtn.backgroundColor = VIEWBACKGROUNDCOLOR;
    
    [self.view addSubview:changeBankBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *bankcard = [User defaultUser].item.bankcard;
    if (bankcard) {
        nameLabel.text = bankcard[@"name"];
        NSString *cardNum = bankcard[@"cardNum"];
        if (cardNum) {
            numberLabel.text = [NSString stringWithFormat:@"尾号%@",[cardNum substringFromIndex:cardNum.length-4]];
        }
        if ([NSObject nulldata:bankcard[@"bank"]]) {
            bankNameLabel.text = [bankInfoD objectForKey:bankcard[@"bank"]];
        }
        headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",bankcard[@"bank"]]];
        footImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_m.png",bankcard[@"bank"]]];
    }
}

#pragma mark --------------------------- 点击更换银行卡------------------------------------
- (void)clickChangeBankBtnAction:(id)sender
{
    OrderBankCardBundledViewController *changedBankVC =[[OrderBankCardBundledViewController alloc]init];
    [self.navigationController pushViewController:changedBankVC animated:YES];
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
