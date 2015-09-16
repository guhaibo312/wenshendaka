//
//  JWLocationManager.m
//  Bshopkeeper
//
//  Created by jinwei on 15/9/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "Configurations.h"


@interface JWLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation JWLocationManager

+ (instancetype)shareManager
{
    static JWLocationManager *manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JWLocationManager alloc]init];
    });
    return manager;
}

- (void)startLocation
{
    if (!self.locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization]; // 永久授权
            [self.locationManager requestWhenInUseAuthorization]; //使用中授权
        }
    }
    if (!self.geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    }
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1.0;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self == NULL) return;
    if (_mangerBlock) {
        _mangerBlock(nil);
    }
    if (_cityBlock) {
        _cityBlock (nil,nil, nil);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self) {
        [_locationManager stopUpdatingLocation];
        CLLocation *last = [locations lastObject];
        if (_mangerBlock) {
            _mangerBlock(last);
            _currentLocation = last;
        }
        [_geocoder reverseGeocodeLocation:last completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (placemarks.count>0) {
                CLPlacemark *result = [placemarks lastObject];
                NSString *name = result.locality;
                while ([name rangeOfString:@"市"].location != NSNotFound) {
                    name = [name substringToIndex:[name rangeOfString:@"市"].location];
                }
                if (name) {
                    _currentCityName = name;
                    NSArray *keyArray1 = [JudgeMethods defaultJudgeMethods].cityListDict.allKeys;
                    for (int i = 0 ; i< keyArray1.count; i++) {
                        NSString *key1 = [keyArray1 objectAtIndex:i];
                        NSDictionary *value1 = [[JudgeMethods defaultJudgeMethods].cityListDict objectForKey:key1];
                        NSArray *keyArray2 = [value1 allKeys];
                        for (int j = 0; j< keyArray2.count; j++) {
                            NSString *key2 = [keyArray2 objectAtIndex:j];
                            NSString *value2 = [value1 objectForKey:key2];
                            if ([value2 rangeOfString:name].location != NSNotFound) {
                                _currentCityCode = key2;
                                _currentProvinceCode = key1;
                                if (_cityBlock) {
                                    _cityBlock(name,key2,key1);
                                }
                                return;
                            }
                        }
                    }
    
                }
            }
            _cityBlock (nil,nil, nil);
            
        }];
    }
}


- (void)dealloc
{
    _locationManager.delegate = nil;
}


@end
