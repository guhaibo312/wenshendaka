//
//  SquareUserPageViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/6/4.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "SquareUserPageViewController.h"
#import "H5PreviewManageViewController.h"
#import "UserNoticeViewController.h"
#import "JWChatDetailViewController.h"
#import "SquareUserPageHead.h"
#import "Finelist.h"
#import "SquareObject.h"
#import "UserHomeBtn.h"
#import "JWChatDataManager.h"

@interface SquareUserPageViewController ()
{
    SquareUserPageHead *userHeadView;
    UIButton * _userMessageButton;
    UILabel *atitleLabel;
    UIView *bottomView;
}
@property (nonatomic, strong)    SquareObject *tableList;
@property (nonatomic, strong) NSString *currentuserId;
@property (nonatomic, strong) UIView *topNavigationView;

@end

@implementation SquareUserPageViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _currentuserId = [query objectForKey:@"userId"];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

    if (_currentuserId == NULL) {
        _currentuserId = [User defaultUser].item.userId;
    }
    
    
    [self layoutSubviews];
    [self requestUserInfomation];
}

- (void)layoutSubviews
{

    userHeadView = [[SquareUserPageHead alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 250) withOwnerController:self];

    _tableList = [[SquareObject alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) ownerController:self withSupView:self.view style:ListTableStyleUserPageList];
    _tableList.listTable.backgroundColor = VIEWBACKGROUNDCOLOR;
    _tableList.listTable.tableHeaderView = userHeadView;
    _tableList.userPageId = [NSString stringWithFormat:@"%@",_currentuserId];
    _tableList.listTable.hidden = YES;

    
    _topNavigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    _topNavigationView.backgroundColor = [UIColor clearColor];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 24, 40, 40)];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 20);
    leftBtn.showsTouchWhenHighlighted = NO;
    [leftBtn setImage:[UIImage imageNamed:@"back_img_white.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_topNavigationView addSubview:leftBtn];
    
    _userMessageButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 24, 50, 40)];
    [_userMessageButton setImage:[UIImage imageNamed:@"icon_square_usermessage.png"] forState:UIControlStateNormal];
    _userMessageButton.backgroundColor = [UIColor clearColor];
    _userMessageButton.imageEdgeInsets = UIEdgeInsetsMake(6, 2, 6, 12);
    [_userMessageButton addTarget:self action:@selector(pushToUserNoticeController:) forControlEvents:UIControlEventTouchUpInside];
    _userMessageButton.hidden = YES;
    [_topNavigationView addSubview:_userMessageButton];

    atitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 24, SCREENWIDTH-80, 40)];
    [atitleLabel setTextAlignment:1];
    atitleLabel.textColor = [UIColor whiteColor];
    atitleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    atitleLabel.backgroundColor = [UIColor clearColor];
    [_topNavigationView addSubview:atitleLabel];
    [self.view addSubview:_topNavigationView];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.hidden = YES;
    [self.view addSubview:bottomView];
    
    [self addObserver:self forKeyPath:@"tableList.listTable.contentOffset" options:0x01 context:nil];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"tableList.listTable.contentOffset"]) {
        if (_tableList.listTable.contentOffset.y >=0 && _tableList.listTable.contentOffset.y< 64) {
            
            _topNavigationView.backgroundColor = RGBACOLOR(54., 50., 49.,_tableList.listTable.contentOffset.y/64);
        }else if (_tableList.listTable.contentOffset.y>=64){
            _topNavigationView.backgroundColor = RGBACOLOR(54., 50., 49., 1);
        }else{
            _topNavigationView.backgroundColor = RGBACOLOR(54., 50., 49., 0);
        }
    }
}


- (void)backAction
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self removeObserver:self forKeyPath:@"tableList.listTable.contentOffset"];
    if (_tableList) {
        [_tableList clearMemoryCache];
        _tableList = nil;
    }
    [super backAction];
}

#pragma mark ---- 打开消息
- (void)pushToUserNoticeController:(UIButton *)sender
{
    
    UserNoticeViewController *noticeController = [[UserNoticeViewController alloc]initWithQuery:nil];
    [self.navigationController pushViewController:noticeController animated:YES];
    
}



- (void)requestUserInfomation
{
   
    __weak __typeof(self)weakSelf = self;
    
    [[JWNetClient defaultJWNetClient]squareGet:@"/users" requestParm:@{@"userId":_currentuserId} result:^(id responObject, NSString *errmsg) {
        if (weakSelf == NULL)return ;
        if (errmsg) {
            [SVProgressHUD showErrorWithStatus:errmsg];
        }else{
            [weakSelf requestFinishFunciton:responObject];
        }
    }];
}

