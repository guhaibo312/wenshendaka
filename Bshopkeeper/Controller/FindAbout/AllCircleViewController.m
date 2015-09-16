//
//  AllCircleViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AllCircleViewController.h"
#import "UserNoticeViewController.h"
#import "CreateSquareMessageViewController.h"
#import "UIScrollView+JWRefresh.h"
#import "SquareObject.h"
#import "MobClick.h"
#import "JWEvent.h"
#import "UIImageView+WebCache.h"
#import "JWTabItemButton.h"
#import "AdvertisingScrollView.h"

@interface AllCircleViewController ()
{
    SquareObject *_square;
    UIButton *messagePrmptView;
    AdvertisingScrollView *adview;
    UIView *topview;
}

@property (nonatomic, retain) UIButton *releaseBtn;

@property (nonatomic, assign) float viewHeight;
@end

@implementation AllCircleViewController

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
- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewHeight = SCREENHEIGHT-64;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BOOL needAnimation = [[NSUserDefaults standardUserDefaults]boolForKey:SquareReleaseAnimation];
    if (!needAnimation) {
        [self shakeAnimation];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SquareReleaseAnimation];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _square = [[SquareObject alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _viewHeight) ownerController:self withSupView:self.view style:ListTableStyleSquarelist];
    
    if ([[User defaultUser].item.sector integerValue] == 30) {
        _releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat releaseBtnW = 50;
        
        _releaseBtn.frame = CGRectMake(self.view.width - releaseBtnW - 10, SCREENHEIGHT - releaseBtnW  - 70, releaseBtnW, releaseBtnW);
        
        _releaseBtn.backgroundColor = [UIColor clearColor];
        [_releaseBtn setImage:[UIImage imageNamed:@"icon_tab_release.png"] forState:UIControlStateNormal];
        UIPanGestureRecognizer *panReleaseBtn = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerWithReleaseBtn:)];
        [_releaseBtn addGestureRecognizer:panReleaseBtn];
        
        [_releaseBtn addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_releaseBtn];
    }
    
    
     if ([User defaultUser].squareBanner != NULL  && [[User defaultUser].squareBanner isKindOfClass:[NSArray class]]) {
        if ([User defaultUser].squareBanner.count >0) {
            adview = [[AdvertisingScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/5*2) ownerController:self isAuto:YES array:[User defaultUser].squareBanner];
            adview.backgroundColor = RGBCOLOR(115, 193., 188.);
            _square.listTable.tableHeaderView = adview;
        }
    }
    _square.sector = @"30";
    [_square setupRefresh];

    topview = [[UIView alloc] init];
    topview.width = 200;
    topview.y = 0;
    topview.height = 44;
    topview.backgroundColor = [UIColor clearColor];
    
    
    JWTabItemButton * circleButton = [[JWTabItemButton  alloc]initWithFrame:CGRectMake( -40, 0, 100 , 44) withTitle:@"热门" normalTextColor:[UIColor whiteColor] needBottomView:YES];
    circleButton.backgroundColor = SEGMENTNORMAL;
    circleButton.selected = YES;
    circleButton.backgroundColor = [UIColor clearColor];
    circleButton.tag = 50;
    [circleButton addTarget:self action:@selector(clickCircleAndCityAction:) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:circleButton];
    
    JWTabItemButton * cityButton = [[JWTabItemButton  alloc]initWithFrame:CGRectMake(CGRectGetMaxX(circleButton.frame) - 30, 0, 100 , 44) withTitle:@"关注" normalTextColor:[UIColor whiteColor] needBottomView:YES];
    cityButton.backgroundColor = SEGMENTNORMAL;
    cityButton.backgroundColor = [UIColor clearColor];
    cityButton.tag = 60;
    [cityButton addTarget:self action:@selector(clickCircleAndCityAction:) forControlEvents:UIControlEventTouchUpInside];
    [topview addSubview:cityButton];
    
    self.navigationItem.titleView = topview;

    [self requestHaveNewMessage:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestHaveNewMessage:) name:kPushNotication object:nil];
    
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


#pragma mark -- 消息列表
- (void)pushToMessageCenter:(id)sender
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
    NSString *key = [ NSString stringWithFormat:@"%f+%@",[[NSDate date] timeIntervalSince1970],[User defaultUser].storeItem.storeId];
    if ([[User defaultUser].item.sector integerValue] == 30) {

        NSString *number1 = [NSString stringWithFormat:@"+%d",[JWEvent defaultJWEvent].tattooCircleTimesOfOnce];
        NSString *number2 = [NSString stringWithFormat:@"+%d",[JWEvent defaultJWEvent].tattooUrlTimesOfonce];
        [MobClick event:@"30_count_click_feed" attributes:@{@"number":number1,@"key":key}];
        [MobClick event:@"30_count_click_feed_url" attributes:@{@"number":number2,@"key":key}];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [LoadingView dismiss];
    
    if (self) {
        
        if (adview) {
            [adview deleteAll];
        }
        if (_square) {
            if (_square.listTable) {
                _square.listTable.tableHeaderView = nil;
                _square.listTable = nil;
            }
            [_square clearMemoryCache];
        }
    }
    if (self.view.subviews) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightNavigationBarAction:(UIButton *)sender
{
    CreateSquareMessageViewController *createMessageVC = [[CreateSquareMessageViewController alloc]init];
    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:createMessageVC];
    [self presentViewController:navigation animated:YES completion:NULL];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    _square = nil;
}

/** 拖拽发布🔘
 */
- (void)panGestureRecognizerWithReleaseBtn:(UIPanGestureRecognizer *)pan
{
    if (pan.state  == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded || pan
        .state == UIGestureRecognizerStateFailed) {
        CGPoint location = [pan locationInView:pan.view.superview];
        if (location.x <51) {
            location.x = 51;
        }else if (location.x > SCREENWIDTH-51){
            location.x = SCREENWIDTH-51;
        }
        if (location.y < 51) {
            location.y = 51;
        }else if(location.y > SCREENHEIGHT-64-51){
            location.y = SCREENHEIGHT-64-51;
        }
        pan.view.center = location;
    }
}

- (void)shakeAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath  = @"position.x";
    animation.values   = @[ @0, @15, @-15, @15, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.3;
    animation.additive = YES;
    animation.repeatCount = 2;
    [_releaseBtn.layer addAnimation:animation forKey:@"shake"];
}
@end

