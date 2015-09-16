//
//  JWCollectionViewCell.h
//  Tools
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"

@class JWCollectionItem;

@interface JWCollectionViewCell : UICollectionViewCell
{

    JWCollectionItem *ownerItem;
    UIImageView *headImg;
    UIImageView *vImageView;
    UILabel *nameLabel;
    
}
@property (nonatomic, strong) UIImageView *topImg;
- (void)setDataItem:(JWCollectionItem *)dataItem withColor:(UIColor *)color;

@end


@interface JWUserPageCollectionCell : UICollectionViewCell

{
    UILabel *countLabel;
    JWCollectionItem *ownerItem;
    
}

@property (nonatomic, strong) UIImageView *topImg;

- (void)setDataItem:(JWCollectionItem *)dataItem withColor:(UIColor *)color;

@end

@interface JWCollectionItem : NSObject

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSArray *image_urls;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *updated;

@property (nonatomic, assign) CGSize firstImgSize;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic , assign) CGSize squareListSize;

@property (nonatomic, assign) CGSize userPageSize;

@end
