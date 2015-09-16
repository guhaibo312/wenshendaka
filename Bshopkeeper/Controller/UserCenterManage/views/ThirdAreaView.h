//
//  ThirdAreaView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/31.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityObject;

typedef void(^operationThirdViewBlock)(CityObject *object,BOOL goBack);

@interface ThirdAreaView : UIView

- (instancetype)initWithFrame:(CGRect)frame cityObject:(CityObject *)currentCityObject;

@property (nonatomic, copy) operationThirdViewBlock completeBlock;

@end
