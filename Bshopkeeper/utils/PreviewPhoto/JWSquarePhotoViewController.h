//
//  JWSquarePhotoViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/23.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BasViewController.h"

@interface JWSquarePhotoViewController : UIViewController

- (instancetype)initWithImgs:(NSArray *)list withCurrentIndex:(int)index;

@property (nonatomic, strong) UIButton *downLoadBtn;

@property (nonatomic, strong) NSMutableArray *imageUrls;

@property (nonatomic,strong) UILabel *pageLabel;


@end
