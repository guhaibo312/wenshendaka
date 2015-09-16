//
//  ShopAppointmentCell.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopAppointment,ShopInfoModel,ShopAppointmentCell;

@protocol ShopAppointmentCellDelegate <NSObject>

- (void)shopAppointmentCellDidClick : (ShopAppointmentCell *)shopAppointmentCell  button :(UIButton *)button userId : (NSString *)userId;

@end

typedef enum{
     MoreButtontTypeOwnerManager = 0,
     MoreButtontTypeOwnerOrdinary,
     MoreButtontTypeManagerMine,
     MoreButtontTypeOrdinary,

} MoreButtontType;

@interface ShopAppointmentCell : UITableViewCell

+ (instancetype)shopAppointmentCellWithTableView: (UITableView *)tableView;

@property (nonatomic,strong) ShopAppointment *shop;

@property (nonatomic,strong) ShopInfoModel *shopInfo;

@property (nonatomic,weak) id<ShopAppointmentCellDelegate> delegate;


@end
