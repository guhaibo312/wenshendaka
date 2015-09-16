//
//  OrderManageCenterViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/20.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderManageCenterViewController.h"
#import "Configurations.h"
#import "EditOrAddOrderViewController.h"
#import "OrderInfoDetailViewController.h"
#import "OrderWXYYViewController.h"
#import "UIImageView+WebCache.h"
#import "OrderModel.h"
#import "OrderTableCell.h"
#import "CustomerModel.h"
#import "OrderScrollView.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"
#import "UserInfoItem.h"
#import "OrderRecycleViewController.h"
#import "WXInvitationView.h"
#import "UserHomeBtn.h"
#import "OrderRevenueViewController.h"
#import "JWTabItemButton.h"
#import "TabBarView.h"

@interface OrderManageCenterViewController ()<UIScrollViewDelegate,JWSharedManagerDelegate>
{
   
    JWTabItemButton  *pendingBtn;                     //预约待确认
    JWTabItemButton  *historyBtn;                     //历史记录
    
    
    UserHomeBtn *weixinOrderBtn;                       //微信预约
    UserHomeBtn *registOrderBtn;                       //登记预约
    

    OrderScrollView *orderInfoScrollView;           //滚动页面
    UIImageView *_headI;
    UIImageView *pointImg;
}

@end

@implementation OrderManageCenterViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    // 请求数据
    [self requestFromServer];

}


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
    self.title = @"订单";
     _headI = [[UIImageView alloc]init];
    
    [self setRightNavigationBarTitle:@"收入" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    
    UIButton *recycleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [recycleBtn setImage:[UIImage imageNamed:@"icon_order_recycle.png"] forState:UIControlStateNormal];
    recycleBtn.backgroundColor = [UIColor clearColor];
    recycleBtn.imageEdgeInsets = UIEdgeInsetsMake(6, 0, 6, 4);
    [recycleBtn addTarget:self action:@selector(recycleButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *recycleBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:recycleBtn];
    self.navigationItem.leftBarButtonItem = recycleBarButtonItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化头部按钮
    [self initWithHeadView];
    
    
    BOOL wgw = [[NSUserDefaults standardUserDefaults]boolForKey:@"wgw"];
    if (wgw) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"yygl"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToSendDingJin:) name:@"closeWXYY" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestFromServer) name:kPushNotication object:nil];

}

#pragma mark ---------------------- 初始化顶部按钮

- (void)initWithHeadView
{
    
    registOrderBtn = [[UserHomeBtn alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/2, 140) text:@"微信收款" imageName:@"icon_order_recivedMoney.png"];
    registOrderBtn.desIamgeView.frame = CGRectMake(registOrderBtn.width/2-30, 23, 60, 60);
    registOrderBtn.nameLabel.frame = CGRectMake(0, registOrderBtn.desIamgeView.bottom+10, registOrderBtn.width, 20);
    registOrderBtn.tag = 40;
    registOrderBtn.nameLabel.textColor = [UIColor whiteColor];
    [registOrderBtn setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forState:UIControlStateNormal];
    [registOrderBtn setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forState:UIControlStateHighlighted];
    [registOrderBtn addTarget:self action:@selector(ordermanageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registOrderBtn];

    
    weixinOrderBtn = [[UserHomeBtn alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH/2, 140) text:@"微信邀约" imageName:@"icon_order_wxsend.png"];
    weixinOrderBtn.desIamgeView.frame = CGRectMake(weixinOrderBtn.width/2-30, 23, 60, 60);
    weixinOrderBtn.nameLabel.frame = CGRectMake(0, weixinOrderBtn.desIamgeView.bottom+10, weixinOrderBtn.width, 20);
    weixinOrderBtn.tag = 45;
    weixinOrderBtn.nameLabel.textColor = [UIColor whiteColor];
    [weixinOrderBtn setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forState:UIControlStateNormal];
    [weixinOrderBtn setBackgroundImage:[UIUtils imageFromColor:NAVIGATIONCOLOR] forState:UIControlStateHighlighted];
    [weixinOrderBtn addTarget:self action:@selector(ordermanageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinOrderBtn];
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2,0, 0.5, 140)];
    lineView1.backgroundColor = TAGSCOLORFORE;
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 0.5)];
    lineView2.backgroundColor = TAGSCOLORFORE;
    [self.view addSubview:lineView2];
    

    pendingBtn = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(0, weixinOrderBtn.bottom, SCREENWIDTH/2, 44) withTitle:@"预约待确认" normalTextColor:TAGBODLECOLOR needBottomView:NO];
    pendingBtn.backgroundColor = SEGMENTNORMAL;
    pendingBtn.selected = YES;
    [pendingBtn addTarget:self action:@selector(clickPendingBtnAndHistoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pendingBtn];
    
    historyBtn = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, weixinOrderBtn.bottom, SCREENWIDTH/2, 44) withTitle:@"预约记录" normalTextColor:TAGBODLECOLOR needBottomView:NO];
    historyBtn.backgroundColor = SEGMENTNORMAL;
    historyBtn.selected = NO;
    [historyBtn addTarget:self action:@selector(clickPendingBtnAndHistoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:historyBtn];
    
    
    
    orderInfoScrollView  = [[OrderScrollView alloc]initWithFrame:CGRectMake(0, pendingBtn.bottom, SCREENWIDTH, SCREENHEIGHT- 64-pendingBtn.bottom-49) withController:self];
    orderInfoScrollView.delegate = self;
    orderInfoScrollView.pagingEnabled = YES;
    orderInfoScrollView.scrollEnabled = NO;
    orderInfoScrollView.showsHorizontalScrollIndicator= NO;
    orderInfoScrollView.showsVerticalScrollIndicator= NO;
    [self.view addSubview:orderInfoScrollView];

    
   
    pointImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4-47.5, pendingBtn.bottom-4, 95, 8)];
    pointImg.image = [UIImage imageNamed:@"icon_order_pointer.png"];
    pointImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pointImg];
    
}

