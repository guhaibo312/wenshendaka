//
//  HobbyCircleViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/8/14.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "HobbyCircleViewController.h"
#import "JWTabItemButton.h"
#import "SquareObject.h"
#import "AllCircleViewController.h"
#import "AdvertisingScrollView.h"
#import "UserNoticeViewController.h"
#import "StoreInfoSettingsViewController.h"
#import "UIScrollView+JWRefresh.h"
#import "CreateSquareMessageViewController.h"

@interface HobbyCircleViewController ()
{
    UIView *topview;
    SquareObject *_square;
    UIButton *messagePrmptView;
    AdvertisingScrollView *adview;
}

@property (nonatomic, retain) UIButton *releaseBtn;

@property (nonatomic, assign) float viewHeight;

@end

@implementation HobbyCircleViewController

- (id)initWithQuery:(NSDictionary *)query
{
    self = [super initWithQuery:query];
    if (self) {
        if (query) {
            _viewHeight = [query[@"viewHeight"]floatValue];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (adview) {
        [adview start];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (adview) {
        [adview stop];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewHeight = SCREENHEIGHT-64;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutSublayersOfView];
    
    [self setUpCamera];
    
}

- (void)setUpCamera
{
    UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat releaseBtnW = 50;
    
    releaseBtn.frame = CGRectMake(self.view.width - releaseBtnW - 10, SCREENHEIGHT - releaseBtnW  - 124, releaseBtnW, releaseBtnW);
    releaseBtn.backgroundColor = [UIColor clearColor];
    [releaseBtn setImage:[UIImage imageNamed:@"icon_tab_release.png"] forState:UIControlStateNormal];
    [releaseBtn addTarget:self action:@selector(createFeedFunction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseBtn];

}

- (void)createFeedFunction:(UIButton *)sender
{
    
    CreateSquareMessageViewController *createMessageVC = [[CreateSquareMessageViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:createMessageVC];
    [self presentViewController:navigation animated:YES completion:NULL];
}

- (void)requestHaveNewMessage:(NSNotification *)notication
{
    
    NSNumber *created = @(0);
    NSNumber *lasetNum = [[NSUserDefaults standardUserDefaults]objectForKey:homeLastMessageCreated];
    if (lasetNum) {
        created = lasetNum ;
    }
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    [parm setObject:created forKey:@"latest_created"];
    [parm setObject:@(100) forKey:@"limit"];
    [parm setObject:@(-1) forKey:@"order"];
    
    [[JWNetClient defaultJWNetClient]squareGet:@"/notice" requestParm:parm result:^(id responObject, NSString *errmsg) {
        [LoadingView dismiss];
        if (!self) return ;
        if (!errmsg) {
            
            NSArray *resultArray = responObject[@"data"];
            if (resultArray.count >=1) {
                messagePrmptView  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-50, 36)];
                
                [messagePrmptView addTarget:self action:@selector(pushToMessageCenter:) forControlEvents:UIControlEventTouchUpInside];
                [messagePrmptView setTitle:[NSString stringWithFormat:@"%lu条动态通知",(unsigned long)resultArray.count] forState:UIControlStateNormal];
                messagePrmptView.titleLabel.font = [UIFont systemFontOfSize:14];
                [messagePrmptView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                messagePrmptView.backgroundColor = SMALLBUTTONCOLOR;
                messagePrmptView.clipsToBounds = YES;
                messagePrmptView.layer.cornerRadius = 5;
                _square.firstHeaderNoticeView = messagePrmptView;
                [_square.listTable reloadData];

            }
        }
    }];
}

#pragma mark -- 消息列表
- (void)pushToMessageCenter:(id )sender
{
    if (messagePrmptView) {
        [messagePrmptView removeFromSuperview];
        messagePrmptView = nil;
    }
    _square.firstHeaderNoticeView = nil;
    [_square.listTable reloadData];

    
    [JudgeMethods defaultJudgeMethods].showSquareNotice = NO;
    UserNoticeViewController *userMessagevc = [[UserNoticeViewController alloc]initWithQuery:@{@"newmessage":@YES}];
    [self.navigationController pushViewController:userMessagevc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [LoadingView dismiss];
    
    if (self) {
        if (adview) {
            [adview deleteAll];
        }
        if (_square) {
            [_square clearMemoryCache];
        }
    }
    
    if (self.view.subviews) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _square = nil;
}


- (void)layoutSublayersOfView
{
    _square = [[SquareObject alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _viewHeight) ownerController:self withSupView:self.view style:ListTableStyleSquarelist];
    if ([User defaultUser].squareBanner != NULL  && [[User defaultUser].squareBanner isKindOfClass:[NSArray class]]) {
        if ([User defaultUser].squareBanner.count > 0) {
            adview = [[AdvertisingScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/5*2) ownerController:self isAuto:YES array:[User defaultUser].squareBanner];
            adview.backgroundColor = RGBCOLOR(115, 193., 188.);
            _square.listTable.tableHeaderView = adview;
        }
    }
    _square.sector = @"30";
    [_square setupRefresh];
    

    [self requestHaveNewMessage:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestHaveNewMessage:) name:kPushNotication object:nil];
    
    topview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    topview.backgroundColor = [UIColor clearColor];
    
   JWTabItemButton * circleButton = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(SCREENWIDTH/2/3, 0, SCREENWIDTH/3 , 44) withTitle:@"热门" normalTextColor:[UIColor whiteColor] needBottomView:YES];
    circleButton.backgroundColor = SEGMENTNORMAL;
    circleButton.selected = YES;
    circleButton.backgroundColor = [UIColor clearColor];
    circleButton.tag = 50;
    [circleButton addTarget:self action:@selector(clickCircleAndCityAction:) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:circleButton];
    
    JWTabItemButton * cityButton = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/3 , 44) withTitle:@"关注" normalTextColor:[UIColor whiteColor] needBottomView:YES];
    cityButton.backgroundColor = SEGMENTNORMAL;
    cityButton.backgroundColor = [UIColor clearColor];
    cityButton.tag = 60;
    [cityButton addTarget:self action:@selector(clickCircleAndCityAction:) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:cityButton];
    
    self.navigationItem.titleView = topview;
    
}

#pragma mark -- 切换
- (void)clickCircleAndCityAction:(JWTabItemButton *)sender
{
    if (sender.tag == 50) {
        if (_square) {
            _square.apiHost = nil;
            [_square.listTable headerBeginRefreshing];
        }
        sender.selected = YES;
        JWTabItemButton *cityItem = (JWTabItemButton *)[topview viewWithTag:60];
        if (cityItem) cityItem.selected = NO;
        
    }else{
        if (_square) {
            _square.apiHost = @"/feeds/inbox";
            [_square.listTable headerBeginRefreshing];
        }
        sender.selected = YES;
        JWTabItemButton *circleItem = (JWTabItemButton *)[topview viewWithTag:50];
        if (circleItem) {
            circleItem.selected = NO;
        }
    }
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
