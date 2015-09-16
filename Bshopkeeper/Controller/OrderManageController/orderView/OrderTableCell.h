//
//  OrderTableCell.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/23.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"
#import "OrderModel.h"
#import "UIImageView+WebCache.h"

@interface OrderTableCell : UITableViewCell
{
    UILabel *nameLabel;                     //预约姓名
//    UILabel *serviceTypeLabel;              //预约类型 到店10 上门20
    UILabel *orderTimeLabel;                //预约时间
    UILabel *statusLabel;                   //状态的label;

    UIImageView *headImageView;             //预约内容的图片
    UIImageView *point1;                    
}

- (void)changContentFrom:(OrderModel *)orderModel;

@end
