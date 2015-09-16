//
//  ProductCollectionObject.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ProductModel.h"

typedef NS_ENUM(NSInteger, productManageType) {
    productManageNormal = 0, //default
    productManageShop =1            //店铺作品
    
};

@interface ProductCollectionObject : NSObject

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)vc;

@property (nonatomic,strong) UIView * headView;

@property (nonatomic, assign) UIViewController *supController;

@property (nonatomic, strong) UICollectionView *productCollection;

@property (nonatomic, assign) productManageType productType;

@property (nonatomic, strong) NSString *companyId;

@property (nonatomic, assign) BOOL canEdit;

/** 获取数据
 *
 */
- (void)setupRefreshProduct;

/** 获取商户作品列表
 */
- (void)getShopListProduct:(NSString *)companyId;


@end

@interface ProductCollectionCell : UICollectionViewCell
{
    UIImageView *bigImageView;
    UILabel *productTitleLabel;
    UILabel *countLabel;
}

@property (nonatomic, assign) id dataModel;

- (void)setvalueFrom:(id)sourcemodel withColor:(UIColor *)color;

- (void)settextColor:(UIColor *)color backColor:(UIColor *)bColor;

@end

