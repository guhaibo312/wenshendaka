//
//  JWLocationManager.h
//  Bshopkeeper
//
//  Created by jinwei on 15/9/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef void(^locationMangerBlock)(CLLocation *location);

typedef void(^locationMangerCityBlock)(NSString *cityName,NSString *cityCode,NSString *provinceCode);

@interface JWLocationManager : NSObject

@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) NSString *currentCityName;

@property (nonatomic, strong) NSString *currentCityCode;

@property (nonatomic, strong) NSString *currentProvinceCode;


@property (nonatomic, copy) locationMangerBlock mangerBlock;

@property (nonatomic, copy) locationMangerCityBlock cityBlock;




+ (instancetype)shareManager;

- (void)startLocation;


@end
