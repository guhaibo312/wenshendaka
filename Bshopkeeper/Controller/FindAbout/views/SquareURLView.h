//
//  SquareURLView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/7/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareURLView : UIButton
{
    UIImageView *leftHeadImageView;
    UILabel *contentLabel;
}

- (void)setImageValue:(NSString *)imgURL title:(NSString *)contentStr;

@end
