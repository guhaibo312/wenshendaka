//
//  JWSortButton.m
//  Bshopkeeper
//
//  Created by jinwei on 15/4/22.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWSortButton.h"
#import "Configurations.h"

@implementation JWSortButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title fontSize:(float)font
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 10, 10)];
        _nameLabel.font = [UIFont systemFontOfSize:font];
        _nameLabel.textColor = GRAYTEXTCOLOR;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = title;
        [_nameLabel sizeToFit];
        _nameLabel.center = CGPointMake(frame.size.width/2-10, frame.size.height/2);
        [self addSubview:_nameLabel];
        
        _upImg = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.right+15, self.height/2-2-12, 12, 12)];
        _upImg.image = [UIImage imageNamed:@"icon_mypage_uppoint_img.png"];
        
        _upImg.tintColor = [UIColor blueColor];
        [self addSubview:_upImg];
        
        _downImg = [[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.right+15, self.height/2+2, 12, 12)];
        _downImg.image = [UIImage imageNamed:@"icon_mypage_downpoint_img.png"];
        _downImg.tintColor = [UIColor blueColor];
        [self addSubview:_downImg];
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
 *设置显示方式
 * status 1 向上 0为向下 其他为默认
 */
- (void)setCurrentShowStatus:(int)status
{
    if (status == 1) {
        _nameLabel.textColor = TABSELECTEDCOLOR;
        _upImg.image = [[UIImage imageNamed:@"icon_mypage_uppoint_img.png"]imageWithTintColor:TABSELECTEDCOLOR];
        _downImg.image = [UIImage imageNamed:@"icon_mypage_downpoint_img.png"];

        
    }else if (status == 0){
        _nameLabel.textColor = TABSELECTEDCOLOR;
        _upImg.image = [UIImage imageNamed:@"icon_mypage_uppoint_img.png"];
        _downImg.image = [[UIImage imageNamed:@"icon_mypage_downpoint_img.png"] imageWithTintColor:TABSELECTEDCOLOR];

    }else{
        _nameLabel.textColor = GRAYTEXTCOLOR;
        _upImg.image = [UIImage imageNamed:@"icon_mypage_uppoint_img.png"];
        _downImg.image = [UIImage imageNamed:@"icon_mypage_downpoint_img.png"];

    }
    
}


@end
