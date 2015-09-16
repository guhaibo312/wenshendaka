//
//  SameCityListView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"
#import "UserHomeBtn.h"

@class CompanyInfoItem;


@interface SameCityListobject : NSObject

@property (nonatomic, strong) NSString*storeId;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSString *hot;
@property (nonatomic, strong) NSString *v;
@property (nonatomic, assign) NSInteger productNum;

- (instancetype)initWithDict:(NSMutableDictionary *)dict;

@end



typedef NS_ENUM(NSInteger, SameCityItemType) {
    SameCityItemTypeTattoo = 0, //default
    SameCityItemTypeShop =1     //店铺作品
    
};

@interface SameCityListView : UITableView

- (void)setupRefresh;

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)controller;

- (void)headerRereshing;

@property (nonatomic, strong) UIView *sectionView;      //分区的头部

@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, assign) SameCityItemType itemType;

@property (nonatomic, copy) NSString *location;

@end




@interface SameCityListCell : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *desLabel;
    UILabel *productLabel;
    
    TTTAttributedLabel *hotLabel;

    UIImageView *vSignView;
    UIImageView *headView;
}
@property (nonatomic, weak) SameCityListobject *dataSource;

- (void)refreshFrom:(SameCityListobject *)object;

@end




@interface SameCityStoreCell : UITableViewCell
{
    UIImageView *headView;
    UIImageView *homeImageView;
    UIImageView *locationImageView;
    
    UILabel *homeLabel;
    UILabel *locationLabel;
}

@property (nonatomic, weak) CompanyInfoItem *dataSource;

- (void)refreshFrom:(CompanyInfoItem *)object;

@end
