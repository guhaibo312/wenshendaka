//
//  CreateShopController.m
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/7.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "CreateShopController.h"
#import "Configurations.h"
#import "CitySelectedViewController.h"
#import "BaseNavigationViewController.h"
#import "ShopModel.h"
#import "BaiduMapController.h"

@interface CreateShopController ()

@property (weak, nonatomic) IBOutlet UIView *bjView;
@property (weak, nonatomic) IBOutlet UITextField *addressText;

@property (nonatomic,strong) CityObject *citySelectedObject;

@property (nonatomic,strong) ShopModel *shopModel;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *shopAdress;



@end

@implementation CreateShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"创建店铺";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    
    self.bjView.layer.cornerRadius = 8;
    self.bjView.layer.masksToBounds = YES;
    self.bjView.layer.borderWidth = 0.5;
    self.bjView.layer.borderColor = LINECOLOR.CGColor;
    
    self.shopModel = [[ShopModel alloc] init];
}

- (IBAction)addressClick:(id)sender {
    CitySelectedViewController *cityVc = [[CitySelectedViewController alloc] init];
    cityVc.block = ^(CityObject *selectedCity){
        if (selectedCity) {
            self.citySelectedObject = [[CityObject alloc]init];
            self.citySelectedObject = selectedCity;
            self.addressText.text = self.citySelectedObject.cityName;
            self.shopModel.citycode = self.citySelectedObject.cityCode;
            self.shopModel.cityname = self.citySelectedObject.cityName;
            self.shopModel.province = self.citySelectedObject.provinceCode;
            self.shopModel.area = self.citySelectedObject.areaCode;
        }
    };
    [self presentViewController:[[BaseNavigationViewController alloc] initWithRootViewController:cityVc] animated:YES completion:NULL];
}

- (void)next
{
    if (self.citySelectedObject.cityCode.length > 0 && self.name.text.length > 0 && self.shopAdress.text.length > 0) {
        self.shopModel.name = self.name.text;
        self.shopModel.address = self.shopAdress.text;
        BaiduMapController *baiduMap = [[BaiduMapController alloc] init];
        baiduMap.shopModel = self.shopModel;
        [self.navigationController pushViewController:baiduMap animated:YES];
    }
}

@end
