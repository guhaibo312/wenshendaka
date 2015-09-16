//
//  SameCityViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SameCityViewController.h"
#import "SameCityListView.h"
#import "JWTabItemButton.h"
#import "RealNameAuthenticationViewController.h"
#import "SameCitySearchViewController.h"
#import "CreateShopController.h"
#import "ShopFinishController.h"
#import "CitySelectedViewController.h"
#import "JWLocationManager.h"


@interface SameCityViewController ()<UIAlertViewDelegate>
{
    SameCityListView *tattoolist;
    UIView *layerView;
    
}

@property (nonatomic, strong) SamecityHeadView *headView;

@property (nonatomic, strong) UIButton *createdButton;

@property (nonatomic,copy) NSString *statue;

@property (nonatomic,assign) bool needCreate;

@end

@implementation SameCityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *cityName=[[JudgeMethods defaultJudgeMethods]getCurrentCityName];
    if (cityName) {
        self.title = cityName;
    }else{
        self.title = @"同城";
    }
    [self setRightNavigationBarBackGroundImgName:@"icon_search_img_white.png" frame:CGRectMake(0, 0, 40, 40)];
    [self layoutSubViews];

}


- (void)rightNavigationBarAction:(UIButton *)sender
{
    SameCitySearchViewController *searchVC = [[SameCitySearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)layoutSubViews
{
    
    tattoolist = [[SameCityListView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT-64) ownerController:self];
    [tattoolist setupRefresh];
    tattoolist.location = nil;
    [self.view addSubview:tattoolist];
    
    
    tattoolist.sectionView = self.headView;

    __weak __typeof (self)weakSelf = self;

    self.headView.sortBlock = ^(int index){
        if (weakSelf) {
            [weakSelf handlingTheClick:index];
        }
    };
    
    
}
#pragma mark --- 处理点击操作
- (void)handlingTheClick:(int)index
{
    if (index == 10) {
        if (layerView) return;
        layerView = [self getListView:self.headView.shopTattooButton type:1];
        [self.view addSubview:layerView];
        
    }else {
        if (layerView) return;
        layerView = [self getListView:self.headView.shopTattooButton type:2];
        [self.view addSubview:layerView];
    }

}

- (SamecityHeadView *)headView
{
    if (!_headView) {
        SamecityHeadView *head = [[SamecityHeadView alloc]init];
        self.headView = head;
        self.headView.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }
    return _headView;
}

#pragma mark ---- 申请认证
- (void)setTheAuthentication:(id)sender
{
    switch ([self.statue intValue]) {
        case -1:
            [self.navigationController pushViewController:[[CreateShopController alloc] init] animated:YES];
            break;
            
        case 0:
            [self.navigationController pushViewController:[[ShopFinishController alloc] init] animated:YES];
            break;
            
        case 2:
            [self reloadCreate];
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIButton *)createdButton
{
    if (!_createdButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = SEGMENTSELECT;
        [button setTitle:@"创建店铺" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIImageView *point = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH - 40, 12, 20, 20)];
        point.image = [UIImage imageNamed:@"icon_point_white_right.png"];
        [button addSubview:point];
        [button addTarget:self action:@selector(setTheAuthentication:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
        _createdButton = button;
    }
    return _createdButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    __weak __typeof (self)weakSelf = self;
    [[JWNetClient defaultJWNetClient] getNetClient:@"CompanyApplication/info" requestParm:nil result:^(id responObject, NSString *errmsg) {
        BOOL needCreate = YES;
        if (!self) return ;
        if (!errmsg) {
            NSString *statue = responObject[@"data"][@"status"];
            self.statue = statue;
            switch ([statue intValue]) {
                case -1://没有店铺
                    needCreate = YES;
                    break;
                    
                case  0://提交审核中
                    needCreate = YES;
                    break;
                    
                case  1://审核成功
                    needCreate = NO;
                    break;
                    
                case  2://审核拒绝
                    needCreate = YES;
                    break;
            }
        }
        if (weakSelf) {
            [weakSelf judgeNeedCreateShop:needCreate];
        }
        
    }];
    
}

- (void)judgeNeedCreateShop:(BOOL)need
{
    if (tattoolist) {
        if (need) {
            tattoolist.tableHeaderView = self.createdButton;
        }else{
            tattoolist.tableHeaderView = nil;
        }
        [tattoolist reloadData];
    }
  
}

- (void)dealloc{
    if (tattoolist) {
        tattoolist.delegate = nil;
        tattoolist.dataSource = nil;
        tattoolist = nil;
    }
    
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

/**
 * 获取弹出窗口
 */
- (UIView *)getListView:(UIView *)senderView type:(int)type
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    view.tag = type;
    view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OperationremoveFromSuperview)];
    [view addGestureRecognizer:tap];
    
    CGRect rect = [self.headView convertRect:senderView.frame fromView:senderView.superview.superview];
    
    float point_y = fabs(rect.origin.y) + fabs(rect.size.height);
   
    if (tattoolist.contentOffset.y >=44) {
        point_y = 44;
    }else if (tattoolist.contentOffset.y>0 && tattoolist.contentOffset.y <44){
        point_y = 88 - fabs(tattoolist.contentOffset.y);
    }
    
    
    float point_x = 0;
    if (type == 2) {
        point_x = SCREENWIDTH/2;
    }
    
    UIView *operationView = [[UIView alloc]initWithFrame:CGRectMake(point_x, point_y, SCREENWIDTH/2, 88)];
    operationView.backgroundColor = [UIColor whiteColor];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:operationView.bounds];
    operationView.layer.masksToBounds = NO;
    operationView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    operationView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    operationView.layer.shadowOpacity = 0.9f;
    operationView.layer.shadowPath = shadowPath.CGPath;
    operationView.tag = 5;
    [view addSubview:operationView];
    
    NSArray *titleArray = @[@"店铺",@"纹身师"];
    if (type == 2) {
        titleArray =@[@"人气",@"附近"];
    }
    for (int i = 0 ; i< 2; i++) {
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.frame = CGRectMake(0, i*44, operationView.width, 44);
        [clickButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [clickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        clickButton.titleLabel.font = [UIFont systemFontOfSize:16];
        clickButton.tag = i;
        [clickButton addTarget:self action:@selector(changeSameCityItemType:) forControlEvents:UIControlEventTouchUpInside];
        [operationView addSubview:clickButton];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = LINECOLOR;
    [operationView addSubview:lineView];

    return view;
}

- (void)OperationremoveFromSuperview
{
    if (layerView) {
        [layerView removeFromSuperview];
        layerView = nil;
    }
}

#pragma mark ---- 切换类型

- (void)changeSameCityItemType:(UIButton *)sender
{

    
    int type = layerView.tag;
    
    
    if (layerView) {
        [layerView removeFromSuperview];
        layerView = nil;
    }
    if (type ==  2) { //人气 附近
        if (!sender.tag) {
            if (tattoolist) {
                tattoolist.location = nil;
                [tattoolist headerRereshing];
            }
            self.headView.hotNearyButton.selected = NO;

            return;
        }else {
            if (tattoolist) {
                
                if ([User defaultUser].item.lon && [User defaultUser].item.lat) {
                    tattoolist.location = [NSString stringWithFormat:@"%f|%f",[User defaultUser].item.lon,[User defaultUser].item.lat];
                    [tattoolist headerRereshing];
                }else{
                    self.view.userInteractionEnabled = NO;
                    [LoadingView show:@"定位中..."];
                    __weak __typeof (self)weakSelf = self;
                    
                    JWLocationManager *sharedManger = [JWLocationManager shareManager];
                    sharedManger.cityBlock = NULL;
                    [sharedManger startLocation];
                    
                    sharedManger.mangerBlock = ^(CLLocation *location){
                        [LoadingView dismiss];
                        if (!weakSelf) return ;
                        weakSelf.view.userInteractionEnabled = YES;
                        if (location) {
                            [User defaultUser].item.lon = location.coordinate.longitude;
                            [User defaultUser].item.lat = location.coordinate.latitude;
                            tattoolist.location = [NSString stringWithFormat:@"%f|%f",[User defaultUser].item.lon,[User defaultUser].item.lat];
                            [tattoolist headerRereshing];
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"定位失败"];
                        }
                    };
                }
                
            }
            self.headView.hotNearyButton.selected = YES;

        }
        return;

    }else{ // 纹身 店铺
        if (sender.tag == 1 ) {
            if (tattoolist) {
                tattoolist.itemType = SameCityItemTypeTattoo;
                [tattoolist headerRereshing];
            }
            self.headView.shopTattooButton.selected = NO;
        }else{
            
            if (tattoolist) {
                tattoolist.itemType = SameCityItemTypeShop;
                [tattoolist headerRereshing];
            }
            self.headView.shopTattooButton.selected = YES;
            
        }
   
    }
    
  
}


@end

@implementation SamecityHeadView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        for (int i = 0 ; i< 2; i++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.frame = CGRectMake(i*SCREENWIDTH/2, 0, SCREENWIDTH/2, 44);
            [item setTitleColor:SEGMENTSELECT forState:UIControlStateNormal];
            [item setTitleColor:SEGMENTSELECT forState:UIControlStateHighlighted];
            [item setTitleColor:SEGMENTSELECT forState:UIControlStateSelected];
            item.backgroundColor = SEGMENTNORMAL;
            item.titleLabel.font = [UIFont systemFontOfSize:16];
            item.tag = i+10;
            [item addTarget:self action:@selector(clickJWTabItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i== 0) {
                [item setTitle:@"纹身师" forState:UIControlStateNormal];
                [item setTitle:@"店铺" forState:UIControlStateSelected];
                self.shopTattooButton = item;
            }else if (i== 1){
                
                [item setTitle:@"人气" forState:UIControlStateNormal];
                [item setTitle:@"附近" forState:UIControlStateSelected];
                self.hotNearyButton = item;
            }
            [self addSubview:item];

        }
        
        pointImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.shopTattooButton.width-20, 12, 20, 20)];
        pointImg1.image = [UIImage imageNamed:@"icon_same_point_down.png"];
        [self.shopTattooButton addSubview:pointImg1];
        
        pointImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.hotNearyButton.width-20, 12, 20, 20)];
        pointImg.image = [UIImage imageNamed:@"icon_same_point_down.png"];
        [self.hotNearyButton addSubview:pointImg];
    }
    return self;
}


#pragma mark ------- 点击筛选
- (void)clickJWTabItemButtonAction:(UIButton *)sender

{
    int tag = (int)sender.tag;
    if (self.sortBlock) {
        self.sortBlock (tag);
    }
}



@end
