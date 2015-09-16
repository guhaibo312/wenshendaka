//
//  WaterFallHeader.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "WaterFallHeader.h"

@implementation WaterFallHeader

- (instancetype)initWithFrame:(CGRect)frame withSubView:(UIView *)aview
{
    self = [super initWithFrame:frame];
    if (self) {
        if (aview) {
            [self addSubview:aview];
        }
    }
    return self;
}
@end
