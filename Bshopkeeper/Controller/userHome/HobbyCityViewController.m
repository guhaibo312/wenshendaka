//
//  HobbyCityViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/18.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "HobbyCityViewController.h"
#import "StoreInfoSettingsViewController.h"
#import "SameCityListView.h"
#import "UIScrollView+JWRefresh.h"
#import "SameCitySearchViewController.h"
#import "SameCityViewController.h"
#import "JWLocationManager.h"

@interface HobbyCityViewController ()<UIAlertViewDelegate>
{
    SameCityListView *tattoolist;
    UIView *layerView;
    
}

@property (nonatomic,copy) NSString *statue;

@property (nonatomic,assign) bool needCreate;

@property (nonatomic, strong) SamecityHeadView *headView;
@end

@implementation HobbyCityViewController

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

- (SamecityHeadView *)headView
{
    if (!_headView) {
        SamecityHeadView *head = [[SamecityHeadView alloc]init];
        self.headView = head;
        self.headView.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    }
    return _headView;
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

- (void)rightNavigationBarAction:(UIButton *)sender
{
    SameCitySearchViewController *searchVC = [[SameCitySearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([User defaultUser].item.city && [User defaultUser].item.province) {
        tattoolist.hidden = NO;
    }else{
        tattoolist.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你还没有开通同城，马上去个人设置更新所在地！" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"现在设置", nil];
        alert.tag = 55;
        [alert show];

    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 55 && buttonIndex == 1) {
        StoreInfoSettingsViewController *pageVC = [[StoreInfoSettingsViewController alloc]init];
        [self.navigationController pushViewController:pageVC animated:YES];
        return;
    }
}

@end
