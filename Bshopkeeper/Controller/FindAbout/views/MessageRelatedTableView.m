//
//  MessageRelatedTableView.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/12.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "MessageRelatedTableView.h"
#import "Configurations.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"
#import "UIScrollView+JWRefresh.h"
#import "SquareInfoDetailViewController.h"
#import "SquareUserPageViewController.h"

@interface MessageRelatedTableView ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isNothingMore;
    
    NSMutableDictionary *parm;
}

@property (nonatomic, strong)   NSMutableArray *anoticeArray;

@property (nonatomic, strong)   NSMutableArray *dataArray;

@property (nonatomic, assign)   BOOL showNewMessage;

@end

static  NSString *MessageCellIdentifier = @"MessageCellIdentifier";

@implementation MessageRelatedTableView


- (instancetype)initWithFrame:(CGRect)frame withOwner:(UIViewController *)ownerVC isReceiveNotice:(BOOL)received
{
    self = [super initWithFrame:frame];
    if (self) {
        _showNewMessage = received;
        _supVC = ownerVC;
        _anoticeArray = [[NSMutableArray alloc]init];
        _dataArray = [NSMutableArray array];
        parm = [NSMutableDictionary dictionary];
        [parm setObject:@(20) forKey:@"limit"];
        self.delegate = self;
        self.dataSource = self;
        UIView *footView = [[UIView alloc]init];
        footView.backgroundColor = [UIColor whiteColor];
        self.tableFooterView = footView;
        if (!_showNewMessage) {
            [self addRereshAndLoadMoreFunciton];
        }
        [self headerRereshing];
        
        _messageCount = 0;
    }
    return self;
}

- (void)addRereshAndLoadMoreFunciton
{
    __unsafe_unretained typeof(self) vc = self;
    [self addFooterWithCallback:^{
        if (vc) {
            [vc footerRereshing];
        }
    }];
    
}


//刷新
- (void)headerRereshing
{
    [LoadingView show:@"请稍候..."];
    [parm removeAllObjects];
    

    NSNumber *number = [[NSUserDefaults standardUserDefaults]objectForKey:homeLastMessageCreated];
    
    if (_showNewMessage) {
        if (number) {
            [parm setObject:number forKey:@"latest_created"];
        }
        [parm setObject:@(100) forKey:@"limit"];
        [parm setObject:@(-1) forKey:@"order"];
    }else{
        [parm setObject:@(20) forKey:@"limit"];
    }
    if (!_showNewMessage && _anoticeArray.count>0) {
        MessageReleaseObject *item = [_dataArray lastObject];
        if (item) {
            [parm setObject:@(item.created) forKey:@"latest_created"];
        }
    }
    [self requestNewMessage];
    self.userInteractionEnabled = NO;
    
}

//加载
- (void)footerRereshing
{
    if (_isNothingMore && !_showNewMessage) {
        [SVProgressHUD showErrorWithStatus:@"已经没有更多数据了！"];
        [self headerEndRefreshing];
        [self footerEndRefreshing];
        return;
    }
    [LoadingView show:@"加载中...."];
    MessageReleaseObject *item = [_dataArray lastObject];
    if (item) {
        if (item.created) {
            [parm setObject:@(item.created) forKey:@"latest_created"];
        }
    }
    self.userInteractionEnabled = NO;
    [self requestNewMessage];

}

