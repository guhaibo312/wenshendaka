//
//  SquareUserPageHead.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/4.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SquareUserPageHead.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"
#import "H5PreviewManageViewController.h"
#import "QrCodeViewController.h"
#import "UIImage+ResizeImage.h"
#import "UserHomeBtn.h"
#import "FocusListViewController.h"

@interface SquareUserPageHead ()
{
    UIImageView *_headImg;          //头像
    UIImageView *topImg;
    NSString *currentUserPageId;      //当前用户的ID
    BOOL isShowSquare;                //是否在广场中显示
    int followercount;
    UserHomeBtn *funsButton;
    UserHomeBtn *focusButton;
    UserHomeBtn *addFoucusButton;
    
}
@property (nonatomic, weak) UIViewController *ownerController;
@property (nonatomic, weak) NSDictionary *dataSource;
@end

@implementation SquareUserPageHead

- (instancetype)initWithFrame:(CGRect)frame withOwnerController:(UIViewController *)controller
{
    self= [super initWithFrame:frame];
    if (self) {
        _ownerController = controller;
                
        topImg = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 0, SCREENWIDTH+20, 160)];
        topImg.backgroundColor = [UIColor whiteColor];
        topImg.contentMode = UIViewContentModeScaleAspectFill;
        topImg.clipsToBounds = YES;
        topImg.image = [UIImage imageNamed:@"UserHome_default1_img.png"];
        [self addSubview:topImg];
        
        ArcView *oneArcView = [[ArcView alloc]initWithFrame:CGRectMake(0, 104, SCREENWIDTH, 80) withColor:VIEWBACKGROUNDCOLOR];
        [self addSubview:oneArcView];

        
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-33, 91, 66, 66)];
        _headImg.backgroundColor = [UIColor clearColor];
        _headImg.clipsToBounds = YES;
        _headImg.layer.cornerRadius = 33;
        _headImg.layer.borderWidth= 2;
        _headImg.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_headImg];
        
        addFoucusButton = [[UserHomeBtn alloc]initWithFrame:CGRectMake(SCREENWIDTH/2-22, _headImg.bottom+10, 44, 44) text:@"关注" imageName:@"icon_user_addfocus.png"];
        addFoucusButton.desIamgeView.frame = CGRectMake(addFoucusButton.width/2-8, 5, 16, 16);
        addFoucusButton.nameLabel.font = [UIFont systemFontOfSize:14];
        [addFoucusButton setBackgroundImage:[UIUtils imageFromColor:SEGMENTSELECT] forState:UIControlStateNormal];
        [addFoucusButton setBackgroundImage:[UIUtils imageFromColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        
        addFoucusButton.nameLabel.frame = CGRectMake(2, addFoucusButton.height-25, addFoucusButton.width-4, 20);
        addFoucusButton.nameLabel.textColor = [UIColor whiteColor];
        addFoucusButton.clipsToBounds = YES;
        addFoucusButton.layer.cornerRadius = 22;
        [addFoucusButton addTarget:self action:@selector(addOrCancleAddFouchus:) forControlEvents:UIControlEventTouchUpInside];
        addFoucusButton.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:addFoucusButton];
        
        
        focusButton = [[UserHomeBtn alloc]initWithFrame:CGRectMake(20,_headImg.bottom+64, SCREENWIDTH/2-40, 24) text:@"关注 0" imageName:@"icon_user_focus.png"];
        focusButton.desIamgeView.frame = CGRectMake(0, 1, 22, 22);
        focusButton.nameLabel.frame = CGRectMake(30, 0, focusButton.width-30, 24);
        focusButton.nameLabel.textAlignment = NSTextAlignmentCenter;
        focusButton.nameLabel.textColor = GRAYTEXTCOLOR;
        focusButton.nameLabel.font = [UIFont systemFontOfSize:14];
        [focusButton addTarget:self action:@selector(pushToFocusListFuction:) forControlEvents:UIControlEventTouchUpInside];
        [focusButton setBackgroundImage:[UIUtils imageFromColor:VIEWBACKGROUNDCOLOR] forState:UIControlStateNormal];
        [self addSubview:focusButton];

        
        funsButton = [[UserHomeBtn alloc]initWithFrame:CGRectMake(SCREENWIDTH/2+20,_headImg.bottom+64, SCREENWIDTH/2-40, 24) text:@"粉丝 0" imageName:@"icon_usr_funs.png"];
        funsButton.desIamgeView.frame = CGRectMake(0, 1, 22, 22);
        funsButton.nameLabel.frame = CGRectMake(30, 0, funsButton.width-30, 24);
        funsButton.nameLabel.textAlignment = NSTextAlignmentCenter;
        funsButton.nameLabel.textColor = GRAYTEXTCOLOR;
        [funsButton setBackgroundImage:[UIUtils imageFromColor:VIEWBACKGROUNDCOLOR] forState:UIControlStateNormal];
        funsButton.nameLabel.font = [UIFont systemFontOfSize:14];
        [funsButton addTarget:self action:@selector(pushToFocusListFuction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:funsButton];
        
        self.backgroundColor  = VIEWBACKGROUNDCOLOR;
        
    }
    return self;
}

- (UIImage *)getShareHeadImage
{
    if (_headImg) {
        return _headImg.image;
    }
    return nil;
}

