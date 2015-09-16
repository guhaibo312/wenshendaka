//
//  SquareObject.m
//  Bshopkeeper
//
//  Created by jinwei on 15/5/26.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SquareObject.h"
#import "Configurations.h"
#import "UIScrollView+JWRefresh.h"
#import "NSString+Extension.h"
#import "UIImageView+WebCache.h"
#import "SquareInfoDetailViewController.h"
#import "SquareUserPageViewController.h"
#import "H5PreviewManageViewController.h"
#import "MainViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CreateSquareMessageViewController.h"
#import "SquareUserPageHead.h"
#import "MobClick.h"
#import "JWEvent.h"

@interface SquareObject ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    BOOL _isRefresh;
    BOOL _isNothingMore;
    ListTableStyle currentStyle;
    NSMutableDictionary *parm;
    
    SquareDataItem *tempDataItem;           //临时纪录的信息
}
@property (nonatomic, strong) NSMutableArray *dataListArray;

@end

@implementation SquareObject

- (void)clearMemoryCache
{
    _dataListArray = nil;
    _superVc = nil;
    _listTable.delegate = nil;
    _listTable = nil;

}

- (instancetype)initWithFrame:(CGRect)frame ownerController:(UIViewController *)viewcontroller withSupView:(UIView *)supview style:(ListTableStyle)style
{
    self = [super init];
    if (self) {
        [JWEvent defaultJWEvent].hobbyCircleTimesOfOnce = 0;
        [JWEvent defaultJWEvent].hobbyUrlTimesOfonce = 0;
        [JWEvent defaultJWEvent].tattooCircleTimesOfOnce = 0;
        [JWEvent defaultJWEvent].tattooUrlTimesOfonce = 0;

        parm = [[NSMutableDictionary alloc]init];
        [parm setObject:@(20) forKey:@"limit"];
        currentStyle = style;
        _dataListArray = [NSMutableArray array];
        _listTable = [[UITableView alloc]initWithFrame:frame];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        UIView *footView = [[UIView alloc]init];
        footView.backgroundColor = [UIColor whiteColor];
        _listTable.tableFooterView = footView;
        if (viewcontroller) {
            self.superVc = viewcontroller;
        }
        [supview addSubview:_listTable];
        
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(likeChangeAction:) name:SquareLikeOrcommentChangedNotice object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delegateFeedAction:) name:SquareFeedDelegateNotice object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(releaseFeedFunction:) name:SquareFeedReleaseNotice object:nil];
    }
    return self;
}

#pragma mark ------------------------ 评论 赞变化的通知-----------------------------------------

- (void)likeChangeAction:(NSNotification *)notication
{
    SquareDataItem *item = notication.object;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF._id CONTAINS %@", item._id];
    NSArray *newMessages = [_dataListArray filteredArrayUsingPredicate:predicate];
    if (newMessages.count >0) {
        SquareDataItem *result = [newMessages firstObject];
        NSInteger index = [_dataListArray indexOfObject:result];
        if (index >=0 && index <= _dataListArray.count-1 ) {
            [_dataListArray replaceObjectAtIndex:index withObject:item];
            [_listTable reloadData];
        }
    }
}
#pragma mark------------------------- feed 删除的通知-----------------------------------------
- (void)delegateFeedAction:(NSNotification *)notication
{
    SquareDataItem *item = notication.object;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF._id CONTAINS %@", item._id];
    NSArray *newMessages = [_dataListArray filteredArrayUsingPredicate:predicate];
    if (newMessages.count >0) {
        SquareDataItem *result = [newMessages firstObject];
        NSInteger index = [_dataListArray indexOfObject:result];
        if (index >=0 && index <= _dataListArray.count-1 ) {
            [_dataListArray removeObjectAtIndex:index];
            [_listTable reloadData];
        }
    }

}
#pragma mark ------------------------- 收到feed的通知---------------------------------------
- (void)releaseFeedFunction:(NSNotification *)notication
{
    NSDictionary *resultDict =  notication.object;
    if (resultDict) {
        SquareDataItem *item =  [[SquareDataItem alloc]initWithDictionary:resultDict];
        if (!item.create_time) {
            item.create_time = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
        }
        [_dataListArray insertObject:item atIndex:0];
        [_listTable reloadData];
        [_listTable setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark  ----------------------- 设置 进入时的刷新状态-----------------------------------
- (void)setupRefresh
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    
    [_listTable addFooterWithCallback:^{
        if (vc) {
            [vc footerRereshing];
        }
    }];

    
    if (currentStyle != ListTableStyleUserPageList) {
        [_listTable addHeaderWithCallback:^{
            if (vc) {
                [vc headerRereshing];
            }
        }];
        [_listTable headerBeginRefreshing];
    }else{
        [self headerRereshing];
    }
    
    
    

    
}
#pragma mark ----------------------------- 刷新数据 ---------------------------------------------

- (void)headerRereshing
{
    [LoadingView show:@"刷新中..."];
    _isRefresh = YES;
    _isNothingMore = NO;
    parm = [[NSMutableDictionary alloc]init];
    [parm setObject:@(20) forKey:@"limit"];
    if (_sector) {
        [parm setObject:_sector forKey:@"sector"];
    }
    [self requestAction];
    _listTable.userInteractionEnabled = NO;
}

- (void)requestAction
{
    
    __weak __typeof (self)weakself = self;
    if (currentStyle == ListTableStyleSquarelist) {
        [[JWNetClient defaultJWNetClient]squareGet:_apiHost?_apiHost:@"/feeds/all/" requestParm:parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (weakself == NULL) return;
            if (!errmsg && responObject != NULL) {
                [weakself requestFinish:responObject];
            }else{
                [SVProgressHUD showErrorWithStatus:errmsg];
                [weakself requestFinish:nil];
            }
        }];
        return;
    }else{
        //个人中心
        [parm setObject:StringFormat(_userPageId) forKey:@"userId"];
        [[JWNetClient defaultJWNetClient]squareGet:@"/feeds/outbox" requestParm:parm result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (!weakself) return;
            if (!errmsg && responObject != NULL) {
                [weakself requestFinish:responObject];
            }else{
                [SVProgressHUD showErrorWithStatus:errmsg];
                [weakself requestFinish:nil];
            }
        }];
    }
    
}


- (void)requestFinish:(NSDictionary *)responObject
{
    if (responObject) {
        NSArray *resultArray = [responObject objectForKey:@"data"];
        if (resultArray) {
            NSMutableArray *backArray = [NSMutableArray arrayWithCapacity:20];
            for (int i = 0 ; i< resultArray.count; i++) {
                SquareDataItem *oneItem = [[SquareDataItem alloc]initWithDictionary:resultArray[i]];
                [backArray addObject:oneItem];
            }
            if (_isRefresh) {
                _dataListArray  = [NSMutableArray arrayWithArray:backArray];
            }else{
                [_dataListArray addObjectsFromArray:backArray];
            }
            if (resultArray.count <20) {
                _isNothingMore = YES;
            }
            
        }

    }
    _listTable.userInteractionEnabled = YES;
    
    [_listTable reloadData];
    [_listTable headerEndRefreshing];
    [_listTable footerEndRefreshing];
}

