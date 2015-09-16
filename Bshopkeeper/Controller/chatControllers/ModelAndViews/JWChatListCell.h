//
//  JWChatListCell.h
//  Bshopkeeper
//
//  Created by jinwei on 15/8/21.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWChatMessageModel;

@interface JWChatListCell : UITableViewCell

@property (nonatomic, weak) JWChatMessageModel *dataModel;

- (void)refreshDataFrome:(JWChatMessageModel *)model;

@end
