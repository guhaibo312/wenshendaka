//
//  Finelist.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWWaterLayout.h"
#import "JWCollectionViewCell.h"

@interface Finelist : NSObject
{
    JWWaterLayout *layout;
}

@property (nonatomic, strong) NSString *tagStr;

@property (nonatomic, assign) UIViewController *superVc;

@property (nonatomic, strong) NSString *UserPageId;

@property (nonatomic,strong) UIView * headView;

@property (nonatomic, strong) NSString *sector;

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)viewcontroller supView:(UIView *)supView;

@property (nonatomic, strong) UICollectionView *listCollection;


- (void)setupRefresh;

- (void)headerRereshing;

- (void)clearMemoryCache;

@end
