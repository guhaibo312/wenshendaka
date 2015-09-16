//
//  UserHomeHeadView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/3/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UserHomeHeadView.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"
#import "H5PreviewManageViewController.h"
#import "MobClick.h"
#import "UMSocialQQHandler.h"
#import "UserHomeBtn.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "SquareLikeButton.h"
#import "JWShareView.h"
#import "UserWxTypeView.h"


@interface UserHomeHeadView ()

{
    SquareLikeButton *likeBtn;      //赞
    SquareLikeButton *rankingButton;    //排名
    
    UIView *bottomView;
    UIImageView *headImageView;       //头像
    UILabel * titleLabel;             //名称
    UILabel *typeLabel;                 //微信
    UILabel *saleCountLabel;          //访问量
    
    UserWxTypeView *wxTypeView;
}
@end

@implementation UserHomeHeadView



- (instancetype)initWithOwnerViewController:(UIViewController *)controller
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/9*5+120)];
    if (self) {
        _superVc = controller;
        self.backgroundColor = VIEWBACKGROUNDCOLOR;
        
        _backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/9*5)];
        _backImgView.clipsToBounds = YES;
        _backImgView.contentMode = UIViewContentModeScaleAspectFill;
        _backImgView.image = [UIImage imageNamed:@"UserHome_default1_img.png"];
        [self addSubview:_backImgView];
        
        
        likeBtn = [[SquareLikeButton alloc]initWithFrame:CGRectMake(25, _backImgView.height/2-15, 80, 30) withTitle:@"赞 0" imageName:@"icon_mypage_like_black.png"];
        likeBtn.leftImgView.frame = CGRectMake(10, 5, 20, 20);
        likeBtn.backgroundColor = SEGMENTSELECT;
        likeBtn.clipsToBounds = YES;
        likeBtn.contentLabel.textColor= [UIColor blackColor];
        likeBtn.layer.cornerRadius = 15;
        [likeBtn addTarget:self action:@selector(clickLikeBtnFunction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:likeBtn];

        
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(42.5, likeBtn.bottom+15, 1, _backImgView.height-likeBtn.bottom-15)];
        topLineView.backgroundColor = SEGMENTSELECT;
        [self addSubview:topLineView];
        
        UIImageView *point = [[UIImageView alloc]initWithFrame:CGRectMake(43-14, likeBtn.bottom+1, 28, 28)];
        point.image = [UIImage imageNamed:@"icon_mypage_point.png"];
        [self addSubview:point];

        
        
        UIImageView *fuzzyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _backImgView.height- 175/(720/SCREENWIDTH), SCREENWIDTH, 175/(720/SCREENWIDTH))];
        fuzzyImageView.image = [UIImage imageNamed:@"icon_mypage_fuzzy.png"];
        [self addSubview:fuzzyImageView];
        
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _backImgView.bottom, SCREENWIDTH, 120)];
        bottomView.backgroundColor = NAVIGATIONCOLOR;
        [self addSubview:bottomView];
        

        
        //头像
        UIView *headBackView = [[UIView alloc]initWithFrame:CGRectMake(13.5, _backImgView.height-29.5, 59, 59)];
        headBackView.layer.cornerRadius = 29.5;
        headBackView.backgroundColor = RGBACOLOR(240., 178., 112, 0.6);
        headBackView.clipsToBounds = YES;
        [self addSubview:headBackView];
        
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.5, _backImgView.height-27.5, 55, 55)];
        headImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        headImageView.clipsToBounds = YES;
        headImageView.layer.cornerRadius= 27.5;
        headImageView.clipsToBounds = YES;
        [self addSubview:headImageView];
        
        //名称
        titleLabel = [UILabel labelWithFrame:CGRectMake(headImageView.right +15 ,_backImgView.height-25, SCREENWIDTH/5*3-30, 20) fontSize:14 fontColor:TAGBODLECOLOR text:@"我的店铺"];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        typeLabel = [UILabel labelWithFrame:CGRectMake(headImageView.right+15, 5, 200, 18) fontSize:12 fontColor:TAGBODLECOLOR text:@""];
        typeLabel.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:typeLabel];
       
        saleCountLabel = [UILabel labelWithFrame:CGRectMake(SCREENWIDTH/2, _backImgView.height-25, SCREENWIDTH/2-10, 20) fontSize:12 fontColor:[UIColor whiteColor] text:@""];
        saleCountLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:saleCountLabel];
        
        rankingButton= [[SquareLikeButton alloc]initWithFrame:CGRectMake(headImageView.right+15, 33, SCREENWIDTH-96, 22) withTitle:@"" imageName:@"icon_mypage_rangking.png"];
        rankingButton.leftImgView.frame = CGRectMake(0, 0, 14, 17);
        rankingButton.backgroundColor = [UIColor clearColor];
        rankingButton.contentLabel.left = 20;
        rankingButton.contentLabel.textAlignment = NSTextAlignmentLeft;
        rankingButton.contentLabel.textColor= TAGBODLECOLOR;
        [bottomView addSubview:rankingButton];
        
        UIView *headBottomLine = [[UIView alloc]initWithFrame:CGRectMake(42.5, 27.5, 1, 47.5)];
        headBottomLine.backgroundColor = TAGSCOLORFORE;
        [bottomView addSubview:headBottomLine];
        
        wxTypeView = [[UserWxTypeView alloc]initWithFrame:CGRectMake(0, rankingButton.bottom+20, SCREENWIDTH, 200) ownerController:_superVc];
        [wxTypeView resetLoad];
        [bottomView addSubview:wxTypeView];
        bottomView.height = wxTypeView.height+33+20+22+20;
        self.height = bottomView.bottom;
    }
    return self;
}