#pragma mark ---------------------- 加载数据 ---------------------------------------------
- (void)footerRereshing
{
    if (_isNothingMore) {
        [SVProgressHUD showErrorWithStatus:@"已经没有更多数据了！"];
        [_listTable headerEndRefreshing];
        [_listTable footerEndRefreshing];
        
        return;
    }
    [LoadingView show:@"加载中...."];
    _isRefresh = NO;
    SquareDataItem *item = [_dataListArray lastObject];
    if (item) {
        
        if (currentStyle == ListTableStyleSquarelist) {
            [parm setObject:item.updated forKey:@"updated"];
        }else{
            [parm setObject:item._id forKey:@"latest_feed_id"];
        }
    }
    _listTable.userInteractionEnabled = NO;
    [self requestAction];
}



#pragma mark ----------------------- UITableViewDelegate datasourcedelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!tableView || !self) return nil ;
    
    if (currentStyle == ListTableStyleUserPageList) {
        
        if ([_userPageId isEqualToString:[NSString stringWithFormat:@"%@",[User defaultUser].item.userId]] && indexPath.row == 0) {
            
            static NSString *firstIdentifeir = @"firstIdentifier";
            SquareUserInfoReleaseCell *cell = [tableView dequeueReusableCellWithIdentifier:firstIdentifeir];
            if (!cell) {
                cell = [[SquareUserInfoReleaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstIdentifeir];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.tag = indexPath.row;
            if (_dataListArray.count>0) {
                cell.bottomLineView.hidden = NO;
            }else{
                cell.bottomLineView.hidden = YES;
            }
            [cell.releaseButton addTarget:self action:@selector(createFeedAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
        static NSString *cellIdentifier = @"userPageListCell";
        SquareUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[SquareUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        SquareDataItem *item;
        SquareDataItem *lastItem;

        BOOL isMypage = NO;
        if ([_userPageId integerValue] == [[User defaultUser].item.userId integerValue]) {
            cell.tag = indexPath.row-1;
            isMypage = YES;
            item = [_dataListArray objectAtIndex:indexPath.row-1];
            if (indexPath.row-2 >=0 && indexPath.row-2 < _dataListArray.count) {
                lastItem = [_dataListArray objectAtIndex:indexPath.row-2];
            }
            
        }else{
            cell.tag = indexPath.row;
            item = [_dataListArray objectAtIndex:indexPath.row];
            if (indexPath.row-1 >=0 && indexPath.row-1 < _dataListArray.count) {
                lastItem = [_dataListArray objectAtIndex:indexPath.row-1];
            }
        }
        
        [cell bingAction:@selector(clickCellLikedAction:) target:self withreceive:@"like"];
        [cell bingAction:@selector(clickCellShareAction:) target:self withreceive:@"share"];
        [cell bingAction:@selector(clickUrlFunction:) target:self withreceive:@"url"];
        [cell bingAction:@selector(showBtnFunction:) target:self withreceive:@"show"];
        
        
        
        if (isMypage) {
            [cell refreshDataFromSquareDataItem:item status:indexPath.row == _dataListArray.count?UserInfoCellCurrentStatusLast:UserInfoCellCurrentStatusNormal lastItem:lastItem];
        }else{
             [cell refreshDataFromSquareDataItem:item status:indexPath.row == 0?UserInfoCellCurrentStatusFirst:(indexPath.row == _dataListArray.count-1?UserInfoCellCurrentStatusLast:UserInfoCellCurrentStatusNormal) lastItem:lastItem];
        }
        return cell;
    }else{
        static NSString *squarecellIdentifier = @"squareCell";
        SquareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:squarecellIdentifier];
        if (!cell) {
            cell = [[SquareTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:squarecellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.tag = indexPath.row;
        [cell bingAction:@selector(clickCellLikedAction:) target:self withreceive:@"like"];
        [cell bingAction:@selector(clickCellShareAction:) target:self withreceive:@"share"];
        [cell bingAction:@selector(clickReportAction:) target:self withreceive:@"report"];
        [cell bingAction:@selector(clickUrlFunction:) target:self withreceive:@"url"];
        [cell bingAction:@selector(showBtnFunction:) target:self withreceive:@"show"];
        SquareDataItem *item = [_dataListArray objectAtIndex:indexPath.row];
        [cell refreshDataFromSquareDataItem:item];
        return cell;
    }
}

#pragma mark ---  发布feed
- (void)createFeedAction:(UIButton *)sender
{
    if (!self && !_superVc) return;
    CreateSquareMessageViewController *createMessageVC = [[CreateSquareMessageViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:createMessageVC];
    [_superVc presentViewController:navigation animated:YES completion:NULL];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentStyle != ListTableStyleUserPageList) {
        if ([[User defaultUser].item.sector integerValue] == 30) {
            [MobClick event:@"30_open_feed"];
            [JWEvent defaultJWEvent].tattooCircleTimesOfOnce++;
        }else{
            [MobClick event:@"0_open_feed"];
            [JWEvent defaultJWEvent].hobbyCircleTimesOfOnce++;
        }
    }
    
    
    SquareDataItem *item;
    if (currentStyle == ListTableStyleUserPageList && [_userPageId isEqualToString:[NSString stringWithFormat:@"%@",[User defaultUser].item.userId]]) {
        if (indexPath.row == 0) {
            return;
        }
        item = [_dataListArray objectAtIndex:indexPath.row-1];
    }else{
        item = [_dataListArray objectAtIndex:indexPath.row];
    }
    
    if (item) {
        SquareInfoDetailViewController *detailVC = [[SquareInfoDetailViewController alloc]initWithQuery:@{@"item":item}];
        [_superVc.navigationController pushViewController:detailVC animated:YES];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentStyle == ListTableStyleUserPageList && [_userPageId isEqualToString:[NSString stringWithFormat:@"%@",[User defaultUser].item.userId]] ) {
        return _dataListArray.count+1;
    }
    return _dataListArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentStyle == ListTableStyleUserPageList) {
        
        if ([_userPageId isEqualToString:[NSString stringWithFormat:@"%@",[User defaultUser].item.userId]]) {
            
            if (indexPath.row == 0) {
                return 120;
            }else{
                SquareDataItem *item = [_dataListArray objectAtIndex:indexPath.row-1];
                return   item.UserInfoCellHeight;
            }
        }
        
        SquareDataItem *item = [_dataListArray objectAtIndex:indexPath.row];
        return   item.UserInfoCellHeight;
    }
    
    
    SquareDataItem *item = [_dataListArray objectAtIndex:indexPath.row];
    return item.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_firstHeaderNoticeView) {
        return 60;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_firstHeaderNoticeView) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
        headView.backgroundColor = VIEWBACKGROUNDCOLOR;
        [headView addSubview:_firstHeaderNoticeView];
        _firstHeaderNoticeView.center = headView.center;
        return headView;
    }
    return nil;
}


#pragma mark ------------------------- 点击全文--------------------------------------------

- (void)showBtnFunction:(UIButton *)sender
{
    NSInteger index = sender.tag/7;
    SquareDataItem *item = [_dataListArray objectAtIndex:sender.tag/7];
    
    [item calculateWithCellHeight];
    [_dataListArray replaceObjectAtIndex:index withObject:item];
    [_listTable reloadData];
}

#pragma mark -------------------------- 点击链接--------------------------------------------

- (void)clickUrlFunction:(UIButton *)sender
{
    
    if (currentStyle != ListTableStyleUserPageList) {
        if ([[User defaultUser].item.sector integerValue] == 30) {
            [MobClick event:@"30_open_feed_url"];
            [JWEvent defaultJWEvent].tattooUrlTimesOfonce++;
        }else{
            [MobClick event:@"0_open_feed_url"];
            [JWEvent defaultJWEvent].hobbyUrlTimesOfonce++;
        }
    }
    
    SquareDataItem *item = [_dataListArray objectAtIndex:sender.tag/6];

    if (!_superVc || !item) return;
    H5PreviewManageViewController *h5manageVC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":item.url?item.url:@""}];
    [_superVc.navigationController pushViewController:h5manageVC animated:YES];
}


#pragma mark -------------------------- 点击赞---------------------------------------------

- (void)clickCellLikedAction:(SquareLikeButton *)sender
{
    SquareDataItem *item = [_dataListArray objectAtIndex:sender.tag];
    
    
    if (!sender.selected) {
        __unsafe_unretained typeof(sender) likeBtn = sender;
        if ([NSObject nulldata:item._id ]) {
            [[JWNetClient defaultJWNetClient]squarePut:@"/feeds/like/" requestParm:@{@"feed_id":item._id} result:^(id responObject, NSString *errmsg) {
                if (self && likeBtn) {
                    if (!responObject || errmsg) {
                        [SVProgressHUD showErrorWithStatus:errmsg];
                    }else{
                        item.liked = YES;
                        sender.selected = YES;
                        // 赞
                        item.like_count++;
                        if (sender) {
                            sender.contentLabel.textColor = SquareLikedColor;
                            sender.leftImgView.image = [UIImage imageNamed:@"icon_square_liked.png"];
                            sender.contentLabel.text = [NSString stringWithFormat:@"赞 %ld",(long)item.like_count];
                        }

                    }
                }
                
            }];
            
        }

    }else{
        //取消赞
        
        __unsafe_unretained typeof(sender) likeBtn = sender;
        if ([NSObject nulldata:item._id]) {
            [[JWNetClient defaultJWNetClient]squareDelegate:@"/feeds/like/" requestParm:@{@"feed_id":item._id} result:^(id responObject, NSString *errmsg) {
                if (self && likeBtn) {
                    if (!responObject || errmsg) {
                        [SVProgressHUD showErrorWithStatus:errmsg];
                    }else{
                        item.like_count--;
                        if (item.like_count<1) {
                            item.like_count = 0;
                        }
                        item.liked = NO;
                        sender.selected = NO;
                        if (sender) {
                            sender.contentLabel.textColor = SquareTextColor;
                            sender.leftImgView.image = [UIImage imageNamed:@"icon_square_unliked.png"];
                            sender.contentLabel.text = [NSString stringWithFormat:@"赞 %ld",(long)item.like_count];
                            
                        }

                    }
                }
            }];
        }
    }
}
    
#pragma mark ----------------------------- 点击分享 -------------------------------------

- (void)clickCellShareAction:(UIButton *)sender
{
    
    
    SquareDataItem *item = [_dataListArray objectAtIndex:sender.tag/10];
    
    UIImage *shareImg;
    if (_listTable.tableHeaderView) {
        if ([_listTable.tableHeaderView isKindOfClass:[SquareUserPageHead class]]) {
            SquareUserPageHead *userHeadView = (SquareUserPageHead *)_listTable.tableHeaderView;
            shareImg = [userHeadView getShareHeadImage];
        }
    }
    
    SharedItem *shareItem = [[SharedItem alloc] init];
    shareItem.title = @"纹身大咖最新动态";
    if (item.content) {
        shareItem.content = item.content;
    }
    shareItem.sharedURL = API_SHAREURL_FEED(item._id);
    shareItem.shareImg = shareImg?shareImg:[UIImage imageNamed:@"icon_userHead_default.png"];
    JWShareView *shareView = [[JWShareView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) withShareTypes:nil dataItem:shareItem UIViewController:_superVc];
    [shareView show];

}

#pragma mark -----------------------------点击举报或着删除----------------------------------
- (void)clickReportAction:(UIButton *)sender
{
    SquareDataItem *item = [_dataListArray objectAtIndex:sender.tag/5];

    tempDataItem = item;
    if ([item.userInfo[@"userId"] isEqual:[User defaultUser].item.userId]) {
        UIActionSheet *actionS = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        actionS.tag = 300;
        [actionS showInView:_superVc.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"举报此信息,选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"淫秽",@"虚假信息",@"垃圾广告",@"其他" ,nil];
        actionSheet.tag = 301;
        [actionSheet showInView:_superVc.view];

    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!self && !tempDataItem ) return;
        
    if (actionSheet.tag == 300 && buttonIndex == 0) {
        [LoadingView show:@"请稍候..."];
        _superVc.view.userInteractionEnabled = NO;
        [[JWNetClient defaultJWNetClient]squareDelegate:@"/feeds/" requestParm:@{@"feed_id":tempDataItem._id} result:^(id responObject, NSString *errmsg) {
            [LoadingView dismiss];
            if (!self || !_superVc) return ;
            _superVc.view.userInteractionEnabled = YES;
            if (errmsg || !responObject) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:SquareFeedDelegateNotice object:tempDataItem];
            }
            
        }];
        
        return;
    }
    if (actionSheet.tag == 301 && buttonIndex!= 4) {
        [[JWNetClient defaultJWNetClient]squarePut:@"/feeds/accuse/" requestParm:@{@"feedId":tempDataItem._id,@"reasonType":@(buttonIndex+1)} result:^(id responObject, NSString *errmsg) {
            if (!self) return ;
            if (errmsg) {
                [SVProgressHUD showErrorWithStatus:errmsg];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"感谢参与！"];
            }
            
        }];
        
        return;
    }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (_dataListArray) {
        _dataListArray = nil;
    }
    if (_listTable) {
        _listTable = nil;
    }
    if (_superVc) {
        _superVc = nil;
    }
    
}

@end


//------------------------------------------cell-----------------------------------------------
@implementation SquareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        topSegmentationLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0.5, SCREENWIDTH, 0.5)];
        topSegmentationLine.backgroundColor = GrayBackColor;
        [self.contentView addSubview:topSegmentationLine];
        
        // 头像 名称 发布时间
        headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 44, 44)];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.clipsToBounds = YES;
        headImageView.backgroundColor = [UIColor clearColor];
        headImageView.layer.cornerRadius = 22;
        headImageView.layer.borderWidth = 1;
        headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        UITapGestureRecognizer *tapHead = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushtoUserPageAction:)];
        [headImageView addGestureRecognizer:tapHead];
        headImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:headImageView];
        
        //用户名
        userNameLabel = [UILabel labelWithFrame:CGRectMake(headImageView.right+15, 12, SCREENWIDTH-headImageView.right-60,22 ) fontSize:16 fontColor:SquareLinkColor text:@""];
        UITapGestureRecognizer *tapUserNameLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushtoUserPageAction:)];
        [userNameLabel addGestureRecognizer:tapUserNameLabel];
        userNameLabel.userInteractionEnabled = YES;
        userNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:userNameLabel];
        
        //机构
        companyLabel = [UILabel labelWithFrame:CGRectMake(userNameLabel.right+5, 12, 100, 22) fontSize:14 fontColor:GRAYTEXTCOLOR text:@""];
        companyLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:companyLabel];
        
        //v验证
        vImageView = [[UIImageView alloc]initWithFrame:CGRectMake(headImageView.right+15, 34+3, 18, 16)];
        vImageView.image = [UIImage imageNamed:@"icon_mine_v.png"];
        [self.contentView addSubview:vImageView];
        
        autimgeview = [[UIImageView alloc]initWithFrame:CGRectMake(vImageView.right+8, 34, 22, 22)];
        autimgeview.image = [UIImage imageNamed:@"icon_mine_aut_pass.png"];
        [self.contentView addSubview:autimgeview];
        
        
        //发布时间
        publishDateLabel = [UILabel labelWithFrame:CGRectMake(headImageView.right+15, 34, 60 ,18 ) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:publishDateLabel];
        
