//
//  MessageRelatedTableView.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

typedef void(^getMessageCountBlock)(int count);

@interface MessageRelatedTableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame withOwner:(UIViewController *)ownerVC isReceiveNotice:(BOOL)received;

@property (nonatomic, assign) UIViewController *supVC;

@property (nonatomic, assign) int messageCount;

@property (nonatomic, copy) getMessageCountBlock countBlock;

@end

@interface MessageReleaseObject : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double created;
@property (nonatomic, strong) NSDictionary *feed;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSInteger type;

- (instancetype)initWithDict:(NSMutableDictionary *)dict;

@end

@interface MessageReleaseCell : UITableViewCell<TTTAttributedLabelDelegate>
{
    UIImageView *userAvatarView;
    TTTAttributedLabel *userNameLabel;
    UILabel *timeLabel;
    UIImageView *contentImageView;
    UILabel *readLabel;
    UILabel *contentLabel;
    
}
@property (nonatomic, assign)   UIViewController * owner ;

@property (nonatomic, assign) MessageReleaseObject *dataObject;

- (void)refreshDataFrom:(MessageReleaseObject *)object withTarget:(UIViewController *)target;

@end
