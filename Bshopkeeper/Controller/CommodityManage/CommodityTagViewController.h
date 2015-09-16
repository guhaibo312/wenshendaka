//
//  CommodityTagViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BasViewController.h"


@protocol SelectedCommodityDelegate <NSObject>

- (void)theLabelIsCompleteFromArray:(NSArray *)selectedArray;
@end

@interface CommodityTagViewController : BasViewController

@property (nonatomic, assign) int tagCount;

@property (nonatomic, assign)id<SelectedCommodityDelegate>chooseTagDelegate;

@end
