//
//  JWChatContentButton.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/27.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configurations.h"
#import "PhotoWallView.h"

@interface JWChatContentButton : UIButton


//图片
@property (nonatomic, retain) PhotoWallView *backImageView;

//audio
@property (nonatomic, retain) UIView *voiceBackView;

//单图多图的 标题
@property (nonatomic, retain) UILabel *imageTextLabel;

//声音
@property (nonatomic, retain) UILabel *second;

//声音图片
@property (nonatomic, retain) UIImageView *voice;

//风火轮
@property (nonatomic, retain) UIActivityIndicatorView *indicator;



@property (nonatomic, assign) BOOL isMyMessage;

- (void)benginLoadVoice;

- (void)didLoadVoice;

-(void)stopPlay;


@end
