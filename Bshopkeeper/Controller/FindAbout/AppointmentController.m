//
//  AppointmentController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AppointmentController.h"
#import "Configurations.h"
#import "ShopAppointment.h"
#import "MJExtension.h"
#import "ShopAppointmentCell.h"
#import "ShopAppointmentHeaderView.h"
#import "CompanyInfoItem.h"
#import "ShopInfoModel.h"

@interface AppointmentController ()<ShopAppointmentHeaderViewDelegate,UMSocialUIDelegate,ShopAppointmentCellDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) NSArray *shops;

@property (nonatomic,copy) NSString *selectUserId;

@end

@implementation AppointmentController

- (NSArray *)shops
{
    if (!_shops) {
        _shops = [NSArray array];
    }
    return _shops;
}

- (void)setShopInfo:(ShopInfoModel *)shopInfo
{
    _shopInfo = shopInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpData];
    
    self.title = @"店铺纹身师";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpHeaderView];
    
}

- (void)setUpHeaderView
{
    
    if (self.userEditable) {
        ShopAppointmentHeaderView *headerView = [ShopAppointmentHeaderView shopAppointmentHeaderView];
        headerView.delegate = self;
        self.tableView.tableHeaderView = headerView;
    }else{
        UIView *view = [[UIView alloc] init];
        view.x = view.y = 0;
        view.height = 10;
        view.width = self.view.width;
        self.tableView.tableHeaderView = view;
    }

}

- (void)setUpData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyId"] = self.shopInfo.company.companyId;
    
    [[JWNetClient defaultJWNetClient] getNetClient:@"Company/clerkList" requestParm:params result:^(id responObject, NSString *errmsg) {
        if (!errmsg) {
            self.shops = [ShopAppointment objectArrayWithKeyValuesArray:responObject[@"data"][@"list"]];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shops.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopAppointment *shop = self.shops[indexPath.row];
    ShopAppointmentCell *cell = [ShopAppointmentCell shopAppointmentCellWithTableView:tableView];
    cell.shop = shop;
    cell.shopInfo = self.shopInfo;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

- (void)shopAppointmentHeaderViewDidClick:(ShopAppointmentHeaderView *)shopAppointmentHeaderView
{
    NSString *platName = [UMSocialSnsPlatformManager getSnsPlatformString:UMSocialSnsTypeWechatSession];

    NSString *content = [NSString stringWithFormat:@"%@正在邀请你加入%@",[User defaultUser].item.nickname,self.companyInfo.name];
    [[UMSocialControllerService defaultControllerService] setShareText:content
                                                            shareImage:self.companyInfo.logo
                                                      socialUIDelegate:self];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:platName].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
    
    if (platformName==UMShareToWechatSession) {//微信好友
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;//消息类型
        [UMSocialData defaultData].extConfig.wechatSessionData.url = API_SHAREURL_SHOP(self.shopInfo.company.companyId);
        [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"%@向你发起邀请",[User defaultUser].item.nickname];
    }
    
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    BOOL issuccess = (response.responseCode == UMSResponseCodeSuccess) ? YES : NO;
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
    }else {
        [SVProgressHUD showErrorWithStatus: result];
    }
    
}

- (void)shopAppointmentCellDidClick:(ShopAppointmentCell *)shopAppointmentCell button:(UIButton *)button userId:(NSString *)userId
{
    self.selectUserId = userId;
    switch (button.tag) {
        case MoreButtontTypeOwnerManager:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"主理人",@"退出本店",@"取消管理员" ,nil];
            sheet.tag = MoreButtontTypeOwnerManager;
            [sheet showInView:self.view];
        }
            break;
        case MoreButtontTypeOwnerOrdinary:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"主理人",@"管理员",@"退出本店",nil];
            sheet.tag = MoreButtontTypeOwnerOrdinary;
            [sheet showInView:self.view];
        }
            break;
            
        case MoreButtontTypeManagerMine:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出本店",nil];
            sheet.tag = MoreButtontTypeManagerMine;
            [sheet showInView:self.view];
        }
            break;
        case MoreButtontTypeOrdinary:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出本店",nil];
            sheet.tag = MoreButtontTypeOrdinary;
            [sheet showInView:self.view];
        }
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case MoreButtontTypeOwnerManager:
            [self ownerManagerHttp : buttonIndex];
            break;
        case MoreButtontTypeOwnerOrdinary:
            [self ownerOrdinaryHttp : buttonIndex];
            break;
        case MoreButtontTypeManagerMine:
            [self managerMineHttp : buttonIndex];
            break;
        case MoreButtontTypeOrdinary:
            [self ordinaryHttp : buttonIndex];
            break;
    }
    
    [self.tableView reloadData];
}

- (void)ownerManagerHttp :(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://主理人
        {
            [self transferOwner];
        }
            break;
            
        case 1://退出本店
        {
           [self quitShop];
        }
            break;
            
        case 2://取消管理员
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"companyId"] = self.companyInfo.companyId;
            params[@"userId"] = self.selectUserId;
            
            [[JWNetClient defaultJWNetClient] deleteNetClient:@"Company/Admin/info" requestParm:params result:^(id responObject, NSString *errmsg) {
                if (!errmsg) {
                    [SVProgressHUD showSuccessWithStatus:@"已取消"];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:errmsg];
                }
            }];
        }
            break;
    }

}

- (void)ownerOrdinaryHttp :(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://主理人
        {
            [self transferOwner];
        }
            break;
            
        case 1://管理员
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"companyId"] = self.companyInfo.companyId;
            params[@"userId"] = self.selectUserId;
            
            [[JWNetClient defaultJWNetClient] putNetClient:@"Company/Admin/info" requestParm:params result:^(id responObject, NSString *errmsg) {
                if (!errmsg) {
                    [SVProgressHUD showSuccessWithStatus:@"设置管理员成功"];
                }else
                {
                    [SVProgressHUD showErrorWithStatus:errmsg];
                }
            }];
        }
            break;
            
        case 2://退出本店
        {
            [self quitShop];
        }
            break;
    }
}

- (void)managerMineHttp :(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self quitShop];
        }
            break;
    }
}

- (void)ordinaryHttp :(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            [self quitShop];
        }
            break;
    }
}

- (void)quitShop
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyId"] = self.companyInfo.companyId;
    params[@"userId"] = self.selectUserId;
    
    [[JWNetClient defaultJWNetClient] deleteNetClient:@"Company/Admin/deleteClerk" requestParm:params result:^(id responObject, NSString *errmsg) {
        if (!errmsg) {
            [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }
    }];
}

- (void)transferOwner
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"companyId"] = self.companyInfo.companyId;
    params[@"userId"] = self.selectUserId;
    
    [[JWNetClient defaultJWNetClient] postNetClient:@"Company/Admin/info" requestParm:params result:^(id responObject, NSString *errmsg) {
        if (!errmsg) {
            [SVProgressHUD showSuccessWithStatus:@"设置主理人成功"];
        }else
        {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }
    }];
}

@end
