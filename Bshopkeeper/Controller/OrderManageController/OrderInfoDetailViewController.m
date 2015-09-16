//
//  OrderInfoDetailViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "OrderInfoDetailViewController.h"
#import "OrderModel.h"
#import "CommodityModel.h"
#import "UIImageView+WebCache.h"
#import "EditOrAddOrderViewController.h"
#import "CustomerModel.h"
#import "OrderManageCenterViewController.h"
#import "ProductAndCommodityMoreListView.h"
#import "JWEditView.h"
#import "OrderProgressView.h"
#import "TJWCustomPickerView.h"


@interface OrderInfoDetailViewController ()<UIActionSheetDelegate,UITextFieldDelegate>
{
    
    UIScrollView *backScroll;               //滑动的图
    
    UIButton *editTimeButton;               //编辑时间
    
    JWEditView *orderCreatedItem;           //下单时间
    JWEditView *orderTimeItem;              //完成时间
    JWEditView *orderStatusItem;            //完成状态 @预约状态
    JWEditView *orderNameItem;              //顾客名称
    JWEditView *orderPhoneItem;             //顾客电话
    JWEditView *orderRemarkItem;            //备注
    JWEditView *orderdeportItem;            //定金
    
    OrderProgressView *currentProgress;     //当前状态
    
}
@property (nonatomic, strong) OrderModel *model;
@end

@implementation OrderInfoDetailViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _model = query[@"item"];
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消费详情";
    
    [self initWithSubViews];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(editOrderSucessAction:) name:kEditOrderSucessNotice object:nil];
    
    [self loadData];
}

-(void)rightNavigationBarAction:(UIButton *)sender
{
    //1:用户点取消;2:商家点取消;4:等用户确认;7:等用商家确认;10:已确认11:商家强行确认 14 已拒绝;20:已完成

    if (_model.recycle== 1) {
        //恢复预约
        [self restoreTheBooking];
        return;
    }
    
    int orderStatusCode = [_model.orderStatus intValue];
    
    
    if ( orderStatusCode == 7 || orderStatusCode == 10 || orderStatusCode == 11 ||orderStatusCode == 2 || orderStatusCode == 14 ||orderStatusCode == 20 || orderStatusCode == 1) {
        
        ProductAndCommodityMoreListView *object = (ProductAndCommodityMoreListView *)[self.view viewWithTag:88];
        if (object) {
            [object disMiss];
            return;
        }
        ProductAndCommodityMoreListView *moreAction = [[ProductAndCommodityMoreListView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64) controller:self model:_model];
        [moreAction show];
            
    }else{
        [self pushToEditOrder];
    }
    
   
    
}


#pragma mark -------------------------------- 选择操作

- (void)clickoperationAction:(id)sender
{
    int sendSign = 1;

    if ([sender isKindOfClass:[NSNumber class]]) {
        sendSign = [sender intValue];
    }
    
    int needToStatus;
    //1:用户点取消;2:商家点取消;4:等用户确认;7:等用商家确认;10:已确认11:商家强行确认 14 已拒绝;20:已完成
    NSInteger orderStatusCode = [_model.orderStatus integerValue];

    
    if (orderStatusCode == 10 || orderStatusCode == 11) {
        if (sendSign == 1) {
            //编辑
            [self pushToEditOrder];
            return;
        }else if (sendSign == 0){
           //完成消费
            needToStatus = 20;

        }else if (sendSign == 2){
            //取消预约
            needToStatus = 2;
        }
        
    }else if (orderStatusCode == 7){
        if (sendSign == 0) {
            //接受
            needToStatus = 10;
        }else if (sendSign == 1){
            //编辑
            [self pushToEditOrder];
            return;
        }else if (sendSign == 2){
            //拒绝
            needToStatus = 14;
        }
    }else{
        if (sendSign == 0) {
            //编辑
            [self pushToEditOrder];
            return;
            
        }else if (sendSign == 1){
            //删除预约
            [self clickDeleteOrderAction];
            return;
        }

    }
    [self changeTheOrderStatus:needToStatus withMoney:nil];
    
}

#pragma mark --------------------------- 推入编辑
- (void)pushToEditOrder
{
    //编辑
    EditOrAddOrderViewController *editOrder = [[EditOrAddOrderViewController alloc]initWithQuery:@{@"isAdd":@(NO),@"item":_model}];
    [self.navigationController pushViewController:editOrder animated:YES];
}

#pragma mark ---------------------------- 改变订单状态
- (void)changeTheOrderStatus:(int)orderStatus withMoney:(NSString *)money
{
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setObject:@(orderStatus) forKey:@"orderStatus"];

    
    [parm setObject:_model._id forKey:@"_id"];
    
    [LoadingView show:@"请稍候..."];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[JWNetClient defaultJWNetClient]postNetClient:@"Order/info" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (self == NULL)return ;
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {
                    OrderManageCenterViewController *orderList = (OrderManageCenterViewController *)controller;
                    [orderList changeList];
                    [orderList addOrderCompleteScrollToHistory];
                    [self backAction];
                    return ;
                }
            }
            
        }
    }];

}

