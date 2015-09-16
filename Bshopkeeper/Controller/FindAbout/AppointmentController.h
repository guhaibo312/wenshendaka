//
//  AppointmentController.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopInfoModel,CompanyInfoItem;

@interface AppointmentController : UITableViewController

@property (nonatomic,strong) ShopInfoModel *shopInfo;

@property (nonatomic,strong) CompanyInfoItem *companyInfo;

@property (nonatomic,assign) bool userEditable;

@end
