//
//  SquareObject.h
//  Bshopkeeper
//
//  Created by jinwei on 15/5/26.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoWallView.h"
#import "SquareLikeButton.h"
#import "SquareURLView.h"
#import "JWPhotoWallView.h"


typedef NS_ENUM(NSInteger, ListTableStyle) {
    ListTableStyleSquarelist,
    ListTableStyleUserPageList
};

@interface SquareObject : NSObject


@property (nonatomic, strong) NSString *apiHost;

@property (nonatomic, strong) UITableView *listTable;

@property (nonatomic, strong) NSString *userPageId;

@property (nonatomic) UIViewController *superVc;

@property (nonatomic, strong) NSDictionary *userPageInfo;

@property (nonatomic, strong) NSString *sector;

@property (nonatomic, weak) UIView *firstHeaderNoticeView;

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)viewcontroller withSupView:(UIView *)supview style:(ListTableStyle)style;

- (void)setupRefresh;

- (void)clearMemoryCache;

@end

@interface SquareDataItem : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic, strong)           NSString *companyName;  //机构名称
@property (nonatomic, strong)           NSString *_id;          //ID
@property (nonatomic, strong)           NSString *content;      //内容文字
@property (nonatomic, strong)           NSString *create_time;  //发布时间
@property (nonatomic, strong)           NSArray *image_urls;    //图片数组
@property (nonatomic, assign)           int like_count;   //赞的个数
@property (nonatomic, assign)           int comment_count;//评论数
@property (nonatomic, strong)           NSString *updated;      //更新于
@property (nonatomic, assign)           BOOL liked;             //是否赞过
@property (nonatomic, strong)           NSDictionary *userInfo; //用户
@property (nonatomic, strong)           NSDictionary *fromInfo;
@property (nonatomic, strong)           NSString *tag;
@property (nonatomic, assign)           NSInteger type;         //类型0 文字＋图片  1纯文字 2 纯图片 3 url链接
@property (nonatomic, strong)           NSString *title;        //分享标题
@property (nonatomic, strong)           NSString *url;          //分享url
@property (nonatomic, strong)           NSString *from;        //分享来自

@property (nonatomic, assign)           BOOL isShowPart; //是否全部展示

@property (nonatomic, assign)           BOOL isV;

@property (nonatomic, assign)           float cellHeight;       //回来数据后计算高度
@property (nonatomic, assign)           float UserInfoCellHeight;

@property (nonatomic, assign)           float ContententLabelHeight;

@property (nonatomic, assign)           float useContentLabelHeitht;

- (void)calculateWithCellHeight;

@end


@interface SquareTableViewCell : UITableViewCell
{
    UIImageView *headImageView;                             //头像
    UIImageView *vImageView;                                //v
    UIImageView *autimgeview;                               // 认证
    
    UILabel     *companyLabel;                              //机构
    UILabel     *userNameLabel;                             //用户名
    UILabel     *publishDateLabel;                          //发布时间
//    UILabel     *fromLabel;                                 //分享来自
    UILabel     *locationlabel;                             //地址
    UILabel     *acontentLabel;                              //文字

    
    UIView *acontentView;                                    //内容
    UIView *topSegmentationLine;                            //分割线

    JWPhotoWallView *photoView;                               //照片墙
//    SquareURLView *     urlView;                            //分享内容
    SquareLikeButton    *likeBtn;                           //赞
    SquareLikeButton    *commentBtn;                        //评论
    
    UIButton    *shareBtn;                                  //分享
    UIButton    *reportBtn;                                 //举报 删除按钮
    UIButton    *showBtn;                                   //展开btn
}

@property (nonatomic, assign) SquareDataItem *dataSource;

- (void)refreshDataFromSquareDataItem:(SquareDataItem *)item;

- (void)bingAction:(SEL)action target:(id)target withreceive:(NSString *)receivedStr;

- (UIImage *)getHeadImageViewForImg;

@end


typedef NS_ENUM(NSInteger, UserInfoCellCurrentStatus) {
    UserInfoCellCurrentStatusNormal,
    UserInfoCellCurrentStatusFirst,
    UserInfoCellCurrentStatusLast
};
@interface SquareUserInfoCell : UITableViewCell
{
    UIView     *leftTopLineView   ;                         //上边线
    UIView      *leftBottomLineView;                        //左侧边线
    UILabel     *publishDateLabel;                          //发布时间
    UIView *acontentView;                                    //内容
    UILabel     *acontentLabel;                              //文字
    PhotoWallView *photoView;                               //照片墙
    SquareURLView *     urlView;                            //分享内容
    SquareLikeButton    *likeBtn;                           //赞
    SquareLikeButton    *commentBtn;                        //评论
    UIButton    *shareBtn;                                  //分享
    UIButton    *showBtn;                                   //展开btn
    UIView *topSegmentationLine;                            //分割线
}

@property (nonatomic, assign) SquareDataItem *dataSource;

- (void)refreshDataFromSquareDataItem:(SquareDataItem *)item status:(UserInfoCellCurrentStatus)status lastItem:(SquareDataItem *)lastItem;

- (void)bingAction:(SEL)action target:(id)target withreceive:(NSString *)receivedStr;


@end

@interface SquareUserInfoReleaseCell : UITableViewCell

@property (nonatomic, strong)  UIView *bottomLineView;
@property (nonatomic, strong)   UIButton * releaseButton;


@end