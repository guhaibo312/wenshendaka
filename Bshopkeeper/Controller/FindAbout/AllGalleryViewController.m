//
//  AllGalleryViewController.m
//  Bshopkeeper
//
//  Created by jinwei on 15/7/11.
//  Copyright (c) 2015年 jinwei. All rights reserved.
//

#import "AllGalleryViewController.h"
#import "Finelist.h"
#import "AdvertisingScrollView.h"
#import "SquareInfoDetailHead.h"
#import "CommodityTagViewController.h"
#import "SquareObject.h"
#import "MobClick.h"
#import "JWEvent.h"
#import "JWMessagePointButton.h"
#import "SystemNoticeViewController.h"
#import "RecommendCell.h"
#import "SpecialController.h"

@interface AllGalleryViewController ()<SelectedCommodityDelegate,UITableViewDataSource,UITableViewDelegate>
{
    Finelist *_list;
    
    SquareInfoDetailTag *tagView;
    
    UIView *headView;
    
    AdvertisingScrollView *adview;
    
    NSString *currentCommodityTag;              //当前标签
    

}
@property (nonatomic , strong)    JWMessagePointButton *messageButton;


@property (nonatomic, assign) float viewHeight;

@property (nonatomic,strong) UITableView *recommendView;

@end

@implementation AllGalleryViewController

- (UITableView *)recommendView
{
    if (!_recommendView) {
        self.recommendView = [[UITableView alloc] init];
        self.recommendView.x = self.recommendView.y = 0;
        self.recommendView.width = self.view.width;
        self.recommendView.height = 150 * 10 + SCREENWIDTH / 5 * 2 + 40;
        self.recommendView.dataSource = self;
        self.recommendView.delegate = self;
        self.recommendView.scrollEnabled = NO;
        self.recommendView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _recommendView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCell *cell = [RecommendCell recommendCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialController *speVc = [[SpecialController alloc] init];
    [self.navigationController pushViewController:speVc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestHaveNewMessage];

    if (adview) {
        [adview start];
    }
}


- (void)requestHaveNewMessage
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
                [JudgeMethods defaultJudgeMethods].showSquareNotice = YES;
            }
        }
        [self showAboutNotice:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (adview) {
        [adview stop];
    }
}

#pragma mark-- 展示新消息
- (void)showAboutNotice:(NSNotification *)notication
{
    
        //系统消息
        if ([JudgeMethods defaultJudgeMethods].showSystemNotice || [JudgeMethods defaultJudgeMethods].showSquareNotice || [JudgeMethods defaultJudgeMethods].showimageNotice) {
            self.messageButton.messageLabel.hidden = NO;
        }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.title) {
        self.title = @"精品推荐";
    }
    
    if ([[User defaultUser].item.sector integerValue]!= 30) {
        self.messageButton = [[JWMessagePointButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40) BackImage:[UIImage imageNamed:@"icon_system_messages.png"]];
        
        [_messageButton addTarget:self action:@selector(rightNavigationBarAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.messageButton];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAboutNotice:) name:kPushNotication object:nil];
    }
  
    
    _list = [[Finelist alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, _viewHeight) ownerController:self supView:self.view];
    _list.sector = @"30";
    
    headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
//    headView.backgroundColor = VIEWBACKGROUNDCOLOR;
    headView.backgroundColor = [UIColor redColor];
    
    if ([User defaultUser].galleryBanner && [[User defaultUser].galleryBanner isKindOfClass:[NSArray class]]) {
        if ([User defaultUser].galleryBanner.count >0) {
            headView.height = SCREENWIDTH/5*2+50;
            adview = [[AdvertisingScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/5*2) ownerController:self isAuto:YES array:[User defaultUser].galleryBanner];
            adview.backgroundColor = RGBCOLOR(115, 193., 188.);
//            [headView addSubview:adview];
            self.recommendView.tableHeaderView = adview;
        }
    }
    
    tagView = [[SquareInfoDetailTag alloc]initWithFrame:CGRectMake(0, headView.height-45, SCREENWIDTH, 40) withTag:@"全部"];
    [tagView bingClickFuncitonTarget:self action:@selector(selectTags:)];
//    [headView addSubview:tagView];
    self.recommendView.tableFooterView = tagView;
    
//    _list.headView = headView;
    _list.headView = self.recommendView;
    [_list setupRefresh];
}



- (void)rightNavigationBarAction:(UIButton *)sender
{
    
    BOOL newMessage = [JudgeMethods defaultJudgeMethods].showSquareNotice;
    self.messageButton.messageLabel.hidden = YES;
    SystemNoticeViewController *noticeVC = [[SystemNoticeViewController alloc]initWithQuery:@{@"newMessage":@(newMessage)}];
    [self.navigationController pushViewController:noticeVC animated:YES];

    [JudgeMethods defaultJudgeMethods].showSystemNotice = NO;
    [JudgeMethods defaultJudgeMethods].showSquareNotice = NO;
    [JudgeMethods defaultJudgeMethods].showimageNotice  = NO;
    
}

- (void)selectTags:(id)sender
{
    NSArray *tempArray = [NSArray array];
    if (currentCommodityTag) {
        tempArray = [currentCommodityTag componentsSeparatedByString:@"#"];
    }
    CommodityTagViewController *tagVC  = [[CommodityTagViewController alloc]initWithQuery:@{@"item":tempArray,@"tagcount":@(1)}];
    tagVC.chooseTagDelegate = self;
    [self.navigationController pushViewController:tagVC animated:YES];
    
}
#pragma mark ------------------------- 修改标签回调
- (void)theLabelIsCompleteFromArray:(NSArray *)selectedArray
{
    NSArray *array = [NSArray arrayWithArray:selectedArray];
    if (array.count <1) {
        currentCommodityTag = nil;
        if (tagView) {
            [tagView setTagStr:@"全部"];
        }
        _list.tagStr = nil;
        [_list headerRereshing];
        
    }else{
        currentCommodityTag = [array componentsJoinedByString:@"#"];
        if (tagView) {
            [tagView setTagStr:currentCommodityTag];
        }
        _list.tagStr = currentCommodityTag;
        [_list headerRereshing];
    }
    
}


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

- (void)backAction
{
    
    if ([[User defaultUser].item.sector integerValue] == 30) {
        
        NSString *key = [ NSString stringWithFormat:@"%f+%@",[[NSDate date] timeIntervalSince1970],[User defaultUser].storeItem.storeId];
        NSString *number1 = [NSString stringWithFormat:@"+%d",[JWEvent defaultJWEvent].tattooGalleryTimesOfOnce];
        [MobClick event:@"30_count_gallery_feed" attributes:@{@"number":number1,@"key":key}];
    }
    if (adview) {
        [adview deleteAll];
    }
    
    if (_list) {
        [_list clearMemoryCache];
        _list = NULL;
    }
    if (self.view.subviews) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [super backAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self) {
        if (_list) {
            _list =nil;
        }
    }
}




@end
