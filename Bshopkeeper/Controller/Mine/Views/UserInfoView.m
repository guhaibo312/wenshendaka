//
//  UserInfoView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/10.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UserInfoView.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"

@implementation UserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //头像
        headImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 66, 66)];
        headImg.layer.backgroundColor = VIEWBACKGROUNDCOLOR.CGColor;
        headImg.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        headImg.layer.cornerRadius = 33;
        headImg.layer.borderWidth = 0.5;
        headImg.layer.borderColor = LINECOLOR.CGColor;
        headImg.clipsToBounds = YES;
        [self addSubview:headImg];
        
        //名称
        nameLabel = [UILabel labelWithFrame:CGRectMake(headImg.right +10 , self.height/2-30, 80, 30) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLabel];
        
        vimageview = [[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.right, self.height/2-15-8, 18, 16)];
        vimageview.image = [UIImage imageNamed:@"icon_mine_v.png"];
        [self addSubview:vimageview];
        
        autImageView = [[UIImageView alloc]initWithFrame:CGRectMake(vimageview.right+5, self.height/2-15-11, 22, 22)];
        autImageView.image = [UIImage imageNamed:@"icon_mine_aut_pass.png"];
        [self addSubview:autImageView];
        
        wxLabel = [UILabel labelWithFrame:CGRectMake(headImg.right +10, nameLabel.bottom, 200, 30) fontSize:12 fontColor:[UIColor blackColor] text:@""];
        wxLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:wxLabel];

        UIImageView *qrImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-75, self.height/2-15, 30, 30)];
        qrImg.userInteractionEnabled = NO;
        qrImg.image = [UIImage imageNamed:@"icon_qr_default.png"];
        [self addSubview:qrImg];

        UIImageView *point1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-25,self.height/2-5, 6, 10)];
        point1.image = [UIImage imageNamed:@"icon_right_img.png"];
        [self addSubview:point1];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

- (void)reloadData
{
    User *currentUser = [User defaultUser];
    nameLabel.text = currentUser.item.nickname;
    if (currentUser.item.avatar) {
        [headImg sd_setImageWithURL:[NSURL URLWithString:currentUser.item.avatar] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
        headImg.layer.borderWidth = 0;
    }else{
        headImg.layer.borderWidth = 0.5;
        headImg.layer.borderColor = LINECOLOR.CGColor;
    }
    if (currentUser.item.wxNum) {
        wxLabel.text = [NSString stringWithFormat:@"微信号:%@",currentUser.item.wxNum];
    }

    
    vimageview.hidden = YES;
    autImageView.hidden = YES;
    if (currentUser.item.v) {
        if ([currentUser.item.v boolValue]) {
            vimageview.hidden = NO;
            autImageView.hidden = NO;
        }
    }

}
@end
