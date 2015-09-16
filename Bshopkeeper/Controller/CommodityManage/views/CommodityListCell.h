//
//  CommodityListCell.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"
#import "CommodityModel.h"
#import "UserHomeBtn.h"

@interface CommodityListCell : UITableViewCell
{
    UILabel  *nameLabel ;                 //商品名称
    UILabel  *creatTimeLabel;             //创作时间
    UILabel  *moneyLabel;                 //商品价格
//    UILabel  *topLabel;                   //推荐
    UILabel  *saleCountLabel;             //预约量
    
    UserHomeBtn *previewBtn;              //预览
    UserHomeBtn *editBtn;                 //编辑
    UserHomeBtn *sharedBtn;               //分享
    UIView *bottomView;
    
    
}
@property (nonatomic, strong)  UIImageView *headImageView;           //商品的图片

/*
 *初始化 携带controller
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withcontroller:(BasViewController<JWSharedManagerDelegate> *)controller;

/*
 * 更新数据操作
 */
- (void)changeContentFrom:(CommodityModel *)comModel;

@end