//        //分享来自
//        fromLabel = [UILabel labelWithFrame:CGRectMake(publishDateLabel.right+5, 34, SCREENWIDTH-publishDateLabel.right-80, 18) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
//        [self.contentView addSubview:fromLabel];
        
        //预报更多
        reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-75, 4, 60, 60)];
        reportBtn.backgroundColor = [UIColor clearColor];
        [reportBtn setImage:[UIImage imageNamed:@"icon_square_pointdown.png"] forState:UIControlStateNormal];
        reportBtn.imageEdgeInsets  = UIEdgeInsetsMake(18, 36 , 18, 0);
        [self.contentView addSubview:reportBtn];
        
        //内容
        acontentView = [[UIView alloc]initWithFrame:CGRectMake(10, 64, SCREENWIDTH- 20, 100)];
        acontentView.backgroundColor = [UIColor clearColor];
        acontentView.clipsToBounds = YES;
        [self.contentView addSubview:acontentView];
        
        //内容
        acontentLabel = [UILabel labelWithFrame:CGRectMake( 10 ,0,SCREENWIDTH-20, 20) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        acontentLabel.numberOfLines = 0;
        acontentLabel.backgroundColor = [UIColor clearColor];
        [acontentView addSubview:acontentLabel];
        
        showBtn = [[UIButton alloc]initWithFrame:CGRectMake(2, acontentLabel.bottom, 40, 20)];
        [showBtn setTitle:@"全文" forState:UIControlStateNormal];
        showBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [showBtn setTitleColor:SquareLinkColor forState:UIControlStateNormal];
        [acontentView addSubview:showBtn];
        
//        //分享的
//        urlView = [[SquareURLView alloc]initWithFrame:CGRectMake(8, showBtn.bottom+5, acontentView.width-16, 64)];
//        [acontentView addSubview:urlView];
//        urlView.hidden = YES;
        
        //照片大图 和 图片墙
        photoView = [[JWPhotoWallView alloc]initWithFrame:CGRectMake(0, showBtn.bottom, acontentView.width, 20)];
        [acontentView addSubview:photoView];
        
        
        //地址
        locationlabel = [UILabel labelWithFrame:CGRectMake(20, 0, 120, 30) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        locationlabel.backgroundColor = [UIColor clearColor];
        locationlabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:locationlabel];
        
        //赞 评论 分享
        likeBtn = [[SquareLikeButton alloc]initWithFrame:CGRectMake(acontentView.width-50-150, photoView.bottom+5, 80, 40) withTitle:nil imageName:@"icon_square_unliked.png"];
        [self.contentView addSubview:likeBtn];
        
        commentBtn = [[SquareLikeButton alloc]initWithFrame:CGRectMake(acontentView.width-50-60, photoView.bottom+5, 60, 40) withTitle:nil imageName:@"icon_square_comment.png"];
        commentBtn.contentLabel.textColor = SquareTextColor;
        commentBtn.enabled = NO;
        [self.contentView addSubview:commentBtn];
        
        shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(acontentView.width-50, photoView.bottom+10, 40, 40)];
        [shareBtn setImage:[UIImage imageNamed:@"icon_square_shared.png"] forState:UIControlStateNormal];
        shareBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self.contentView addSubview:shareBtn];
        
        self.contentView.backgroundColor = VIEWBACKGROUNDCOLOR;
        self.backgroundColor = VIEWBACKGROUNDCOLOR;
        
        
    }
    return self;
}

