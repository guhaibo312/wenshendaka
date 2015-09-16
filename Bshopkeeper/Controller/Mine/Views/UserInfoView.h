//
//  UserInfoView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/7/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoView : UIView
{
    UIImageView *headImg;
    UILabel *nameLabel;
    UILabel *wxLabel;
    UIImageView *vimageview;
    UIImageView *autImageView;
}


- (void)reloadData;


@end
