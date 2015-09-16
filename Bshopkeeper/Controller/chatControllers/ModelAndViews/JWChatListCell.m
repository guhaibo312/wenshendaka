//
//  JWChatListCell.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "JWChatListCell.h"
#import "Configurations.h"
#import "JWChatMessageModel.h"
#import "NSString+Extension.h"
#import "JWChatDataManager.h"
#import "UIImageView+WebCache.h"
#import "OtherUserModel.h"

@interface JWChatListCell()
{
    UIImageView *userHeadImageView;
    
    UILabel *userNameLabel;
    UILabel *messageLabel;
    UILabel *dateLabel;
    UILabel *unReadLabel;   //未读取
    
}


@end


@implementation JWChatListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        
        userHeadImageView = [[UIImageView alloc]init];
        userHeadImageView.layer.cornerRadius = 22;
        userHeadImageView.backgroundColor = [UIColor clearColor];
        userHeadImageView.clipsToBounds = YES;
        [self.contentView addSubview:userHeadImageView];
        
        userNameLabel = [[UILabel alloc]init];
        userNameLabel.font = [UIFont systemFontOfSize:16];
        userNameLabel.textColor = [UIColor blackColor];
        userNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:userNameLabel];
        
    
        messageLabel = [[UILabel alloc]init];
        messageLabel.font = [UIFont systemFontOfSize:12];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:messageLabel];
        
        dateLabel = [[UILabel alloc]init];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:dateLabel];

        unReadLabel = [[UILabel alloc]init];
        unReadLabel.font = [UIFont systemFontOfSize:12];
        unReadLabel.textColor = [UIColor whiteColor];
        unReadLabel.backgroundColor = MessageBackColor;
        unReadLabel.layer.cornerRadius = 10;
        unReadLabel.textAlignment = NSTextAlignmentCenter;
        unReadLabel.clipsToBounds = YES;
        unReadLabel.hidden = YES;
        [self.contentView addSubview:unReadLabel];
        
    }
    return self;
}

- (void)refreshDataFrome:(JWChatMessageModel *)model
{
    if (model) {
        self.dataModel = model;
        userHeadImageView.frame = CGRectMake(15, 11, 44, 44);
        userNameLabel.frame = CGRectMake(70, 16, 200, 20);
        userNameLabel.text = @"";

        messageLabel.frame = CGRectMake(70, 38, 200, 20);
        dateLabel.frame = CGRectMake(SCREENWIDTH-90, 16, 80, 20);
        unReadLabel.frame = CGRectMake(SCREENWIDTH-40, 38, 20, 20);
        dateLabel.textAlignment = NSTextAlignmentRight;
        if (model.time) {
            double  time = [[NSString stringWithFormat:@"%.f",[model.time doubleValue]/1000]doubleValue];
            dateLabel.text = [NSString stringWithDate:[NSDate dateWithTimeIntervalSince1970:time]];
        }
        if (model.type == 1) {
            messageLabel.text = model.text;
        }else if ((model.type == 2)|5|3|6){
            messageLabel.text =@"[图片]";
        }else if (model.type == 4){
            messageLabel.text = @"分享了一个链接";
        }
        
        //判断是否有缓存 没有就下载
        BOOL haveCache = NO;
        if ([[JWChatDataManager sharedManager].userInfoDict.allKeys containsObject:StringFormat(model.otherId)]) {
            OtherUserModel *other = [[JWChatDataManager sharedManager].userInfoDict objectForKey:[NSString stringWithFormat:@"%@",model.otherId]];
            if ([NSObject nulldata:other.nickname]) {
                haveCache = YES;
            }
        }
        if (haveCache) {
            OtherUserModel *other = [[JWChatDataManager sharedManager].userInfoDict objectForKey:[NSString stringWithFormat:@"%@",model.otherId]];
            if (other) {
                userNameLabel.text = other.nickname;
                
                if ([NSObject nulldata:other.avatar]) {
                    [userHeadImageView sd_setImageWithURL:[NSURL URLWithString:other.avatar]];
                }else{
                    userHeadImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
                }
                if (other.messagenum >0) {
                    unReadLabel.text = [NSString stringWithFormat:@"%d",other.messagenum];
                    unReadLabel.hidden = NO;
                }
            }

        }else{
            __weak __typeof(self)weakSelf = self;
            
            __weak __typeof (userHeadImageView)headimg = userHeadImageView;
            
            __weak __typeof (userNameLabel)nameLabel =userNameLabel;
            
            [[JWNetClient defaultJWNetClient]squareGet:@"/users" requestParm:@{@"userId":model.otherId} result:^(id responObject, NSString *errmsg) {
                if (weakSelf == NULL)return ;
                if (!errmsg) {
                    NSDictionary *result = responObject[@"data"];
                    if (result) {
                        if ([NSObject nulldata:result[@"avatar"]] && headimg) {
                            [headimg sd_setImageWithURL:[NSURL URLWithString:result[@"avatar"]]];
                        }else{
                            userHeadImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
                            
                        }
                        if (nameLabel && [NSObject nulldata:result[@"nickname"]]) {
                            nameLabel.text = result[@"nickname"];
                        }
                        [[JWChatDataManager sharedManager]saveUserToLocal:result];                        
                    }
                }
            }];
        }
    }
}

- (void)prepareForReuse
{
    userNameLabel.text = nil;
    unReadLabel.hidden = YES;
    userHeadImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
   
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
