//
//  JWChatDetailCell.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWChatMessageModel.h"
#import "JWChatMessageFrameModel.h"
#import "JWChatContentButton.h"
#import "JWChatDetailListTableView.h"

typedef NS_ENUM(NSInteger, ChatMessageType) {
    ChatMessageTypeText = 1,
    ChatMessageTypeImage ,
    ChatMessageTypeImageAndText,
    ChatMessageTypeShared,
    ChatMessageTypeMoreImage,
    ChatMessageTypeMoreImageAndText
};

@interface JWChatDetailCell : UITableViewCell

{
    UIImageView *headImageView;
    
    JWChatContentButton *btnContent;
        
    UILabel *createLabel;
    
    UIActivityIndicatorView *indicatiorView;
}

@property (nonatomic, weak) JWChatMessageFrameModel *dataItem;

@property (nonatomic, strong) JWSendFailButton *failButton;

- (void)setChatDetail:(JWChatMessageFrameModel *)item beforeItem:(JWChatMessageFrameModel *)beforeModel;


@end

