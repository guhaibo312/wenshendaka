//
//  SquareCommentCell.h
//  Bshopkeeper
//
//  Created by jinwei on 15/6/4.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@class SquareCommentItem;



@interface SquareCommentCell : UITableViewCell
{
    UIImageView *leftHeadImageView;     //头像
    TTTAttributedLabel *userNameLabel;  //名称
    TTTAttributedLabel *replayNameLabel;           //回复；
    UILabel * atextLabel;               //内容
    UIView *bottomLine;
    UILabel *releaseLabel;              //发布时间
}

@property (nonatomic,weak) SquareCommentItem *dataItem;

@property (nonatomic, assign) UIViewController *owner;
- (void)refreshDataWith:(SquareCommentItem *)commentItem owner:(UIViewController *)targer;

- (void)bingLongPressAction:(SEL)action target:(id)target withSender:(NSString *)senderName;

@end


@interface SquareFromeCell : UITableViewCell
{
    UIImageView *leftHeadImageView;     //头像
    UILabel * nameLabel;
    UIImageView *vSignView;
    UIImageView *autSignView;
    UILabel *hotLabel;
    
}

- (void)refreshFromDict:(NSDictionary *)dict;


@end

typedef NS_ENUM(NSInteger, SquareCommentItemStatus)
{
    CommentItemStatusNormal = 1,
    CommentItemStatusLoading,
    CommentItemStatusFail
};

typedef void(^commentItemDataChangeBlock)(SquareCommentItemStatus status);

@interface SquareCommentItem : NSObject

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double time;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSDictionary *replyUserInfo;
@property (nonatomic, assign) float   commentCellHeight;

@property (nonatomic, assign) SquareCommentItemStatus dataStatus;
@property (nonatomic, copy) commentItemDataChangeBlock changBlock;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)calculateWithCommentCellHeight;

@end

@interface CommentStatusBtn : UIButton

@end