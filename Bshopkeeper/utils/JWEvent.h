//
//  JWEvent.h
//  Bshopkeeper
//
//  Created by jinwei on 15/7/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWEvent : NSObject

+ (instancetype)defaultJWEvent;

@property (nonatomic, assign) int hobbyCircleTimesOfOnce;

@property (nonatomic, assign) int hobbyGalleryTimesOfOnce;

@property (nonatomic, assign) int hobbyUrlTimesOfonce;

@property (nonatomic, assign) int tattooCircleTimesOfOnce;

@property (nonatomic, assign) int tattooGalleryTimesOfOnce;

@property (nonatomic, assign) int tattooUrlTimesOfonce;

@end