- (void)requestNewMessage
{
    
    [[JWNetClient defaultJWNetClient]squareGet:@"/notice" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        self.userInteractionEnabled = YES;
        _messageCount = 0;
        
        if (!errmsg) {
            
            NSArray *resultArray = responObject[@"data"];
            
            if (resultArray) {
        
                NSMutableArray *tempArray = [NSMutableArray array];
                
                for (int i = 0 ;i< resultArray.count  ; i++) {
                    
                    MessageReleaseObject *oneObject = [[MessageReleaseObject alloc]initWithDict:resultArray[i]];
                    if (_showNewMessage) {
                        [_anoticeArray addObject:oneObject];
                    }else{
                        [tempArray addObject:oneObject];
                    }
                }
                if (_showNewMessage) {
                    [_dataArray addObjectsFromArray:_anoticeArray];
                    _messageCount = _dataArray.count;
                    
                }else{
                    [_dataArray addObjectsFromArray:tempArray];
                }
                
                if (resultArray.count<20) {
                    _isNothingMore = YES;
                }else{
                    _isNothingMore = NO;
                }
            }
            
            MessageReleaseObject *one = [_dataArray firstObject];
            if (one) {
                [[NSUserDefaults standardUserDefaults]setObject:@(one.created) forKey:homeLastMessageCreated];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [self headerEndRefreshing];
            [self footerEndRefreshing];
            if (_countBlock) {
                _countBlock(_messageCount);
            }
            [self reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_showNewMessage) {
        return _dataArray.count+1;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showNewMessage && indexPath.row == _dataArray.count ) {
        return 44;
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showNewMessage && indexPath.row == _dataArray.count) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lastIdentifier"];
        cell.textLabel.text = @"点击查看更多消息";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = GRAYTEXTCOLOR;
        return cell;
        
    }
    MessageReleaseCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier];
    if (!cell) {
        cell = [[MessageReleaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MessageCellIdentifier];
    }
    [cell refreshDataFrom:_dataArray[indexPath.row] withTarget:_supVC];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showNewMessage && indexPath.row == _dataArray.count) {
        _showNewMessage = NO;
        [self addRereshAndLoadMoreFunciton];
        [self headerRereshing];
        return;
    }
    if (_countBlock) {
        _countBlock (0);
    }
    
    __block MessageReleaseObject *oneMessage = [_dataArray objectAtIndex:indexPath.row];
    if (oneMessage) {
        [[JWNetClient defaultJWNetClient]squarePost:@"/notice/read" requestParm:@{@"_id":oneMessage._id} result:^(id responObject, NSString *errmsg) {
            if (self && oneMessage && !errmsg) {
                oneMessage.read = YES;
                [self reloadData];
            }
        }];
        if (!oneMessage.feed[@"_id"]) {
            return;
        }
        SquareInfoDetailViewController *detailVC = [[SquareInfoDetailViewController alloc]initWithQuery:@{@"feedId":oneMessage.feed[@"_id"]}];
        [_supVC.navigationController pushViewController:detailVC animated:YES];
        
    }
}

@end

@implementation MessageReleaseObject

- (instancetype)initWithDict:(NSMutableDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict) {
            [self setValuesForKeysWithDictionary:dict];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end


@implementation MessageReleaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        readLabel = [UILabel labelWithFrame:CGRectMake(7, 20, 6, 6) fontSize:14 fontColor:[UIColor blackColor] text:@""];
        readLabel.layer.cornerRadius = 3;
        readLabel.backgroundColor = [UIColor redColor];
        readLabel.clipsToBounds = YES;
        [self.contentView addSubview:readLabel];
        
        userAvatarView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
        userAvatarView.layer.cornerRadius = 20;
        userAvatarView.clipsToBounds = YES;
        UITapGestureRecognizer *tapUserAvatar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToUserInfoPage:)];
        userAvatarView.userInteractionEnabled = YES;
        [userAvatarView addGestureRecognizer:tapUserAvatar];
        userAvatarView.image = [UIImage imageNamed:@"icon_userHead_default.png"];
        [self.contentView addSubview:userAvatarView];
        
        userNameLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(userAvatarView.right+10, 10, SCREENWIDTH-userAvatarView.right-80, 20)];
        userNameLabel.font = [UIFont systemFontOfSize:16];
        
        NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
        [mutableLinkAttributes setValue:(id)[SquareLinkColor CGColor] forKey:(NSString*)kCTForegroundColorAttributeName];
        [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        userNameLabel.linkAttributes = [NSDictionary dictionaryWithDictionary:mutableLinkAttributes];
        userNameLabel.userInteractionEnabled = YES;
        userNameLabel.delegate = self;
        userNameLabel.backgroundColor = [UIColor clearColor];
        userNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:userNameLabel];
        
        
        contentLabel = [UILabel labelWithFrame:CGRectMake(userAvatarView.right+10, userNameLabel.bottom, SCREENWIDTH-userAvatarView.right-80, 18) fontSize:12 fontColor:[UIColor blackColor] text:@""];
        [self.contentView addSubview:contentLabel];
        
        
        
        timeLabel = [UILabel labelWithFrame:CGRectMake(userAvatarView.right+10, contentLabel.bottom + 5, 120, 18) fontSize:12 fontColor:GRAYTEXTCOLOR text:@""];
        [self.contentView addSubview:timeLabel];
        
        contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 10, 40, 40)];
        contentImageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentImageView];
        
    }
    return self;
}

