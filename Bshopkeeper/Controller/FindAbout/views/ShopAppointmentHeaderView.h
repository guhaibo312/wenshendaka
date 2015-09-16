//
//  ShopAppointmentHeaderView.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopAppointmentHeaderView;

@protocol ShopAppointmentHeaderViewDelegate <NSObject>

- (void)shopAppointmentHeaderViewDidClick : (ShopAppointmentHeaderView *)shopAppointmentHeaderView;

@end

@interface ShopAppointmentHeaderView : UIView

+ (instancetype)shopAppointmentHeaderView;

@property (nonatomic,weak) id<ShopAppointmentHeaderViewDelegate> delegate;

@end
