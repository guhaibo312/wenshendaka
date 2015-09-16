//
//  SquareURLView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/6.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SquareURLView.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"

@implementation SquareURLView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        leftHeadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 44, 44)];
        leftHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
        leftHeadImageView.clipsToBounds = YES;
        [self addSubview:leftHeadImageView];
        
        contentLabel = [UILabel labelWithFrame:CGRectMake(leftHeadImageView.right+10, 12, self.width-leftHeadImageView.right-10, 40) fontSize:14 fontColor:[UIColor blackColor] text:@""];
        contentLabel.numberOfLines = 2;
        contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contentLabel];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setImageValue:(NSString *)imgURL title:(NSString *)contentStr
{
    if ([NSObject nulldata:imgURL ]) {
        leftHeadImageView.hidden = NO;
        [leftHeadImageView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"icon_image_default.png"]];
        contentLabel.frame = CGRectMake(leftHeadImageView.right+10, 12, self.width-leftHeadImageView.right-10, 40);
        contentLabel.text = contentStr;
        
    }else{
        contentLabel.frame = CGRectMake(10, 12, self.width-20, 40);
        contentLabel.text = contentStr;
        leftHeadImageView.hidden = YES;
    }
}


@end
