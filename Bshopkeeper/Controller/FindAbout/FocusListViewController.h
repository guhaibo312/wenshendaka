//
//  FocusListViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/17.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//  关注列表


#import "BasViewController.h"
#import "UserHomeBtn.h"

@interface FocusListViewController : BasViewController

@end

@interface FocusItemCell : UITableViewCell
{
    UIImageView *headImageView;
    UILabel *nameLabel;
    UserHomeBtn *addFocusButton;
}

@property (nonatomic, weak) UIViewController *ownerController;
@property (nonatomic, weak) NSDictionary *dataItem;


- (void)refreshDataFrom:(NSDictionary *)dict ownerController:(UIViewController *)controller;


@end