- (void)initWithSubViews
{
    backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    backScroll.scrollEnabled = YES;
    backScroll.backgroundColor = VIEWBACKGROUNDCOLOR;
    backScroll.showsHorizontalScrollIndicator = NO;
    backScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backScroll];
    
    //服务时间
    orderTimeItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) withTitleLabel:@"服务时间" type:JWEditLable detailImgName:nil];
    orderTimeItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    [backScroll addSubview:orderTimeItem];
    
    //下单时间
    orderCreatedItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, orderTimeItem.bottom+10, SCREENWIDTH, 44) withTitleLabel:@"下单时间" type:JWEditLable detailImgName:nil];
    orderCreatedItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    [backScroll addSubview:orderCreatedItem];
    
    //定金
    orderdeportItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, orderTimeItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"定金" type:JWEditLable detailImgName:nil];
    orderdeportItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    [backScroll addSubview:orderdeportItem];

    
    //预约状态
    orderStatusItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, orderdeportItem.bottom, SCREENWIDTH, 88) withTitleLabel:@"预约状态" type:JWEditLable detailImgName:nil];
    orderStatusItem.titleLabel.height = 44;
    orderStatusItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    orderStatusItem.detailLabel.height = 44;
    [backScroll addSubview:orderStatusItem];
    
    currentProgress = [[OrderProgressView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 43)];
    [orderStatusItem addSubview:currentProgress];
    
    
    //顾客名称
    orderNameItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, orderStatusItem.bottom+10, SCREENWIDTH, 44) withTitleLabel:@"顾客姓名" type:JWEditLable detailImgName:nil];
    orderNameItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    [backScroll addSubview:orderNameItem];
    
    //顾客电话
    orderPhoneItem  = [[JWEditView alloc]initWithFrame:CGRectMake(0, orderNameItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"顾客电话" type:JWEditLable detailImgName:nil];
    orderPhoneItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    [backScroll addSubview:orderPhoneItem];
    
    UIButton *telBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 2, 40, 40)];
    [telBtn setImage:[UIImage imageNamed:@"icon_customer_tel.png"] forState:UIControlStateNormal];
    telBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [telBtn addTarget:self action:@selector(telAction:) forControlEvents:UIControlEventTouchUpInside];
    [orderPhoneItem addSubview:telBtn];
    
    //备注
    orderRemarkItem = [[JWEditView alloc]initWithFrame:CGRectMake(0, orderPhoneItem.bottom, SCREENWIDTH, 44) withTitleLabel:@"备注" type:JWEditLable detailImgName:nil];
    orderRemarkItem.detailLabel.textAlignment = NSTextAlignmentLeft;
    [backScroll addSubview:orderRemarkItem];
        
    backScroll.contentSize = CGSizeMake(SCREENWIDTH,orderRemarkItem.bottom);
}

