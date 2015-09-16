//
//  JWChatDetailCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatDetailCell.h"
#import "Configurations.h"
#import "JWSquarePhotoViewController.h"
#import "OtherUserModel.h"
#import "JWChatDataManager.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

@implementation JWChatDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        headImageView.layer.cornerRadius = 22;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.clipsToBounds = YES;
        headImageView.layer.borderWidth = 2;
        headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.contentView addSubview:headImageView];
        
        createLabel = [UILabel labelWithFrame:CGRectZero fontSize:12 fontColor:[UIColor blackColor] text:@""];
        [self.contentView addSubview:createLabel];
                
        // 4、创建内容
        btnContent = [[JWChatContentButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnContent.titleLabel.font = [UIFont systemFontOfSize:14];
        btnContent.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:btnContent];
        [btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];

        
        indicatiorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.contentView addSubview:indicatiorView];

        _failButton = [JWSendFailButton buttonWithType:UIButtonTypeDetailDisclosure];
        _failButton.backgroundColor = [UIColor clearColor];
        _failButton.hidden = YES;
        [self.contentView addSubview:_failButton];

        
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _failButton.tag = tag;
}

- (void)setChatDetail:(JWChatMessageFrameModel *)item beforeItem:(JWChatMessageFrameModel *)beforeModel
{
    _dataItem = item;
   
      if (item) {
        
        _dataItem = item;
        
        __weak __typeof (self) weakSelf = self;
        
        if (_dataItem.messagestatus  == chatmessageStatusNormal) {
            
            _dataItem.completeBlock = NULL;
            _failButton.hidden = YES;
        }else{
            
            _failButton.hidden = YES;
            if (_dataItem.messagestatus == chatmessageStatusLoading) {
                [indicatiorView startAnimating];
            }
            _dataItem.completeBlock = ^(chatmessagestatus status){
                if (!weakSelf) return;
                [weakSelf changeSelfDataStatusAction:status];
            };
        }
          
        JWChatMessageModel *message = item.message;
        
        createLabel.frame = item.timeFrame;
        createLabel.textAlignment = NSTextAlignmentCenter;
          
      double  time = [[NSString stringWithFormat:@"%.f",[item.message.time doubleValue]/1000]doubleValue];
      createLabel.text = [NSString stringWithDate:[NSDate dateWithTimeIntervalSince1970:time]];

      createLabel.hidden = NO;

      if (beforeModel) {
          if ([beforeModel.message.time doubleValue]+120*1000 >=[item.message.time doubleValue]) {
              createLabel.hidden = YES;
          }
      }

        headImageView.frame = item.iconFrame;
        
        if (item.mySend) {
            if ([NSObject nulldata:[User defaultUser].item.avatar]) {
                [headImageView sd_setImageWithURL:[NSURL URLWithString:[User defaultUser].item.avatar]];
            }else{
                headImageView.image = [UIImage imageNamed:@"icon_userHead_default"];
            }
        }else{
            headImageView.image = [UIImage imageNamed:@"icon_userHead_default"];

            OtherUserModel * otherIdModel =  [[JWChatDataManager sharedManager].userInfoDict objectForKey:message.otherId];
            if (otherIdModel) {
                if ([NSObject nulldata:otherIdModel.avatar]) {
                    [headImageView sd_setImageWithURL:[NSURL URLWithString:otherIdModel.avatar]];
                }
            }
            
        }

        indicatiorView.frame = item.activitViewFrame;
        _failButton.frame = item.activitViewFrame;
        btnContent.voiceBackView.hidden = YES;
        btnContent.backImageView.hidden = YES;
        btnContent.imageTextLabel.hidden = YES;
       
        int type = message.type;
        if (type == 1) {
            [btnContent setTitle:message.text forState:UIControlStateNormal];
            btnContent.frame = item.textFrame;
            [btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else if (type == 2|| type == 5){
        
            btnContent.frame = item.photoImageFrame;
            btnContent.backImageView.hidden = NO;
            [btnContent.backImageView chatResetImage:item isMySend:item.mySend];
            
        }else if (type == 3 || type == 6){
            
            
        }else if (type == 4 ){
            
        }else{
            
        }

        
        UIImage *normal;
        if (item.mySend) {
            normal = [UIImage imageNamed:@"icon_chat_send_nor"];
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
            btnContent.isMyMessage = YES;
            [btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnContent.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 20);
        }else{
            normal = [UIImage imageNamed:@"icon_chat_recive_nor"];
            normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
            btnContent.isMyMessage = NO;
            [btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btnContent.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 15, 10);
        }
        [btnContent setBackgroundImage:normal forState:UIControlStateNormal];
        [btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
        

        
        self.contentView.backgroundColor = VIEWBACKGROUNDCOLOR;
        self.backgroundColor = VIEWBACKGROUNDCOLOR;
    }
}

- (void)changeSelfDataStatusAction:(chatmessagestatus)status
{
    if (status == chatmessageStatusNormal) {
        if (indicatiorView.isAnimating) {
            [indicatiorView stopAnimating];
        }
        _failButton.hidden = YES;
        
    }else if (status == chatmessageStatusLoading){
        if (indicatiorView.isAnimating) {
            [indicatiorView stopAnimating];
        }
        [indicatiorView startAnimating];
        _failButton.hidden = YES;
    }else {
        if (indicatiorView.isAnimating) {
            [indicatiorView stopAnimating];
        }
        _failButton.hidden = NO;
    }
    
}

- (void)prepareForReuse
{
    headImageView.image = nil;
    createLabel.text = nil;
    
    [btnContent setTitle:@"" forState:UIControlStateNormal];
}


- (void)btnContentClick{
    //play audio
//    if (self.messageFrame.message.type == UUMessageTypeVoice) {
//        if(!contentVoiceIsPlaying){
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
//            contentVoiceIsPlaying = YES;
//            audio = [UUAVAudioPlayer sharedInstance];
//            audio.delegate = self;
//            //        [audio playSongWithUrl:voiceURL];
//            [audio playSongWithData:songData];
//        }else{
//            [self UUAVAudioPlayerDidFinishPlay];
//        }
//    }
    //show the picture
    if (self.dataItem.message.type  == 1){
        
        [btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:btnContent.frame inView:btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
        
    }else if (self.dataItem.message.type == 2|| self.dataItem.message.type == 5){
        if (!_dataItem.message.images || _dataItem.message.images.count < 1) {
            return;
        }
        
        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *topVC = appRootVC;
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        JWSquarePhotoViewController *previewPhoto = [[JWSquarePhotoViewController alloc]initWithImgs:_dataItem.message.images withCurrentIndex:0];
        [topVC presentViewController:previewPhoto animated:YES completion:nil];

    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