#pragma mark ---------------------- 点击登记预约 ／微信邀约---------------------------------------

- (void)ordermanageAction:(UIButton *)sender
{
    //登记预约 和 微信预约
    if (sender.tag == 40) {
        
        OrderWXYYViewController *wxyyVC = [[OrderWXYYViewController alloc]init];
        [self.navigationController pushViewController:wxyyVC animated:YES];
    }else{
        
        //判断需不需要提示 不需要直接发送
//        BOOL noPrompt = [[NSUserDefaults standardUserDefaults]boolForKey:ORDERNEEDPROMPT];
//        if (noPrompt) {
            [self pushToSendDingJin:nil];
//            return;
//        }
//
//        WXInvitationView *wxyyView = [[WXInvitationView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//        [wxyyView show];
        
    }
}



#pragma mark ----------------------------- 输入定金---------------------------------
- (void)pushToSendDingJin:(NSNotification *)noctication
{
//    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ORDERNEEDPROMPT];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
    OrderWXYYViewController *wxyyVC = [[OrderWXYYViewController alloc]initWithQuery:@{@"invitation":@YES}];
    [self.navigationController pushViewController:wxyyVC animated:YES];
}

#pragma mark----------------------- 点击回收站
- (void)recycleButtonFunction:(id)sender
{
    OrderRecycleViewController *orderRecycleVC = [[OrderRecycleViewController alloc]init];
    [self.navigationController pushViewController:orderRecycleVC animated:YES];
    return;
    
}

#pragma mark ----------------- 收入
- (void)rightNavigationBarAction:(UIButton *)sender
{
    OrderRevenueViewController *orderRevenueVC = [[OrderRevenueViewController alloc]init];
    [self.navigationController pushViewController:orderRevenueVC animated:YES];
    return;
}


