//
//  AboutMeViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AboutMeViewController.h"
#import "StoreInfoSettingsViewController.h"
#import "H5PreviewManageViewController.h"
#import "InfoItemView.h"
#import "UserInfoView.h"
#import "MobClick.h"
#import "JWChatMessageModel.h"
#import "ShopDetailController.h"
#import "CreateShopController.h"
#import "ShopFinishController.h"
#import "MJExtension.h"
#import "CompanyInfoItem.h"

@interface AboutMeViewController ()<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{

    UITableView *listTable;
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UserInfoView *userInfoView;
@end

@implementation AboutMeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.view.backgroundColor = VIEWBACKGROUNDCOLOR;
    
    [self layoutSubViews];
}

- (void)layoutSubViews
{
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    if (self.userInfoView) {
        UIButton *clickUserInfoView = [[UIButton alloc]initWithFrame:_userInfoView.bounds];
        clickUserInfoView.backgroundColor = [UIColor clearColor];
        [clickUserInfoView addTarget:self action:@selector(pushToUserInfoController:) forControlEvents:UIControlEventTouchUpInside];
        [_userInfoView addSubview:clickUserInfoView];
        [self.view addSubview:_userInfoView];
    }
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, SCREENHEIGHT-64-60)];
    listTable.delegate = self;
    listTable.backgroundColor = VIEWBACKGROUNDCOLOR;
    listTable.dataSource = self;
    listTable.tableFooterView = [[UIView alloc] init];
    listTable.tableHeaderView = self.userInfoView;
    listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listTable];
    
    [self joinDataArrayItem];
    [listTable reloadData];
    
}


- (void)myshop
{
    
    [[JWNetClient defaultJWNetClient] getNetClient:@"CompanyApplication/info" requestParm:nil result:^(id responObject, NSString *errmsg) {
        
        if (!self) return ;
        if (!errmsg) {
            NSString *statue = responObject[@"data"][@"status"];
            [User defaultUser].item.companyId = responObject[@"data"][@"companyId"];
            
            switch ([statue intValue]) {
                case -1://没有店铺
                    [self.navigationController pushViewController:[[CreateShopController alloc] init] animated:YES];
                    break;
                    
                case  0://提交审核中
                {
                    ShopFinishController *shopVc = [[ShopFinishController alloc] init];
                    shopVc.myShop = YES;
                    [self.navigationController pushViewController:shopVc animated:YES];
                }
                    break;
                    
                case  1://审核成功
                {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    if (![NSObject nulldata:[User defaultUser].item.companyId]) return;
                    params[@"companyId"] = [User defaultUser].item.companyId;
                    params[@"clerks"] = @"";
                    params[@"products"] = @"";
                    
                    [[JWNetClient defaultJWNetClient] getNetClient:@"Company/info" requestParm:params result:^(id responObject, NSString *errmsg) {
                        if (!errmsg) {
                            ShopDetailController *detail = [[ShopDetailController alloc] init];
                            detail.companyInfo = [CompanyInfoItem objectWithKeyValues:responObject[@"data"][@"company"]];
                            [self.navigationController pushViewController:detail animated:YES];
                        }else
                        {
                            [SVProgressHUD showErrorWithStatus:errmsg];
                        }
                    }];
                }
                    break;
                    
                case  2://审核拒绝
                    [self reloadCreate];
                    break;
            }
        }
        
    }];
}

- (void)reloadCreate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"资料未提交审核,是否重新提交?" delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"是", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[[CreateShopController alloc] init] animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_userInfoView) {
        [_userInfoView reloadData];
        [listTable reloadData];
    }

}


#pragma mark -- 个人资料

- (void)pushToUserInfoController:(UIButton *)sender
{
    StoreInfoSettingsViewController *sets = [[StoreInfoSettingsViewController alloc]initWithQuery:nil];
    [self.navigationController pushViewController:sets animated:YES];
}

- (UserInfoView *)userInfoView
{
    if (_userInfoView == nil) {
        _userInfoView = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 10, SCREENWIDTH, 88)];
        
    }
    return _userInfoView;
}


#pragma mark -- tableView Delegate －－  datasourch

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellidentifier = @"Cellidentifier";
    InfoItemViewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier];
    if (!cell) {
        cell = [[InfoItemViewItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellidentifier];
    }
    InfoItemViewItem *item = _dataArray[indexPath.section];
    [cell setInfoValue:item];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InfoItemViewItem *item = _dataArray[indexPath.section];
    if (item.DesController) {
    
        //我的人气
        if ([item.DesController isEqualToString:@"H5PreviewManageViewController"]) {
            
            NSString *url = [NSString stringWithFormat:@"http://n.wenshendaka.com/hot/?storeId=%@",[User defaultUser].item.userId];
            H5PreviewManageViewController *hotVC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":url ,@"title":@"我的人气"}];
            [self.navigationController pushViewController:hotVC animated:YES];
            
            return;
        }else if ([item.DesController isEqualToString:@"myshop"]){
            [self myshop];
            return;
        }else{
            Class sampleClase = NSClassFromString(item.DesController);
            UIViewController *controller = (UIViewController *)[[sampleClase alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[User defaultUser].item.sector integerValue] == 30) {//纹身师
        if (section == 1 || section == 2) {
            return 1;
        }else
        {
            return 10;
        }
    }else
    {
        return 10;
    }
    
}

#pragma mark -- 是否是纹身师
- (void)joinDataArrayItem
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];

    if ([[User defaultUser].item.sector integerValue] == 30) {
        InfoItemViewItem *one = [[InfoItemViewItem alloc]init];
        one.iconImg           = [UIImage imageNamed:@"icon_mine_liked.png"];
        one.itemTitle         = @"我的人气";
        one.detailTitle       = [NSString stringWithFormat:@"排名: %@",[User defaultUser].storeItem.hotRankCountry];
        one.DesController     = @"H5PreviewManageViewController";
        [tempArray addObject:one];
    }
    
    InfoItemViewItem *two = [[InfoItemViewItem alloc]init];
    two.iconImg           = [UIImage imageNamed:@"icon_mine_circle.png"];
    two.itemTitle         = @"我的圈子";
    two.DesController     = @"SquareUserPageViewController";
    [tempArray addObject:two];
    
    if ([[User defaultUser].item.sector integerValue] == 30) {//纹身师
        
        InfoItemViewItem *threee = [[InfoItemViewItem alloc]init];
        threee.iconImg           = [UIImage imageNamed:@"myshop.png"];
        threee.itemTitle         = @"我的店铺" ;
        threee.DesController     = @"myshop";
        [tempArray addObject:threee];

        if (![[User defaultUser].item.v boolValue]) {
            InfoItemViewItem *four = [[InfoItemViewItem alloc]init];
            four.iconImg           = [UIImage imageNamed:@"icon_mine_realname.png"];
            four.itemTitle         = @"认证纹身师";
            four.DesController     = @"RealNameAuthenticationViewController";
            [tempArray addObject:four];
        }
    }
    
    InfoItemViewItem *last = [[InfoItemViewItem alloc]init];
    last.iconImg           = [UIImage imageNamed:@"icon_mine_set.png"];
    last.itemTitle         = @"设置";
    last.DesController     = @"SetingViewController";
    [tempArray addObject:last];

    self.dataArray = [NSMutableArray arrayWithArray:tempArray];
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