- (void)requestFinishFunciton:(NSDictionary *)responObject
{
    self.tableList.listTable.hidden = NO;
    NSDictionary *result = responObject[@"data"];
    if (result) {
        
        [[JWChatDataManager sharedManager]saveUserToLocal:result];
        
        [userHeadView setDataFrom:result];
        if ([NSObject nulldata:result[@"nickname"]]) {
            atitleLabel.text = result[@"nickname"];
        }
        NSString *currentUserId = result[@"userId"];
        [self resetBottomView:result];
        if ([currentUserId integerValue] == [[User defaultUser].storeItem.storeId integerValue] ) {
            _userMessageButton.hidden = NO;
        }else{
            _userMessageButton.hidden = YES;
        }
        
    }
    self.tableList.userPageInfo = [NSDictionary dictionaryWithDictionary:result];
    [_tableList setupRefresh];
}

- (void)resetBottomView:(NSDictionary *)parm;
{
    if (bottomView) {
        if (bottomView.subviews) {
            [bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        bottomView.hidden = NO;
    }
    if (parm) {
        if ([parm[@"sector"]integerValue] != 30) {
            UIButton *sendMessage = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
            sendMessage.backgroundColor = SMALLBUTTONCOLOR;
            [sendMessage setTitle:@"私聊" forState:UIControlStateNormal];
            sendMessage.titleLabel.font = [UIFont systemFontOfSize:14];
            [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sendMessage addTarget:self action:@selector(sendMessageFunciton:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:sendMessage];
            
            bottomView.hidden = YES;
            _tableList.listTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        }else{
            UIButton *sendMessage;
            if (![User defaultUser].cannotChat) {
                sendMessage = [[UIButton alloc]initWithFrame:CGRectMake(15, 5, SCREENWIDTH/2-30, 30)];
                sendMessage.backgroundColor = SMALLBUTTONCOLOR;
                [sendMessage setTitle:@"私聊" forState:UIControlStateNormal];
                sendMessage.titleLabel.font = [UIFont systemFontOfSize:14];
                sendMessage.layer.cornerRadius = 8;
                sendMessage.clipsToBounds = YES;
                [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [sendMessage addTarget:self action:@selector(sendMessageFunciton:) forControlEvents:UIControlEventTouchUpInside];
                [bottomView addSubview:sendMessage];
            }
            
            bottomView.hidden = NO;
            
            UserHomeBtn *openWgwButton = [[UserHomeBtn alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/2, 40) text:@"进入微名片" imageName:@"icon_user_wmp.png"];
            openWgwButton.desIamgeView.frame = CGRectMake(0, 10, 20, 20);
            openWgwButton.nameLabel.frame = CGRectMake(openWgwButton.desIamgeView.right+10, 0, SCREENWIDTH/2, 40);
            [openWgwButton addTarget: self action:@selector(pushToUserhome:) forControlEvents:UIControlEventTouchUpInside];
            openWgwButton.nameLabel.font = [UIFont systemFontOfSize:16];
            openWgwButton.nameLabel.textColor = GRAYTEXTCOLOR;
            openWgwButton.nameLabel.textAlignment = NSTextAlignmentLeft;
            
            UIImageView *point = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-25, 10, 20, 20)];
            point.image = [UIImage imageNamed:@"icon_user_wmp_open.png"];
            [bottomView addSubview:openWgwButton];
            [bottomView addSubview:point];
            
            if (!sendMessage) {
                openWgwButton.left = SCREENWIDTH/2-30;
            }
            _tableList.listTable.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40);

            
        }
    }
}

#pragma mark -- 私聊
- (void)sendMessageFunciton:(id)sender
{
    JWChatDetailViewController *chatDetail = [[JWChatDetailViewController alloc]initWithQuery:@{@"id":_currentuserId}];
    [self.navigationController pushViewController:chatDetail animated:YES];
}


#pragma mark -- 微名片

- (void)pushToUserhome:(id)sender
{
    if (_currentuserId) {
        NSString *url = API_SHAREURL_STORE(_currentuserId);
        
        if (self) {
            H5PreviewManageViewController *h5VC = [[H5PreviewManageViewController alloc]initWithQuery:@{@"urlStr":url}];
            [self.navigationController pushViewController:h5VC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
