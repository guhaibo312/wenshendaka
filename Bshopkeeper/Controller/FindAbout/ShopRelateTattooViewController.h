//
//  ShopRelateTattooViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/9/8.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BasViewController.h"

typedef void(^completeSelectedTattoo)(NSArray *array);

@interface ShopRelateTattooViewController : BasViewController

@property (nonatomic, copy) completeSelectedTattoo selectedBlock;

@end



@interface RelateTattooCell : UITableViewCell
{
    UIImageView *headImage;
    UILabel *nameLabel;
}


@property (nonatomic, strong) UIButton *relateButton;

- (void)reloadData:(NSDictionary *)dict;

@end