- (void)refreshDataFrom:(MessageReleaseObject *)object withTarget:(UIViewController *)target
{
    
    if (!object) {
        return;
    }
    _owner = target;
    readLabel.hidden = object.read;
    if (_dataObject ) {
        if (_dataObject == object) {
            return;
        }
    }
    _dataObject = object;
    if (object.userInfo) {
        NSString *headUrl = object.userInfo[@"avatar"];
        if ([NSObject nulldata:headUrl]) {
            [userAvatarView sd_setImageWithURL:[NSURL URLWithString:[headUrl getQiNiuImgWithWidth:100]] placeholderImage:[UIImage imageNamed:@"icon_userHead_default.png"]];
        }
        NSString *promptTitle = @"\t赞了你";
        if (object.type == 1) {
            promptTitle = @"\t赞了你";
        }else if(object.type == 2){
            promptTitle = @"\t评论了你";
        }else if (object.type == 4){
            promptTitle = @"\t回复了你";
        }
        if ([NSObject nulldata:object.userInfo[@"nickname"]]) {
            NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc]init];
            [contentText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:object.userInfo[@"nickname"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName :SquareLinkColor}]];
            if ([NSObject nulldata:promptTitle]) {
                 [contentText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:promptTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName :[UIColor blackColor]}]];
            }
            userNameLabel.text = [NSString stringWithFormat:@"%@/t%@",object.userInfo[@"nickname"],promptTitle];
            [userNameLabel setAttributedText:contentText];
            
            [userNameLabel addLinkToPhoneNumber:object.userInfo[@"nickname"] withRange:[userNameLabel.text rangeOfString:object.userInfo[@"nickname"]]];
            
        }
        
    }
    if ([NSObject nulldata:object.content]) {
        contentLabel.text = [NSString stringWithFormat:@"“%@”",object.content];
    }
    
    if (object.created >0) {
        timeLabel.text = [NSString stringWithDate:[NSDate dateWithTimeIntervalSince1970:object.created>9999999999?object.created/1000:object.created]];
    }
    
    contentImageView.hidden = YES;
    if (object.feed) {
        if ([object.feed[@"image_urls"] count]>=1) {
            NSString *url = [object.feed[@"image_urls"] firstObject];
            if ([NSObject nulldata:url]) {
                contentImageView.hidden = NO;
                [contentImageView sd_setImageWithURL:[NSURL URLWithString:[url getQiNiuImgWithWidth:100]]];
            }
        }
    }
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    [self pushToUserInfoPage:nil];
  
}

- (void)pushToUserInfoPage:(id)sender
{
    if (self == NULL || _owner == NULL || !_dataObject) return;
    NSString *userId = _dataObject.userInfo[@"userId"];
    if (userId) {
        SquareUserPageViewController *userPageVC = [[SquareUserPageViewController alloc]initWithQuery:@{@"userId":userId}];
        [_owner.navigationController pushViewController:userPageVC animated:YES];
    }
}

@end


