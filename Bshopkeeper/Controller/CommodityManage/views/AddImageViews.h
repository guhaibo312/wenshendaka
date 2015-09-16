//
//  AddImageViews.h
//  Bshopkeeper
//
//  Created by jinwei on 15/3/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"
#import "BasViewController.h"


@protocol AddImageViewsDelegate <NSObject>

@optional
- (void) onImageViewFrameChaned;

@end

@interface AddImageViews : UIView

@property (nonatomic, strong) id<AddImageViewsDelegate> delegate;
@property (nonatomic, assign) UIViewController *supViewController;
@property (nonatomic, strong) NSMutableArray *imageViewList;
@property (nonatomic, strong) NSMutableArray *urlList;

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<AddImageViewsDelegate>)fromDelegate listArray:(NSArray *)listArray controller:(UIViewController *)supController;



@end