#pragma mark ----------------------拉去数据
- (void)requestFromServer
{
    
    User *currentUser = [User defaultUser];
    NSString *requestLastUpTime = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,currentUser.item.userId]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (currentUser.storeItem.storeId) {
        [parm setObject:currentUser.storeItem.storeId forKey:@"storeId"];
        [parm setObject:@"true" forKey:@"new"];
        
    }
    if (requestLastUpTime) {
        //存在拉取上次以后的增量
        [parm setObject:requestLastUpTime forKey:@"updateTime"];
    }
    [[JWNetClient defaultJWNetClient]getNetClient:@"Order/list" requestParm:parm result:^(id responObject, NSString *errmsg) {
        if (self == NULL)return ;
        pendingBtn.enabled = YES;
        historyBtn.enabled = YES;
        if (errmsg && self) {
            [SVProgressHUD showErrorWithStatus:@"获取更新失败"];
            [self requestFinished:nil];
        }else{
            [self requestFinished:responObject];
        }
    }];
}
- (void)requestFinished:(id)result
{
    if (result != nil) {
        User *currentUser = [User defaultUser];
        TJWOperationDB *operationDB = [TJWOperationDB initWithSqlName:[NSString stringWithFormat:@"Users%@.sqlite",currentUser.item.userId]];
        if ([[[result objectForKey:@"data"] objectForKey:@"list"] count] >=1) {
            //有数据
            NSArray *tempArray = [NSArray arrayWithArray:result[@"data"][@"list"]];
            for (int i = 0 ; i< tempArray.count; i++) {
                NSDictionary *tempD = [tempArray objectAtIndex:i];
                if ([tempD[@"deletedTime"] compare:[NSNumber numberWithInt:1]] ==  NSOrderedDescending) {
                    [operationDB delegateObjectFromeTable:tempD[@"_id"] fromeTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,[User defaultUser].item.userId]];
                }else{
                    //判断数据库有数据就更新 没有就添加
                    OrderModel *model = [[OrderModel alloc]initWithDictionary:tempD];
                    if ([operationDB theTableIsHavetheData:model._id fromeTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,[User defaultUser].item.userId]]) {
                        [operationDB upDataObjectInfo:model fromTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,[User defaultUser].item.userId]];
                    }else{
                        [operationDB insertObjectObject:model fromeTable:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,[User defaultUser].item.userId]];
                    }
                }
                if (i == tempArray.count-1) {
                    NSString *upDataTime = tempD[@"updateTime"];
                    if (upDataTime) {
                        // 存储拉取新的时间
                        [[NSUserDefaults standardUserDefaults] setObject:upDataTime forKey:[NSString stringWithFormat:@"%@%@",ORDERTABNAME,currentUser.item.userId]];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                    }
                }
            }
            
        }

    }
    
   
    TabBarView *jwtabView = (TabBarView *)[self.navigationController.tabBarController.tabBar viewWithTag:5];
    [orderInfoScrollView changeDataFromArray:nil];
    int pendingNumber = [orderInfoScrollView getDataCount:1];
    if (pendingNumber > 0) {
        pendingBtn.messageLabel.hidden = NO;
        pendingBtn.messageLabel.text = [NSString stringWithFormat:@"%d",pendingNumber];
        if (jwtabView) {
            jwtabView.secondItem.messageLabel.hidden = NO;
            jwtabView.secondItem.messageLabel.text = pendingBtn.messageLabel.text;
        }
    }else{
        pendingBtn.messageLabel.hidden = YES;
        if (jwtabView) {
            jwtabView.secondItem.messageLabel.hidden = YES;
        }
        
    }
    
}



#pragma mark ----------------------  选择待处理 和历史纪录

- (void)clickPendingBtnAndHistoryBtnAction:(id)sender
{
    
    pendingBtn.selected = NO;
    historyBtn.selected = NO;
    
    int index = 0;
    
    if (sender == historyBtn){
        index = 1;
        historyBtn.selected = YES;
        pointImg.left = SCREENWIDTH/4*3-47.5;
    }else{
        pendingBtn.selected = YES;
        pointImg.left = SCREENWIDTH/4-47.5;
    }
    
    [orderInfoScrollView scrollRectToVisible:CGRectMake(index*SCREENWIDTH, 0, SCREENWIDTH, orderInfoScrollView.height) animated:YES];
}

#pragma mark -----------------------  重置选择状态
- (void)resetJWButtonSelectedStatus:(NSInteger)sign
{
    pendingBtn.selected = NO;
    historyBtn.selected = NO;
    if (sign == 0) {
        pendingBtn.selected = YES;
        pointImg.left = SCREENWIDTH/4-47.5;
    }else{
        historyBtn.selected = YES;
        pointImg.left = SCREENWIDTH/4*3-47.5;
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == orderInfoScrollView) {
        if (scrollView.contentOffset.x == 0) {
            [self resetJWButtonSelectedStatus:0];
        }else if (scrollView.contentOffset.x == SCREENWIDTH){
            [self resetJWButtonSelectedStatus:1];
        }else{
            [self resetJWButtonSelectedStatus:2];
        }
    }
}

- (void)changeList
{
    [self requestFromServer];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView * object = [self.view viewWithTag:88];
    if (object) {
        [object removeFromSuperview];
    }
}


/* 登记预约之后直接跳到历史
 **/
- (void)addOrderCompleteScrollToHistory
{
    [self clickPendingBtnAndHistoryBtnAction:historyBtn];
}

/**回到待确认
 */
- (void)backToPindingList
{
    [self clickPendingBtnAndHistoryBtnAction:pendingBtn];
}

- (void)dealloc
{
    if (self) {
        if (self.view) {
            if (self.view.subviews) {
                [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            }
        }
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