- (UIImage *)getHeadImageViewForImg
{
    return headImageView.image;
}

#pragma mark ----------------------------绑定方法----------------------------------------------

- (void)bingAction:(SEL)action target:(id)target withreceive:(NSString *)receivedStr
{
    if ([receivedStr isEqualToString:@"like"] && likeBtn) {
        if ([likeBtn.allTargets containsObject:target]) {
            [likeBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        likeBtn.userInteractionEnabled = YES;
        [likeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"comment"] && commentBtn){
        if ([commentBtn.allTargets containsObject:target]) {
            [commentBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        commentBtn.userInteractionEnabled = YES;
        [commentBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"share"]){
        if ([shareBtn.allTargets containsObject:target]) {
            [shareBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        shareBtn.userInteractionEnabled = YES;
        [shareBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"report"]){
        if ([reportBtn.allTargets containsObject:target]) {
            [reportBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        reportBtn.userInteractionEnabled = YES;
        [reportBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"url"]){
//        if ([urlView.allTargets containsObject:target]) {
//            [urlView removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//        }
//        urlView.userInteractionEnabled = YES;
//        [urlView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"show"]){
        if ([showBtn.allTargets containsObject:target]) {
            [showBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        showBtn.userInteractionEnabled = YES;
        [showBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }

}
- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    likeBtn.tag = tag;
    shareBtn.tag = tag*10;
    reportBtn.tag = tag*5;
//    urlView.tag = tag *6;
    showBtn.tag = tag *7;
}
#pragma mark ---------------------------- 刷新数据 ----------------------------------------------

- (void)refreshDataFromSquareDataItem:(SquareDataItem *)item 
{
    if (item) {
        if (!item.like_count) {
            item.like_count = 0;
        }
        //喜欢 和赞
        if (!item.liked) {
            likeBtn.contentLabel.textColor = SquareTextColor;
            likeBtn.leftImgView.image = [UIImage imageNamed:@"icon_square_unliked.png"];
            likeBtn.contentLabel.text = [NSString stringWithFormat:@"赞 %d",item.like_count];
            likeBtn.selected = NO;
        }else{
            likeBtn.selected = YES;
            likeBtn.contentLabel.textColor = SquareLikedColor;
            likeBtn.leftImgView.image = [UIImage imageNamed:@"icon_square_liked.png"];
            likeBtn.contentLabel.text = [NSString stringWithFormat:@"赞 %d",item.like_count];
        }
        commentBtn.contentLabel.text = [NSString stringWithFormat:@"%d",item.comment_count];
        _dataSource = item;
        headImageView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        headImageView.layer.borderColor = LINECOLOR.CGColor;

        //名称 头像 和机构 位置
        locationlabel.text = nil;
        
        companyLabel.frame = CGRectMake(userNameLabel.right, 12, SCREENWIDTH- userNameLabel.right-60, 22);
    
        NSDictionary *userinfo = item.userInfo;
        if (item.userInfo) {
            if ([[User defaultUser].followingDict.allKeys containsObject:[NSString stringWithFormat:@"%@",item.userInfo[@"userId"]]]) {
                userinfo = [[User defaultUser].followingDict objectForKey:[NSString stringWithFormat:@"%@",item.userInfo[@"userId"]]];
            }
            
            if ([NSObject nulldata:[userinfo objectForKey:@"avatar"]]) {
                [headImageView sd_setImageWithURL:[NSURL URLWithString:userinfo[@"avatar"]] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
                headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            }
            if ([NSObject nulldata:userinfo[@"nickname"]]) {
                userNameLabel.text = userinfo[@"nickname"];
            }
           
            NSString *nameText = [NSString stringWithFormat:@"%@",userinfo[@"nickname"]];
            float nameSizeWidth = [nameText sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(100, 22)].width;
            if (nameSizeWidth >= 80) {
                userNameLabel.width = 80;
            }else{
                userNameLabel.width = nameSizeWidth;
            }
            
            if ([NSObject nulldata:userinfo[@"company"]]) {
                if ([NSObject nulldata:userinfo[@"company"][@"name"]]) {
                    companyLabel.frame = CGRectMake(userNameLabel.right, 12, SCREENWIDTH- userNameLabel.right-60, 22);
                    companyLabel.text = [NSString stringWithFormat:@"| %@",userinfo[@"company"][@"name"]];
                }else{
                    if ([NSObject nulldata:item.companyName]) {
                        companyLabel.frame = CGRectMake(userNameLabel.right, 12, SCREENWIDTH- userNameLabel.right-60, 22);
                        companyLabel.text = [NSString stringWithFormat:@"| %@",item.companyName];
                    }else{
                        userNameLabel.width = SCREENWIDTH-userNameLabel.left-60;

                    }
                }
            }else{
                if ([NSObject nulldata:item.companyName]) {
                    companyLabel.frame = CGRectMake(userNameLabel.right, 12, SCREENWIDTH- userNameLabel.right-60, 22);
                    companyLabel.text = [NSString stringWithFormat:@"| %@",item.companyName];
                }else{
                    userNameLabel.width = SCREENWIDTH-userNameLabel.left-60;
                }
            }
            
            locationlabel.text = [[JudgeMethods defaultJudgeMethods]getOtherCityName:item.userInfo[@"city"] province:item.userInfo[@"province"]];
            locationlabel.top = item.cellHeight-35;
        }
        
        //加v
        if (item.isV) {
            vImageView.hidden = NO;
            autimgeview.hidden = NO;
            publishDateLabel.top = 64;
//            fromLabel.top = 64;
            acontentView.top = 84;
        }else{
            vImageView.hidden = YES;
            autimgeview.hidden = YES;
            publishDateLabel.top = 34;
//            fromLabel.top = 34;
            acontentView.top = 64;
        }
        
        //时间和来自
        if (item.create_time) {
            double createtime = [item.create_time doubleValue];
            if (createtime >9999999999) {
                createtime = createtime/1000;
            }
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:createtime];
            publishDateLabel.text = [NSString stringWithDate:date];
        }
        
        
        if (item.ContententLabelHeight>0) {
            acontentLabel.text = item.content;
            if (item.ContententLabelHeight >= 111) {
                if (item.isShowPart) {
                    acontentLabel.numberOfLines = 6;
                    acontentLabel.frame = CGRectMake(10,0, SCREENWIDTH-20, 111);
                    [showBtn setTitle:@"全文" forState:UIControlStateNormal];
                    showBtn.frame = CGRectMake(2, acontentLabel.bottom, 40, 20);
                    showBtn.hidden = NO;
                }else{
                    acontentLabel.numberOfLines = 0;
                    acontentLabel.frame = CGRectMake(10,0, SCREENWIDTH-20, item.ContententLabelHeight);
                    showBtn.frame = CGRectMake(2, acontentLabel.bottom, 40, 20);
                    showBtn.hidden = NO;
                    [showBtn setTitle:@"收起" forState:UIControlStateNormal];
                }
            }else{
                showBtn.hidden = YES;
                showBtn.height = 0;
                acontentLabel.numberOfLines = 0;
                acontentLabel.height = item.ContententLabelHeight;
            }
            
        }else{
            showBtn.hidden = YES;
            showBtn.height = 0;
            acontentLabel.height = 0;
        }
        
        photoView.hidden = NO;
        [photoView setAllImageWithArray:item.image_urls];
        photoView.top = showBtn.hidden?acontentLabel.bottom:showBtn.bottom;
        if (item.image_urls.count>=1 ) {
            acontentView.height = photoView.bottom;
        }else{
            acontentView.height = photoView.top;
        }
        likeBtn.top = item.cellHeight - 40;
        commentBtn.top = item.cellHeight - 40;
        shareBtn.top = item.cellHeight - 40;
    }
    
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    acontentLabel.text = nil;
    userNameLabel.text = nil;
    publishDateLabel.text = nil;
    companyLabel.text = nil;
    locationlabel.text = nil;
    
}

#pragma mark ---------------------------- 跳转到个人主页---------------------------------------------

- (void)pushtoUserPageAction:(UITapGestureRecognizer *)tap
{
    MainViewController *appRootVC = (MainViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC ;
    UINavigationController *navigationVC = (UINavigationController *)appRootVC.selectedViewController;
    if (navigationVC) {
        currentVC = [navigationVC topViewController];
    }
    NSString *userId = _dataSource.userInfo[@"userId"];
    if (currentVC && userId!= nil) {
        SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":[NSString stringWithFormat:@"%@",userId]}];
        [currentVC.navigationController pushViewController:userPageVC animated:YES];

    }
   
}

@end


//---------------------------------------- 个人中心cell－－－－－－－－－－－－－－－－－－－－
@implementation SquareUserInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        leftTopLineView = [[UIView alloc]initWithFrame:CGRectMake(47, 0, 1, 14)];
        leftTopLineView.backgroundColor = SquareLeftLineColor;
        [self.contentView addSubview:leftTopLineView];
        
        UIView *circelView = [[UIView alloc]initWithFrame:CGRectMake(47-3, 14-3, 6, 6)];
        circelView.backgroundColor = SquareLeftLineColor;
        circelView.clipsToBounds = YES;
        circelView.layer.cornerRadius = 3;
        [self.contentView addSubview:circelView];
        
         leftBottomLineView = [[UIView alloc]initWithFrame:CGRectMake(47, 14, 1, 20)];
        leftBottomLineView.backgroundColor = SquareLeftLineColor;
        [self.contentView addSubview:leftBottomLineView];
        
        //发布时间
        publishDateLabel = [UILabel labelWithFrame:CGRectMake(10, 0, 30 ,40 ) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        publishDateLabel.numberOfLines = 2;
        publishDateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:publishDateLabel];
        
       
        
        //内容
        acontentView = [[UIView alloc]initWithFrame:CGRectMake(56, 28, SCREENWIDTH- 56-10, 100)];
        acontentView.backgroundColor = [UIColor clearColor];
        acontentView.clipsToBounds = YES;
        [self.contentView addSubview:acontentView];
        
        //内容
        acontentLabel = [UILabel labelWithFrame:CGRectMake(8,0,acontentView.width-16, 20) fontSize:16 fontColor:[UIColor blackColor] text:@""];
        acontentLabel.numberOfLines = 0;
        acontentLabel.backgroundColor = [UIColor clearColor];
        [acontentView addSubview:acontentLabel];
        
        showBtn = [[UIButton alloc]initWithFrame:CGRectMake(2, acontentLabel.bottom, 40, 20)];
        [showBtn setTitle:@"全文" forState:UIControlStateNormal];
        showBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [showBtn setTitleColor:SquareLinkColor forState:UIControlStateNormal];
        [acontentView addSubview:showBtn];
        
        //分享的
        urlView = [[SquareURLView alloc]initWithFrame:CGRectMake(8, showBtn.bottom+5, acontentView.width-16, 64)];
        [acontentView addSubview:urlView];
        urlView.hidden = YES;
        
        //照片大图 和 图片墙
        photoView = [[PhotoWallView alloc]initWithFrame:CGRectMake(0, showBtn.bottom+5, acontentView.width, 20)];
        photoView.backgroundColor = [UIColor clearColor];
        [acontentView addSubview:photoView];
        
        
        //赞 评论 分享
        likeBtn = [[SquareLikeButton alloc]initWithFrame:CGRectMake(acontentView.width-50-150, photoView.bottom+5, 80, 40) withTitle:nil imageName:@"icon_square_unliked.png"];
        [acontentView addSubview:likeBtn];
        
        commentBtn = [[SquareLikeButton alloc]initWithFrame:CGRectMake(acontentView.width-50-60, photoView.bottom+5, 60, 40) withTitle:nil imageName:@"icon_square_comment.png"];
        commentBtn.contentLabel.textColor = SquareTextColor;
        commentBtn.enabled = NO;
        [acontentView addSubview:commentBtn];
        
        shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(acontentView.width-50, photoView.bottom+10, 40, 40)];
        [shareBtn setImage:[UIImage imageNamed:@"icon_square_shared.png"] forState:UIControlStateNormal];
        shareBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [acontentView addSubview:shareBtn];
        
        
        topSegmentationLine = [[UIView alloc]initWithFrame:CGRectMake(100 ,100, SCREENWIDTH-100, 0.5)];
        topSegmentationLine.backgroundColor = GrayBackColor;
        [self.contentView addSubview:topSegmentationLine];
        

        self.backgroundColor = VIEWBACKGROUNDCOLOR;
        
    }
    return self;
}

#pragma mark ----------------------------绑定方法----------------------------------------------

- (void)bingAction:(SEL)action target:(id)target withreceive:(NSString *)receivedStr
{
    if ([receivedStr isEqualToString:@"like"] && likeBtn) {
        if ([likeBtn.allTargets containsObject:target]) {
            [likeBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        likeBtn.userInteractionEnabled = YES;
        [likeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"comment"] && commentBtn){
        if ([commentBtn.allTargets containsObject:target]) {
            [commentBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        commentBtn.userInteractionEnabled = YES;
        [commentBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"share"]){
        if ([shareBtn.allTargets containsObject:target]) {
            [shareBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        shareBtn.userInteractionEnabled = YES;
        [shareBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"url"]){
        if ([urlView.allTargets containsObject:target]) {
            [urlView removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        urlView.userInteractionEnabled = YES;
        [urlView addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }else if ([receivedStr isEqualToString:@"show"]){
        if ([showBtn.allTargets containsObject:target]) {
            [showBtn removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        showBtn.userInteractionEnabled = YES;
        [showBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    
}
- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    likeBtn.tag = tag;
    shareBtn.tag = tag*10;
    urlView.tag = tag *6;
    showBtn.tag = tag *7;
}
#pragma mark ---------------------------- 刷新数据 ----------------------------------------------

- (void)refreshDataFromSquareDataItem:(SquareDataItem *)item status:(UserInfoCellCurrentStatus)status lastItem:(SquareDataItem *)lastItem
{
    if (item) {
        
        if (!item.like_count) {
            item.like_count = 0;
        }
        if (!item.liked) {
            likeBtn.contentLabel.textColor = SquareTextColor;
            likeBtn.leftImgView.image = [UIImage imageNamed:@"icon_square_unliked.png"];
            likeBtn.contentLabel.text = [NSString stringWithFormat:@"赞 %d",item.like_count];
            likeBtn.selected = NO;
        }else{
            likeBtn.selected = YES;
            likeBtn.contentLabel.textColor = SquareLikedColor;
            likeBtn.leftImgView.image = [UIImage imageNamed:@"icon_square_liked.png"];
            likeBtn.contentLabel.text = [NSString stringWithFormat:@"赞 %d",item.like_count];
        }
        
        commentBtn.contentLabel.text = [NSString stringWithFormat:@"%d",item.comment_count];

        _dataSource = item;
        
        
        NSAttributedString *resultTime = [NSString dateTommdd:item.create_time];
        publishDateLabel.attributedText = resultTime;
        NSMutableAttributedString *today =  [[NSMutableAttributedString alloc]initWithString:@"今天" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        if (lastItem == NULL || !lastItem) {
            publishDateLabel.hidden = NO;
            if ([item.userInfo[@"userId"] integerValue] == [[User defaultUser].storeItem.storeId integerValue] && [resultTime isEqual:today]) {
                publishDateLabel.hidden = YES;
            }
            
        }else{
            
            if ([resultTime isEqual:[NSString dateTommdd:lastItem.create_time]]) {
                
                publishDateLabel.hidden = YES;
            }else{
                publishDateLabel.hidden = NO;
            }
            
        }

        acontentView.top = 10;
        
        if ([NSObject nulldata:item.content ]) {
            float titleHeight = [item.content sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(acontentView.width-16, 1000)].height + 10;
            acontentLabel.text = item.content;
            if (titleHeight >= 16*6+20) {
                if (item.isShowPart) {
                    acontentLabel.numberOfLines = 6;
                    acontentLabel.frame = CGRectMake(8,0, acontentView.width-16, 16*6+20);
                    [showBtn setTitle:@"全文" forState:UIControlStateNormal];
                    showBtn.frame = CGRectMake(2, acontentLabel.bottom, 40, 20);
                    showBtn.hidden = NO;
                }else{
                    acontentLabel.numberOfLines = 0;
                    acontentLabel.frame = CGRectMake(8,0, acontentView.width-16, titleHeight);
                    showBtn.frame = CGRectMake(2, acontentLabel.bottom, 40, 20);
                    showBtn.hidden = NO;
                    [showBtn setTitle:@"收起" forState:UIControlStateNormal];
                }
            }else{
                showBtn.hidden = YES;
                showBtn.height = 0;
                acontentLabel.numberOfLines = 0;
                acontentLabel.height = titleHeight;
            }
            
        }else{
            showBtn.hidden = YES;
            showBtn.height = 0;
            acontentLabel.height = 0;
        }
        
//        if (item.type == 3) {
//            
//            photoView.hidden = YES;
//            urlView.hidden = NO;
//            urlView.frame =CGRectMake(8,showBtn.hidden?acontentLabel.bottom+5:showBtn.bottom+5, acontentView.width-16, 64);
//            
//            NSString *imgUrl = nil;
//            if (item.image_urls) {
//                imgUrl = [item.image_urls firstObject];
//            }
//            [urlView setImageValue:imgUrl title:item.title ];
//            
//            likeBtn.top = urlView.bottom+5;
//            commentBtn.top = urlView.bottom+5;
//            shareBtn.top = urlView.bottom+5;
//            acontentView.height = likeBtn.bottom;
//          
//        }else{
        
            photoView.hidden = NO;
            urlView.hidden = YES;
            [photoView setAllImageWithArray:item.image_urls];
            photoView.top = showBtn.hidden?acontentLabel.bottom+5:showBtn.bottom+5;
            if (item.image_urls.count>=1 ) {
                likeBtn.top = photoView.bottom+5;
                commentBtn.top = photoView.bottom+5;
                shareBtn.top = photoView.bottom+5;
            }else{
                likeBtn.top = photoView.top+5;
                commentBtn.top = photoView.top+5;
                shareBtn.top = photoView.top+5;
            }
            acontentView.height = likeBtn.bottom;
//        }
        topSegmentationLine.top = acontentView.bottom - 0.5;
        
        
        if (status == UserInfoCellCurrentStatusLast) {
            leftTopLineView.hidden = NO;
            leftBottomLineView.hidden = YES;
        }else if (status == UserInfoCellCurrentStatusNormal){
            leftTopLineView.hidden = NO;
            leftBottomLineView.hidden = NO;
            leftBottomLineView.height = acontentView.bottom-14;
        }else{
            leftTopLineView.hidden = YES;
            leftBottomLineView.hidden = NO;
            leftBottomLineView.height = acontentView.bottom-14;
        }

    }
    
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    acontentLabel.text = nil;
    publishDateLabel.text = nil;
    
}

@end



#pragma mark ---------------------------- 数据模型 ---------------------------------------------

@implementation SquareDataItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict) {
            _comment_count = 0;

            [self setValuesForKeysWithDictionary:dict];
            if (_comment_count < 1) {
                _comment_count = 0;
            }
            _isShowPart = NO;
            _isV = NO;
            if (_userInfo) {
                _isV = [_userInfo[@"v"]boolValue];
            }
            [self calculateWithCellHeight];
            [self calculateWithUserCellHeight];
            
            if (_userInfo) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_userInfo];
                if ([_userInfo[@"userId"] isEqual:[User defaultUser].item.userId]) {
                    [dict setObject:[User defaultUser].item.avatar forKey:@"avatar"];
                    [dict setObject:[User defaultUser].item.nickname forKey:@"nickname"];
                    _userInfo = dict;
                }else{
                    if ([User defaultUser].followingDict) {
                        NSArray *keyArray = [User defaultUser].followingDict.allKeys;
                        if ([keyArray containsObject:_userInfo[@"userId"]]) {
                            NSString *avatar  = [[[User defaultUser].followingDict objectForKey:_userInfo[@"userId"]]objectForKey:@"avatar"];
                            NSString *nickName = [[[User defaultUser].followingDict objectForKey:_userInfo[@"userId"]]objectForKey:@"nickname"];
                            if ([NSObject nulldata:avatar]) {
                                [dict setObject:[User defaultUser].item.avatar forKey:@"avatar"];
                            }else{
                                [dict removeObjectForKey:@"avatar"];
                            }
                            
                            if ([NSObject nulldata:nickName]) {
                                [dict setObject:nickName forKey:@"nickname"];
                            }else{
                                [dict setObject:@"" forKey:@"nickname"];
                            }
                            _userInfo = dict;
                        }
                    }
                }
            }
            _fromInfo = dict[@"userInfo"];
            
        }
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}


- (void)calculateWithUserCellHeight
{
    _UserInfoCellHeight = 10;
    
    _useContentLabelHeitht = 0;
    
    if ([NSObject nulldata:self.content]) {
        
        _useContentLabelHeitht = [_content sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREENWIDTH-66-16, 1000)].height + 15;
        
        //个人中心
        if (_useContentLabelHeitht >= 111) {
            if (_isShowPart) {
                _UserInfoCellHeight += _useContentLabelHeitht;
                _UserInfoCellHeight+=20; //收起的高度
                _isShowPart = NO;
            }else{
                _UserInfoCellHeight += 111;
                _UserInfoCellHeight+=20; //全文的高度
                _isShowPart = YES;
            }
        }else{
            _isShowPart = NO;
            _UserInfoCellHeight += _useContentLabelHeitht;
        }
        
        
    }else{
        _isShowPart = NO;
    }

    
    if (self.image_urls .count >=1) {
        
        NSInteger imageCount = self.image_urls.count;
        if (imageCount == 1) {
            NSString *firstimg = [_image_urls firstObject];
            float imageHeight = SCREENWIDTH/2;
            if (firstimg) {
                NSString *imgSize = [[firstimg componentsSeparatedByString:@"_"]lastObject];
                if ([imgSize rangeOfString:@"X"].location != NSNotFound) {
                    NSArray *temp = [imgSize componentsSeparatedByString:@"X"];
                    NSString *first = [temp firstObject];
                    NSString *second = [temp lastObject];
                    if ([NSObject nulldata:first ] && [NSObject nulldata:second ]) {
                        
                        if ([[JudgeMethods defaultJudgeMethods]passWordIsPurelyDigital:first] && [[JudgeMethods defaultJudgeMethods]passWordIsPurelyDigital:second]) {
                            CGSize asize;
                            asize.width= [first floatValue];
                            asize.height= [second floatValue];
                            if (asize.width != 0 && asize.height != 0) {
                                float m_width = [ first floatValue];
                                float m_height = [second floatValue];
                                
                                if (m_width > m_height) {
                                    imageHeight = m_height/(m_width/imageHeight);
                                    
                                }else if (m_height == m_width){
                                    imageHeight = imageHeight;
                                    
                                }else{
                                    imageHeight = imageHeight;
                                }
                            }
                        }
                    }
                }
            }
            _UserInfoCellHeight+= imageHeight;
            
        }else if (imageCount>1  && imageCount <= 3){
            _UserInfoCellHeight += (SCREENWIDTH-56-10-24)/3;
        }else if (imageCount >3 && imageCount<= 6){
            _UserInfoCellHeight += (SCREENWIDTH-56-10-24)/3*2+4;
            
        }else{
            _UserInfoCellHeight += (SCREENWIDTH-56-10-24)+8;
            
        }
        _UserInfoCellHeight += 40;
    }else{
        _UserInfoCellHeight += 40;
    }
    
    //    if ([NSObject nulldata:_from]) {
    //        _UserInfoCellHeight = _cellHeight-64+38;
    //    }else{
    //        _UserInfoCellHeight = _cellHeight-64+10;
    //    }
    

}

- (void)calculateWithCellHeight
{
    _cellHeight = 64;
    _ContententLabelHeight = 0;
    
    if ([NSObject nulldata:self.content]) {
        _ContententLabelHeight =  [_content sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(SCREENWIDTH-20, 1000)].height + 15;
        
        //广场
        if (_ContententLabelHeight >= 111) {
            if (_isShowPart) {
                _cellHeight += _ContententLabelHeight;
                _cellHeight+=20; //收起的高度
                _isShowPart = NO;
            }else{
                _cellHeight += 111;
                _cellHeight+=20; //全文的高度
                _isShowPart = YES;
            }
        }else{
            _isShowPart = NO;
            _cellHeight += _ContententLabelHeight;
        }
    
        
    }else{
        _isShowPart = NO;
    }
    
    if (_isV) {
        _cellHeight+=20;
    }
    
//    if (self.type == 3) {
//        _cellHeight+=64;
//        _cellHeight+= 50;
//        if ([NSObject nulldata:_from ]) {
//            _UserInfoCellHeight = _cellHeight-64+38;
//        }else{
//            _UserInfoCellHeight = _cellHeight-64+10;
//        }
//
//        return;
//    }
    
    
    if (self.image_urls .count >=1) {
        
        NSInteger imageCount = self.image_urls.count;
        if (imageCount == 1) {
            NSString *firstimg = [_image_urls firstObject];
            float imageHeight = SCREENWIDTH/2;
            if (firstimg) {
                NSString *imgSize = [[firstimg componentsSeparatedByString:@"_"]lastObject];
                if ([imgSize rangeOfString:@"X"].location != NSNotFound) {
                    NSArray *temp = [imgSize componentsSeparatedByString:@"X"];
                    NSString *first = [temp firstObject];
                    NSString *second = [temp lastObject];
                    if ([NSObject nulldata:first ] && [NSObject nulldata:second ]) {
                        
                        if ([[JudgeMethods defaultJudgeMethods]passWordIsPurelyDigital:first] && [[JudgeMethods defaultJudgeMethods]passWordIsPurelyDigital:second]) {
                            CGSize asize;
                            asize.width= [first floatValue];
                            asize.height= [second floatValue];
                            if (asize.width != 0 && asize.height != 0) {
                                float m_width = [ first floatValue];
                                float m_height = [second floatValue];
                                
                                if (m_width > m_height) {
                                    imageHeight = m_height/(m_width/imageHeight);
                                    
                                }else if (m_height == m_width){
                                    imageHeight = imageHeight;
                                    
                                }else{
                                    imageHeight = imageHeight;
                                }
                            }
                        }
                    }
                }
            }
            _cellHeight += imageHeight;
            
        }else if (imageCount>1  && imageCount <= 3){
            _cellHeight += (SCREENWIDTH-20)/3;
        }else if (imageCount >3 && imageCount<= 6){
            _cellHeight += (SCREENWIDTH-20)/3*2+4;

        }else{
            _cellHeight+= (SCREENWIDTH-20)+8;
            
        }
        _cellHeight += 40;
    }else{
        _cellHeight+= 40;
    }
    
//    if ([NSObject nulldata:_from]) {
//        _UserInfoCellHeight = _cellHeight-64+38;
//    }else{
//        _UserInfoCellHeight = _cellHeight-64+10;
//    }
    
    
}

@end

@implementation SquareUserInfoReleaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *leftLabel = [UILabel labelWithFrame:CGRectMake(5, 20, 30, 40) fontSize:14 fontColor:GRAYTEXTCOLOR text:@"今天"];
        leftLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:leftLabel];
        
        UIView *circelView = [[UIView alloc]initWithFrame:CGRectMake(47-3, 40-3, 6, 6)];
        circelView.backgroundColor = SquareLeftLineColor;
        circelView.clipsToBounds = YES;
        circelView.layer.cornerRadius = 3;
        [self.contentView addSubview:circelView];
        
         _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(47, 40, 1, 120-40)];
        _bottomLineView.backgroundColor = SquareLeftLineColor;
        [self.contentView addSubview:_bottomLineView];
        
        
        _releaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _releaseButton.frame = CGRectMake(56, 0, 82, 82);
        _releaseButton.backgroundColor = [UIColor clearColor];
        _releaseButton.layer.cornerRadius = 41;
        _releaseButton.clipsToBounds = YES;
        [_releaseButton setImage:[UIImage imageNamed:@"icon_square_releateMessage.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_releaseButton];
        self.contentView.backgroundColor = VIEWBACKGROUNDCOLOR;
        
    }
    return self;
}
@end