- (void)setDataFrom:(NSDictionary *)dict
{
    if (dict) {
        _dataSource = dict;
        if ([NSObject nulldata:dict[@"avatar"]]) {
            [topImg sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _headImg.image = image;
                if (image) {
                    topImg.image = [image drn_boxblurImageWithBlur:0.7];
                }
                
            }];
        }else{
            UIImage *defaultImg = [UIImage imageNamed:@"UserHome_default1_img.png"];
            topImg.image = [defaultImg drn_boxblurImageWithBlur:0.7];
            [_headImg setImage:[UIImage imageNamed:@"icon_userHead_default.png"]];

        }

        isShowSquare = [[dict objectForKey:@"showDetailsInSocial"] boolValue];
        currentUserPageId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        
        followercount = [[dict objectForKey:@"follower_count"] intValue];
        int followingcount = [[dict objectForKey:@"following_count"]intValue];
        focusButton.nameLabel.text = [NSString stringWithFormat:@"关注 %d",followingcount];
        funsButton.nameLabel.text = [NSString stringWithFormat:@"粉丝 %d",followercount];
        
        
        addFoucusButton.selected = NO;
        addFoucusButton.desIamgeView.hidden = NO;
        addFoucusButton.nameLabel.frame = CGRectMake(2, addFoucusButton.height-25, addFoucusButton.width-4, 20);
        addFoucusButton.nameLabel.textColor = [UIColor whiteColor];
        addFoucusButton.nameLabel.text = @"关注";
        
        if ([User defaultUser].followingDict) {
            if ([[User defaultUser].followingDict.allKeys containsObject:currentUserPageId]) {
                addFoucusButton.selected = YES;
                addFoucusButton.desIamgeView.hidden = YES;
                addFoucusButton.nameLabel.frame = CGRectMake(0, addFoucusButton.height/2-10, addFoucusButton.width, 20);
                addFoucusButton.nameLabel.text = @"已关注";
                addFoucusButton.nameLabel.textColor = [UIColor blackColor];
            }
        }
       
        if ([[NSString stringWithFormat:@"%@",[User defaultUser].item.userId ] isEqual:currentUserPageId]) {
            addFoucusButton.hidden = YES;
        }
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark ---- 添加取消关注

- (void)addOrCancleAddFouchus:(UserHomeBtn *)sender
{
    __weak typeof(addFoucusButton) focus = addFoucusButton;
    __weak typeof(funsButton)funs = funsButton;
    
    if (sender.selected == YES) {
        [[JWNetClient defaultJWNetClient]squarePost:@"/follows/cancelFollow" requestParm:@{@"follow_id":currentUserPageId} result:^(id responObject, NSString *errmsg) {
            if (responObject && !errmsg && focus) {
                focus.selected = NO;
                focus.desIamgeView.hidden = NO;
                focus.nameLabel.frame = CGRectMake(2, addFoucusButton.height-25, addFoucusButton.width-4, 20);
                focus.nameLabel.textColor = [UIColor whiteColor];
                focus.nameLabel.text = @"关注";
                if (funs) {
                    followercount--;
                    if (followercount <= 0) {
                        followercount = 0;
                    }
                    funs.nameLabel.text = [NSString stringWithFormat:@"粉丝 %d",followercount];
                }
                if ([User defaultUser].followingDict) {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[User defaultUser].followingDict.allKeys];
                    if ([tempArray containsObject:currentUserPageId]) {
                        [[User defaultUser].followingDict removeObjectForKey:currentUserPageId];
                    }
                }

            }
        }];
    }else{
        [[JWNetClient defaultJWNetClient]squarePost:@"/follows/follow" requestParm:@{@"follow_id":currentUserPageId} result:^(id responObject, NSString *errmsg) {
            if (responObject && !errmsg) {
                if (focus) {
                    focus.selected = YES;
                    focus.desIamgeView.hidden = YES;
                    focus.nameLabel.frame = CGRectMake(0, addFoucusButton.height/2-10, addFoucusButton.width, 20);
                    focus.nameLabel.text = @"已关注";
                    focus.nameLabel.textColor = GRAYTEXTCOLOR;
                    if (funs) {
                        followercount++;
                        funs.nameLabel.text = [NSString stringWithFormat:@"粉丝 %d",followercount];
                    }
                    if ([User defaultUser].followingDict) {
                        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[User defaultUser].followingDict.allKeys];
                        if (![tempArray containsObject:currentUserPageId]) {
                            [[User defaultUser].followingDict setObject:_dataSource?_dataSource:@{@"userId":currentUserPageId}forKey:currentUserPageId];
                        }
                    }
                    
                }
            }
        }];

    }
    
}


#pragma mark -- 跳转粉丝 关注 列表
- (void)pushToFocusListFuction:(UserHomeBtn *)sender
{
    NSDictionary *dict;
    if (sender == focusButton) {
        if ([[User defaultUser].item.userId isEqual:currentUserPageId]) {
            dict = @{@"urlhost":@"/follows/followings",@"isFocus":@(YES),@"userId":currentUserPageId};
        }else{
            dict = @{@"urlhost":@"/follows/followings/guest",@"isFocus":@(YES),@"userId":currentUserPageId};

        }
    }else{
        if ([[User defaultUser].item.userId isEqual:currentUserPageId]) {
            dict = @{@"urlhost":@"/follows/followers",@"isFocus":@(NO),@"userId":currentUserPageId};

        }else{
            dict = @{@"urlhost":@"/follows/followers/guest",@"isFocus":@(NO),@"userId":currentUserPageId};
        }
    }
    if (dict && _ownerController) {
        FocusListViewController *listVC = [[FocusListViewController alloc]initWithQuery:dict];
        [_ownerController.navigationController pushViewController:listVC animated:YES];
    }
}

//打开微名片
- (void)openCurrentUserPageWGW:(UIButton *)sender
{
        if (currentUserPageId) {
            NSString *url = API_SHAREURL_STORE(currentUserPageId);
            
            if (_ownerController) {
                H5PreviewManageViewController *h5VC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":url}];
                [_ownerController.navigationController pushViewController:h5VC animated:YES];
            }
        }
    
}


@end

