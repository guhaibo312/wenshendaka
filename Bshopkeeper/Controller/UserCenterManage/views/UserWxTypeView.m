//
//  UserWxTypeView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/15.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "UserWxTypeView.h"
#import "Configurations.h"
#import "NSString+Extension.h"
#import "GoStoreSettingViewController.h"
#import "UserDescribeViewController.h"
#import "StoreInfoSettingsViewController.h"
#import "MobClick.h"

@interface UserWxTypeView ()
{
    UIImageView *wxImageView;
    UIImageView *locationImageView;
    
    DesBolderButton *desButton;
    DesBolderButton *wxbutton;
    DesBolderButton *locationButton;
    
    UIView *bottomLine;
}
@property (nonatomic, weak) UIViewController *supviewController;

@end

@implementation UserWxTypeView

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _supviewController = controller;
        wxImageView = [[UIImageView alloc]initWithFrame:CGRectMake(43-18, 0, 36, 36)];
        wxImageView.image = [UIImage imageNamed:@"icon_mypage_wx.png"];
        [self addSubview:wxImageView];
        
    
        wxbutton = [[DesBolderButton alloc]initWithFrame:CGRectMake(wxImageView.right +10, 0, self.width-wxImageView.right-20, 36)];
        [wxbutton addTarget:self action:@selector(pushToUserSettingController:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wxbutton];
        
        desButton = [[DesBolderButton alloc]initWithFrame:CGRectMake(wxImageView.right +10, wxImageView.bottom+20, self.width-wxImageView.right-20, 36)];
        [desButton addTarget:self action:@selector(pushToUserSettingController:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:desButton];
        
        locationButton = [[DesBolderButton alloc]initWithFrame:CGRectMake(wxImageView.right +10, desButton.bottom+20, self.width-wxImageView.right-20, 36)];
        [locationButton addTarget:self action:@selector(pushToUserSettingController:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:locationButton];

        bottomLine = [[UIView alloc]initWithFrame:CGRectMake(43-0.5, 36, 1, self.height - 72)];
        bottomLine.backgroundColor = TAGSCOLORFORE;
        [self addSubview:bottomLine];
    
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(43-3, wxImageView.bottom+10+15, 6, 6)];
        lineView.backgroundColor = TAGSCOLORFORE;
        lineView.layer.cornerRadius= 3;
        lineView.clipsToBounds = YES;
        [self addSubview:lineView];
        
        locationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(43-18, desButton.bottom+20, 36, 36)];
        locationImageView.image = [UIImage imageNamed:@"icon_mypage_location.png"];
        [self addSubview:locationImageView];
        
    }
    return self;
}


#pragma mark -- 跳到设置


- (void)pushToUserSettingController:(DesBolderButton *)sender
{
    if (!_supviewController)return;
    if (sender == wxbutton) {
        [MobClick event:@"30_click_micro_card_weixin"];
        StoreInfoSettingsViewController *sets = [[StoreInfoSettingsViewController alloc]initWithQuery:nil];
        [_supviewController.navigationController pushViewController:sets animated:YES];
    }else if (sender == desButton){
        [MobClick event:@"30_click_micro_card_desc"];

        UserDescribeViewController *desVC = [[UserDescribeViewController alloc ]init];
        [_supviewController.navigationController pushViewController:desVC animated:YES];

    }else{
        [MobClick event:@"30_click_micro_card_org"];

        GoStoreSettingViewController *gostoreVC = [[GoStoreSettingViewController alloc]init];
        [_supviewController.navigationController pushViewController:gostoreVC animated:YES];

    }
}
- (void)resetLoad
{
    [wxbutton setDesLabelText:[User defaultUser].item.wxNum type:1];
    [desButton setDesLabelText:[User defaultUser].item.faith type:2];
    if ([User defaultUser].item.company) {
        [locationButton setDesLabelText:[[User defaultUser].item.company objectForKey:@"name"] type:3];
    }else{
        [locationButton setDesLabelText:nil type:3];
    }
    desButton.top = wxbutton.bottom+20;
    locationButton.top = desButton.bottom+20;
    locationImageView.top = desButton.bottom+20;
    bottomLine.height = locationImageView.bottom-72;
    self.height = locationImageView.bottom;
}

@end
@implementation DesBolderButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = TAGSCOLORFORE.CGColor;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        
        _addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 18, 18)];
        _addImageView.image = [UIImage imageNamed:@"icon_mypage_desAdd.png"];
        [self addSubview:_addImageView];
        
        _desLabel = [UILabel labelWithFrame:CGRectMake(46, 0, self.width-46-10, 36) fontSize:12 text:@""];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        _desLabel.textColor =  TAGBODLECOLOR;
        _desLabel.numberOfLines = 0;
        
        [self addSubview:_desLabel];
        
        
    }
    return self;
}

- (void)setDesLabelText:(NSString *)string type:(int)whereType
{
    
    if ([NSObject nulldata:string]) {
        _addImageView.hidden = YES;
        _desLabel.text = string;

        self.height = 36;
        if (whereType == 1) {
            _desLabel.frame = CGRectMake(10, 0, self.width-20, 36);
            
        }else if (whereType == 2){

            float resultHeight = [string sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(self.width-20, 1000)].height;
            if (resultHeight < 16) {
                _desLabel.text = string;
                _desLabel.frame = CGRectMake(10, 0, self.width-20, 36);
                if (_desButton) {
                    [_desButton removeFromSuperview];
                    _desButton  = nil;
                }
            }else{
                if (resultHeight > 56) {
                    _desLabel.numberOfLines = 4;
                    _desLabel.frame =CGRectMake(10, 2, self.width-20, 58);
                    _desButton = [[UIButton alloc]initWithFrame:CGRectMake(0, _desLabel.bottom+5, 80, 20)];
                    [_desButton setTitle:@"查看全文" forState:UIControlStateNormal];
                    [_desButton setTitleColor:SquareLinkColor forState:UIControlStateNormal];
                    _desButton.titleLabel.font = [UIFont systemFontOfSize:12];
                    _desButton.layer.cornerRadius = 5;
                    _desButton.clipsToBounds = YES;
                    _desLabel.numberOfLines = 4;
                    [self addSubview:_desButton];
                    self.height = 58+20+10;
                }else{
                    _desLabel.numberOfLines = 0;
                    if (_desButton) {
                        [_desButton removeFromSuperview];
                        _desButton = nil;
                    }
                    _desLabel.frame =CGRectMake(10, 0, self.width-20, resultHeight+10);
                    self.height = resultHeight+10;
                }
               
            }

            
        }else{
            _desLabel.textColor = SEGMENTSELECT;
            _desLabel.frame = CGRectMake(10, 0, self.width-20-50, 36);
            _desButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width-55, 6, 50, 24)];
            _desButton.backgroundColor  = SMALLBUTTONCOLOR;
            [_desButton setTitle:@"查看" forState:UIControlStateNormal];
            [_desButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _desButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _desButton.layer.cornerRadius = 5;
            _desButton.clipsToBounds = YES;
            _desButton.enabled = NO;
            _desButton.userInteractionEnabled = NO;
            [self addSubview:_desButton];
        }
        
        
    }else{
        if (_desButton) {
            [_desButton removeFromSuperview];
        }
        _desButton = nil;
        _addImageView.hidden = NO;
        _desLabel.frame = CGRectMake(46, 0, self.width-46-10, 36);
        self.height = 36;
        if (whereType == 1) {
            _desLabel.text = @"微信号";
        }else if (whereType == 2){
            _desLabel.text = @"个人介绍";
        }else{
            _desLabel.text = @"从业机构";
        }
    }
}

@end