/**点赞
 */
- (void)clickLikeBtnFunction:(SquareLikeButton *)sender
{
   
    if (sender.selected) {
        sender.selected = NO;
        likeBtn.contentLabel.text = [NSString stringWithFormat:@"赞 %d",[[User defaultUser].storeItem.like integerValue]];

    }else{
        sender.selected = YES;
        likeBtn.contentLabel.text = [NSString stringWithFormat:@"已赞 %d",[[User defaultUser].storeItem.like integerValue]+1];
    }
    
}


/*复值
 */
- (void)changeAction
{
    
    
    saleCountLabel.text = [NSString stringWithFormat:@"访问量: %@",[User defaultUser].storeItem.visitCount];
    
    User *currentUser = [User defaultUser];
    titleLabel.text = currentUser.item.nickname;
    if (currentUser.item.avatar) {
        [headImageView sd_setImageWithURL:[NSURL URLWithString:currentUser.item.avatar] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
        
    }
      if ([NSObject nulldata:currentUser.storeItem.topBanner]) {
        [_backImgView sd_setImageWithURL:[NSURL URLWithString:[currentUser.storeItem.topBanner getQiNiuLargeImage]] placeholderImage:[UIImage imageNamed:@"UserHome_default2_img.png"]];
        
        
    }
    typeLabel.text = [NSString stringWithFormat:@"%@",[UIUtils findTypeFrom:@{@"sector":currentUser.item.sector?currentUser.item.sector:@"1"}]];
    [wxTypeView resetLoad];
    
    if ([NSObject nulldata:[User defaultUser].storeItem.hotRankCountry]) {
        rankingButton.contentLabel.text = [NSString stringWithFormat:@"排名: %@",[User defaultUser].storeItem.hotRankCountry];
    }
    
    bottomView.height = wxTypeView.height+33+20+22+20;
    self.height = bottomView.bottom;
    
    if (!likeBtn.selected) {
        likeBtn.contentLabel.text = [NSString stringWithFormat:@"赞 %d",[[User defaultUser].storeItem.like integerValue]];
    }else{
        likeBtn.contentLabel.text = [NSString stringWithFormat:@"已赞 %d",[[User defaultUser].storeItem.like integerValue]+1];
    }
}

/**获取头像
 */
- (UIImage *)getUserHeadImg
{
    return headImageView.image;
}

/*
 *设置头像点击功能
 **/

- (void)setHeadViewClickAction:(SEL)sel withTarget:(id)target
{
    UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    headImageView.userInteractionEnabled = YES;
    [headImageView addGestureRecognizer:tapHead];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
