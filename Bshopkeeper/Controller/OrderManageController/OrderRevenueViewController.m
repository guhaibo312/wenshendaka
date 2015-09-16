//
//  OrderRevenueViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderRevenueViewController.h"
#import "OrderMyBankCardViewController.h"
#import "OrderBankCardBundledViewController.h"
#import "OrderNotExtractCashViewController.h"
#import "ListOperationCell.h"
#import "ContactServerViewController.h"

@interface OrderRevenueViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *noWithdrawLabel;                       //还没有提现金额
    UILabel *withDrawLabel;                         //已经提现的金额
    UITableView *table;
}
@property (nonatomic, strong)NSMutableDictionary *revenueDict;

@end

@implementation OrderRevenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收入管理";
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    
    [self layoutSubViews];
    
    [self requestRevenueAction];
}

/** 查看收入余额
 */
- (void)requestRevenueAction
{
    if (!self) return;
    if ([self currentIsTopViewController]) {
        [LoadingView show:@"请稍后..."];
    }
    self.view.userInteractionEnabled = NO;
    [[JWNetClient defaultJWNetClient]getNetClient:@"User/income" requestParm:nil result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return;
        self.view.userInteractionEnabled = YES;
        [self requestRevenueActionFinish:responObject];
    }];
}


- (void)requestRevenueActionFinish:(NSDictionary *)result
{
    
    if (self == NULL || !result) return;
    if (result[@"data"]) {
        _revenueDict = [[ NSMutableDictionary alloc]initWithDictionary:result[@"data"]];
    }
    NSString *totalStr = [NSString stringWithFormat:@"%d",[[NSString stringWithFormat:@"%@",_revenueDict?_revenueDict[@"unconfirmedAmount"]:@"0"] integerValue]+[[NSString stringWithFormat:@"%@",_revenueDict?_revenueDict[@"waitDrawAmount"]:@"0"] integerValue]+[[NSString stringWithFormat:@"%@",_revenueDict?_revenueDict[@"drawingAmount"]:@"0"] integerValue]];

    noWithdrawLabel.text = totalStr;
    withDrawLabel.text = [NSString stringWithFormat:@"%@",_revenueDict?_revenueDict[@"drawDoneAmount"]:@"0"];
    
}

- (void)layoutSubViews
{
    //未提现
    UIButton *noWithDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, (SCREENHEIGHT-64)/3)];
    noWithDrawBtn.backgroundColor = [UIColor whiteColor];
    noWithDrawBtn.tag= 6;
    [noWithDrawBtn addTarget:self action:@selector(noWithDrawBtnFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noWithDrawBtn];
    
    UILabel *quitLabel1 = [UILabel labelWithFrame:CGRectMake(40, noWithDrawBtn.height/2+10+20, 10, 17) fontSize:12 fontColor:[UIColor blackColor] text:@"¥"];
    [noWithDrawBtn addSubview:quitLabel1];
    
    UILabel *firstTitlelabel =  [UILabel labelWithFrame:CGRectMake(40, noWithDrawBtn.height/2-40, SCREENWIDTH-80, 22) fontSize:18 fontColor:GRAYTEXTCOLOR text:@"未提现金额"];
    [noWithDrawBtn addSubview:firstTitlelabel];
    
    noWithdrawLabel = [UILabel labelWithFrame:CGRectMake(60, noWithDrawBtn.height/2+10, SCREENWIDTH-80, 40) fontSize:32 fontColor:[UIColor blackColor] text:@"0"];
    [noWithDrawBtn addSubview:noWithdrawLabel];
    
    UIImageView *point1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20,noWithDrawBtn.height/2-5, 6, 10)];
    point1.image = [UIImage imageNamed:@"icon_right_img.png"];
    [noWithDrawBtn addSubview:point1];

    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, noWithDrawBtn.bottom-1, SCREENWIDTH, 1)];
    lineView.backgroundColor = LINECOLOR;
    [self.view addSubview:lineView];
    
    //已提现
    UIButton *withDrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, noWithDrawBtn.bottom, SCREENWIDTH, (SCREENHEIGHT-64)/5)];
    withDrawBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:withDrawBtn];
    
    UILabel *quitLabel2 = [UILabel labelWithFrame:CGRectMake(40, withDrawBtn.height/2+15, 10, 17) fontSize:12 fontColor:[UIColor blackColor] text:@"¥"];
    [withDrawBtn addSubview:quitLabel2];
    
    UILabel *secondTitleLabel =  [UILabel labelWithFrame:CGRectMake(40, withDrawBtn.height/2-30, SCREENWIDTH-80, 22) fontSize:18 fontColor:GRAYTEXTCOLOR text:@"已提现金额"];
    [withDrawBtn addSubview:secondTitleLabel];
    
    withDrawLabel = [UILabel labelWithFrame:CGRectMake(60, withDrawBtn.height/2, SCREENWIDTH-80, 40) fontSize:32 fontColor:[UIColor blackColor] text:@"0"];
    [withDrawBtn addSubview:withDrawLabel];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, withDrawBtn.bottom, SCREENWIDTH, SCREENHEIGHT-64-withDrawBtn.height-noWithDrawBtn.height)];
    table.backgroundColor = VIEWBACKGROUNDCOLOR;
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = VIEWBACKGROUNDCOLOR;
    table.tableFooterView = footView;
    [self.view addSubview:table];
    
}

#pragma mark --------------------------点击未提现--------------------------------------

- (void)noWithDrawBtnFunction:(UIButton *)sender
{
    OrderNotExtractCashViewController *cashVC = [[OrderNotExtractCashViewController alloc]initWithQuery:_revenueDict?_revenueDict:nil];
    [self.navigationController pushViewController:cashVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ListOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ListOperationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *point2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-25, 0, 6, 10)];
        point2.image = [UIImage imageNamed:@"icon_right_img.png"];
        cell.accessoryView = point2;
    }
    cell.nameLabel.textColor = GRAYTEXTCOLOR;
    if (indexPath.section == 0) {
        cell.headImg.image = [UIImage imageNamed:@"icon_order_bankCard.png"];
        cell.nameLabel.text = @"绑定银行卡";
    }else{
        cell.headImg.image = [UIImage imageNamed:@"icon_order_service.png"];
        cell.nameLabel.text = @"联系客服";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    aview.backgroundColor = VIEWBACKGROUNDCOLOR;
    return aview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        User *logUser =  [User defaultUser];
        if (logUser.item.bankcard) {
            NSString *name = [logUser.item.bankcard objectForKey:@"name"];
            if ([NSObject nulldata:name ]) {
                OrderMyBankCardViewController*myBankVC = [[OrderMyBankCardViewController alloc]init];
                [self.navigationController pushViewController:myBankVC animated:YES];
                return;
            }
        }
        OrderBankCardBundledViewController *bankVC = [[OrderBankCardBundledViewController alloc]init];
        [self.navigationController pushViewController:bankVC animated:YES];
        return;
    }else{
        
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
        return ;

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
