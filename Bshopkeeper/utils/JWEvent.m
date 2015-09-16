//
//  JWEvent.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWEvent.h"

@implementation JWEvent

+(instancetype)defaultJWEvent
{
    static JWEvent *event;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        event = [[JWEvent alloc]init];
    });
    return event;
}


@end
