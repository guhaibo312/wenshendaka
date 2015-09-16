//
//  CitySelectedViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BasViewController.h"
#import <CoreLocation/CoreLocation.h>

@class UserHomeBtn;
@class CityObject;

typedef void(^citySelectedBlock)(CityObject *selectedCity);



@interface CitySelectedViewController : BasViewController

@property (nonatomic, copy)citySelectedBlock block;

@end

@interface CityObject : NSObject

@property (nonatomic,strong) NSString *cityCode;

@property (nonatomic, strong) NSString *provinceCode;

@property (nonatomic, strong) NSString *areaCode;

@property (nonatomic, strong) NSString *areaName;

@property (nonatomic, strong) NSString *cityName;

@end

@interface CurrentLocationCity : UIView

@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *provinceCode;
@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) UserHomeBtn *failseButton;
@property (nonatomic, strong) UILabel *cityNameLabel;
@property (nonatomic, strong) UIActivityIndicatorView *actionvityView;


- (void)startLocation;


@end