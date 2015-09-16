//
//  JWWaterLayout.h
//  Tools
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const WaterFallSectionHeader;
extern NSString *const WaterFallSectionFooter;


@protocol JWWaterLayoutDelegate;

@interface JWWaterLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger columnCount;

@property (nonatomic, assign) CGFloat minimumColumnSpacing;

@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, assign) UIEdgeInsets sectionInset;

@end

@protocol JWWaterLayoutDelegate <UICollectionViewDelegate>

@required

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section;
@end