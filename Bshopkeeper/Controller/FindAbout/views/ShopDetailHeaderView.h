//
//  ShopDetailHeaderView.h
//  Bshopkeeper
//
//  Created by 吴迪 on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyInfoItem,ShopInfoModel,ShopDetailHeaderView;

@protocol ShopDetailHeaderViewDelegate <NSObject>

- (void)shopDetailHeaderViewDidClick : (ShopDetailHeaderView *)shopDetailHeaderView companyId : (NSString *)companyId editable : (BOOL)editable;

- (void)shopDetailHeaderViewDidAppointment : (ShopDetailHeaderView *)shopDetailHeaderView companyInfo : (CompanyInfoItem *)companyInfo userEditable : (BOOL)userEditable;

- (void)shopDetailHeaderViewDidClickHeader : (ShopDetailHeaderView *)shopDetailHeaderView  headerIcon: (UIImageView *)headerIcon;

- (void)shopDetailHeaderViewDidClickBanner : (ShopDetailHeaderView *)shopDetailHeaderView  bannerScrollView: (UIView *)bannerScrollView;

@end

@interface ShopDetailHeaderView : UIView

+ (instancetype)shopDetailHeaderView;

@property (nonatomic,strong) CompanyInfoItem *companyInfo;

@property (nonatomic,strong) ShopInfoModel *shopInfo;

@property (nonatomic,weak) id<ShopDetailHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPageControl *pageCtroller;

@property (weak, nonatomic) IBOutlet UIScrollView *topBanner;

@end
