//
//  SameCityViewController.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/13.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "BasViewController.h"




typedef void(^selectedSort)(int index);

@interface SamecityHeadView : UIView

{
    UIImageView *pointImg;
    UIImageView *pointImg1;
}

@property (nonatomic, strong) UIButton *shopTattooButton;        //店铺 or纹身师

@property (nonatomic, strong) UIButton *hotNearyButton;               // 人气

@property (nonatomic, copy) selectedSort sortBlock;

@end


@interface SameCityViewController : BasViewController

@end
