//
//  OrderProgressView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/4/24.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderProgressView : UIView
{
    UIImageView *progressImg;
}

- (void)setCurrentProgress:(int)progress;

@end
