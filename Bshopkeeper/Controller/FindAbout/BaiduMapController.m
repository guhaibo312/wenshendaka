//
//  BaiduMapController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/7.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BaiduMapController.h"
#import "Configurations.h"
#import "ShopModel.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ShopMapTopView.h"
#import "ShopCardController.h"

#define ViewWidth self.view.width

#define ViewHeight self.view.height

@interface BaiduMapController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,strong) BMKMapView *mapView;

@property (nonatomic,strong) BMKGeoCodeSearchOption *positioningOption;

@property (nonatomic,strong) BMKGeoCodeSearch *search;

@property (nonatomic,strong) BMKPointAnnotation *resultAnnotation;

@property (nonatomic,weak) ShopMapTopView *mapTopView;

@end

@implementation BaiduMapController

- (BMKMapView *)mapView
{
    if (!_mapView) {
        BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
        mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
        [_mapView setShowMapScaleBar:NO];
        
        mapView.isSelectedAnnotationViewFront = YES;
        mapView.zoomLevel = 14;
        mapView.mapType =BMKMapTypeStandard; //标准地图
        self.mapView = mapView;
    }
    return _mapView;
}

- (BMKPointAnnotation *)resultAnnotation
{
    if (!_resultAnnotation) {
        self.resultAnnotation = [[BMKPointAnnotation alloc]init];
    }
    return _resultAnnotation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.mapView];
    
    [self setUpBarButton];
    
    [self setUpBaiduService];
    
    [self mapTopView];
    
}

- (ShopMapTopView *)mapTopView
{
    if (!_mapTopView) {
        ShopMapTopView *mapTopView = [ShopMapTopView shopMapTopView];
        mapTopView.shopModel = self.shopModel;
        mapTopView.x = 0;
        mapTopView.y = self.view.height - mapTopView.height - 64;
        [self.view insertSubview:mapTopView aboveSubview:self.mapView];
        self.mapTopView = mapTopView;
    }
    return _mapTopView;
}

- (void)setShopModel:(ShopModel *)shopModel
{
    _shopModel = shopModel;
}

- (void)setUpBaiduService
{
    self.search = [[BMKGeoCodeSearch alloc] init];
    self.search.delegate = self;
    
    self.positioningOption = [[BMKGeoCodeSearchOption alloc] init];
    self.positioningOption.city = self.shopModel.cityname;
    self.positioningOption.address = [NSString stringWithFormat:@"%@%@",self.positioningOption.city,self.shopModel.address];
    
    BOOL result = [self.search geoCode:self.positioningOption];
    HBLog(@"%d",result);
}

- (void)setUpBarButton
{
    self.title = @"确定位置";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.resultAnnotation.coordinate = self.mapView.centerCoordinate;
    [self.mapView addAnnotation:self.resultAnnotation];
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.mapView.centerCoordinate = result.location;
        if ([self.mapView.annotations count] > 0) {
            NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
            [self.mapView removeAnnotations:array];
            array = [NSArray arrayWithArray:self.mapView.overlays];
            [self.mapView removeOverlays:array];
        }
        self.resultAnnotation.coordinate = result.location;
        [self.mapView addAnnotation:self.resultAnnotation];
        [SVProgressHUD showSuccessWithStatus:@"成功"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"未找到对应的地址信息"];
    }

}

- (void)next
{
    self.shopModel.location = [NSString stringWithFormat:@"%f|%f",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude];
    ShopCardController *shopCardVc = [[ShopCardController alloc] init];
    shopCardVc.shopModel = self.shopModel;
    [self.navigationController pushViewController:shopCardVc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}

@end