- (void)loadData
{
    if (_model) {
        

        orderNameItem.detailLabel.text = _model.resultname;
        orderPhoneItem.detailLabel.text = _model.resultphone;

        if (_model.deposit) {
            orderdeportItem.detailLabel.text = [NSString stringWithFormat:@"%d",_model.deposit];
        }else{
            orderdeportItem.detailLabel.text = @"0";
        }

        
        if ([NSObject nulldata:_model.remark ]) {
            orderRemarkItem.detailLabel.text = _model.remark;
            float resultHeigth = [UIUtils getSizeFromString:_model.remark font:16 conttentSize:CGSizeMake(orderRemarkItem.detailLabel.width, 100)].height;
            if (resultHeigth >26) {
                [orderRemarkItem setDetailLabelHeight:resultHeigth +16];
            }
        }
        
        if ([_model.orderTime doubleValue] >0) {
            NSTimeInterval time = [_model.orderTime doubleValue];
            orderTimeItem.detailLabel.text = [UIUtils intoYYYYMMDDHHmmFrom:time/1000];
        }
        
        
        if ([_model.createdTime doubleValue]>0) {
            NSTimeInterval time = [_model.createdTime doubleValue];
            orderCreatedItem.detailLabel.text = [UIUtils intoYYYYMMDDHHmmFrom:time/1000];
        }
        //1:用户点取消;2:商家点取消;4:等用户确认;7:等用商家确认 8 要约;10:已确认11:商家强行确认 14 已拒绝;20:已完成
        if (_model.orderStatus) {
            int statusCode = [_model.orderStatus intValue];
            orderStatusItem.detailLabel.text = [UIUtils findOrderStatusFromCode:statusCode withTime:_model.orderTime];
            BOOL isTimeOut = NO;
            if ([orderStatusItem.detailLabel.text isEqualToString:@"已过期"]) {
                isTimeOut = YES;
            }
            
            if (statusCode == 7){
                //待处理
                [currentProgress setCurrentProgress:isTimeOut?4:1];
            }else if (statusCode == 10 || statusCode == 11){
                //待消费
                [currentProgress setCurrentProgress:isTimeOut?5:2];
            }else if (statusCode == 20 ){
                //已完成
                [currentProgress setCurrentProgress:3];
            }else if (statusCode == 14 ){
                //已拒绝
                [currentProgress setCurrentProgress:4];
            }else{
                [currentProgress setCurrentProgress:5];
            }
        }
    
    }
    backScroll.contentSize = CGSizeMake(SCREENWIDTH, orderRemarkItem.bottom);

    int orderStatusCode = [_model.orderStatus intValue];
    
    if (_model.recycle== 1) {
        
        [self setRightNavigationBarTitle:@"恢复" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
        return;
    }
    
    
    if (orderStatusCode == 4 || orderStatusCode == 7 || orderStatusCode == 10 || orderStatusCode == 11 ||orderStatusCode == 2 || orderStatusCode == 14 || orderStatusCode == 20) {
        UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [moreBtn setImage:[UIImage imageNamed:@"icon_moreList_white.png"] forState:UIControlStateNormal];
        moreBtn.backgroundColor = [UIColor clearColor];
        moreBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 0);
        [moreBtn addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *moreBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
        self.navigationItem.rightBarButtonItem = moreBarButtonItem;
    }else{
        
        [self setRightNavigationBarTitle:@"编辑" color:[UIColor whiteColor] fontSize:14 isBold:NO frame:CGRectMake(0, 0, 40, 40)];
    }


}

#pragma mark ------------------------------------------删除预约

- (void)clickDeleteOrderAction
{
    [LoadingView show:@"请稍后..."];
    self.view.userInteractionEnabled = NO;
    
    [[JWNetClient defaultJWNetClient]postNetClient:@"Order/info" requestParm:@{@"_id":_model._id,@"recycle":@1} result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (self == NULL) return;
        self.view.userInteractionEnabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"放入回收站成功"];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {
                    OrderManageCenterViewController *orderVC = (OrderManageCenterViewController *)controller;
                    [orderVC changeList];
                    [orderVC addOrderCompleteScrollToHistory];
                    [self.navigationController popToViewController:orderVC animated:YES];
                }
            }
            
        }
    }];

}
#pragma mark -------------------------------------- 恢复预约---------------------------------
- (void)restoreTheBooking
{
    [LoadingView show:@"请稍后..."];
    self.view.userInteractionEnabled = NO;
    
    [[JWNetClient defaultJWNetClient]postNetClient:@"Order/info" requestParm:@{@"_id":_model._id,@"recycle":@0} result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (self == NULL) return;
        self.view.userInteractionEnabled = YES;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"恢复成功"];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {
                    OrderManageCenterViewController *orderVC = (OrderManageCenterViewController *)controller;
                    [orderVC changeList];
                    [orderVC addOrderCompleteScrollToHistory];
                   
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }];

}



- (void)clickPhoneNumAction:(UIButton *)sender
{
    if (_model.customerInfoPhonenum) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.customerInfoPhonenum];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
  
}

#pragma mark ------------------------- tjwDatePicker Delegate
- (void)selectedContentAction:(NSString *)content time:(NSTimeInterval)tamp
{
    orderTimeItem.detailLabel.text = content;
    if (tamp) {
        [[JWNetClient defaultJWNetClient]postNetClient:@"Order/info" requestParm:@{@"_id":_model._id,@"orderTime":[NSNumber numberWithDouble:tamp*1000]} result:^(id responObject, NSString *errmsg) {
            if ([self WhetherInMemoryOfChild]) {
                if (!errmsg) {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[OrderManageCenterViewController class]]) {
                            OrderManageCenterViewController *orderVC = (OrderManageCenterViewController *)controller;
                            [orderVC changeList];
                        }

                    }
                }
            }
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 6 && ![string isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

#pragma mark -----------------------------------编辑预约成功的通知
- (void)editOrderSucessAction:(NSNotification *)notication
{
    OrderModel *tempModel = notication.object;
    if (tempModel) {
        _model = nil;
        _model = tempModel;
        [self loadData];
    }
}

#pragma mark ----------------------------------- 拨打电话
- (void)telAction:(id)sender
{
    if ([NSObject nulldata:orderPhoneItem.detailLabel.text ]) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",orderPhoneItem.detailLabel.text];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
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
